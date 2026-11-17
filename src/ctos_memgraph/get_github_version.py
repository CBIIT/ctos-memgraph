#!/usr/bin/env python

# import pprint
# from datetime import datetime as dt
import json
from argparse import ArgumentParser
import requests
import yaml
import boto3
from dateutil.parser import parse as du_parser


def get_version_from_ssm(param_name=None):
    ssm_sess = boto3.client("ssm")
    try:
        param_data = ssm_sess.get_parameter(Name=param_name)
    except Exception:
        # except SSM.Client.exceptions.ParameterNotFound:
        param_data = {}
    else:
        param_data = json.loads(param_data)
    return param_data


def put_version_to_ssm(param_name=None, version_data=None):
    ssm_sess = boto3.client("ssm")
    if isinstance(version_data, dict):
        ssm_sess.put_parameter(
            Name=param_name, Value=json.dumps(version_data), Type="String"
        )
    else:
        print(
            f"Unable to write version, value {version_data} is not dict, is {type(version_data)}"
        )


def get_versions(owner=None, repo=None):

    version_info = {"versions": {}, "latest_release": {}}
    result = requests.get(
        f"https://api.github.com/repos/{owner}/{repo}/releases", timeout=10
    )
    for entry in result.json():
        title = ""
        breaking_changes = False
        for body_line in entry["body"].split("\n"):
            if not title:
                title = body_line.strip()
            if "breaking changes" in body_line.lower():
                breaking_changes = True
                break
        # print(f"{entry['tag_name']} - {title} - Breaking {breaking_changes}")
        release_date = None
        try:
            date_str = title.split("-")[-1].strip()
            release_date = du_parser(timestr=date_str).strftime("%Y-%m-%d")
        except Exception as excpt:
            print(f'Unable to parse "{date_str}": {excpt}')

        cur_entry = {
            "version": entry["tag_name"],
            "breaking": breaking_changes,
            "title": title,
            "release_date": release_date,
        }
        if not version_info["latest_release"]:
            version_info["latest_release"] = dict(cur_entry)
        if release_date > version_info["latest_release"]["release_date"]:
            version_info["latest_release"] = dict(cur_entry)

        version_info["versions"][entry["tag_name"]] = dict(cur_entry)
    print(f"latest release: {version_info['latest_release']}")

    return version_info


def parse_cmd_args():
    parser = ArgumentParser()

    parser.add_argument("-c", "--conf_file", help="conf file", type=str, required=True)

    cmd_args = parser.parse_args()
    return cmd_args


def main(**kwargs):
    # print(kwargs)
    latest_version = get_version_from_ssm(param_name="latest_memgraph_ver")
    print(f"Latest SSM version: {latest_version}")

    version_info = get_versions(owner=kwargs.get("owner"), repo=kwargs.get("repo"))
    if not latest_version:
        put_version_to_ssm(
            param_name="latest_memgraph_ver",
            version_data=version_info["latest_version"],
        )
    else:
        if (
            latest_version["release_date"]
            < version_info["latest_release"]["release_date"]
        ):
            put_version_to_ssm(
                param_name="latest_memgraph_ver",
                version_data=version_info["latest_release"],
            )

    # print(version_info)


if __name__ == "__main__":
    run_args = parse_cmd_args()
    with open(run_args.conf_file, "r", encoding="utf-8") as conf_file:
        main_args = yaml.safe_load(conf_file)
    main(**main_args)
