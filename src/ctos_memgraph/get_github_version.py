#!/usr/bin/env python

import requests
from argparse import ArgumentParser
import pprint
import yaml
from dateutil.parser import parse as du_parser
from datetime import datetime as dt

def get_versions(owner=None, repo=None):

    version_info = {}
    latest_release = None
    result = requests.get(f'https://api.github.com/repos/{owner}/{repo}/releases')
    for entry in result.json():
        title = ''
        breaking_changes = False
        for body_line in entry['body'].split('\n'):
            if not title:
                title = body_line.strip()
            if 'breaking changes' in body_line.lower():
                breaking_changes = True
                break
        #print(f"{entry['tag_name']} - {title} - Breaking {breaking_changes}")
        release_date = None
        try:
            date_str = title.split('-')[-1].strip()
            release_date = du_parser(timestr=date_str).strftime('%Y-%m-%d')
        except Exception as excpt:
            print(f'Unable to parse "{date_str}": {excpt}')

        cur_entry = {
            'version': entry['tag_name'],
            'breaking': breaking_changes,
            'title': title,
            'release_date': release_date
        }
        if not latest_release:
            latest_release = dict(cur_entry)
        if release_date > latest_release['release_date']:
            latest_release = dict(cur_entry)

        version_info[entry['tag_name']] = dict(cur_entry)
    print(f'latest release: {latest_release}')

    return version_info


def parse_cmd_args():
    parser = ArgumentParser()

    parser.add_argument("-c", "--conf_file", help="conf file", type=str, required=True)

    cmd_args = parser.parse_args()
    return cmd_args

def main(**kwargs):
    print(kwargs)
    version_info = get_versions(owner=kwargs.get('owner'), repo=kwargs.get('repo'))
    print(version_info)

if __name__ == '__main__':
    run_args = parse_cmd_args()
    with open(run_args.conf_file, "r", encoding="utf-8") as conf_file:
        main_args = yaml.safe_load(conf_file)
    main(**main_args)


