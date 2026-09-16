#!/usr/bin/env python

import sys
import json
from argparse import ArgumentParser
import pprint


def parse_cmd_args():
    parser = ArgumentParser()

    parser.add_argument("-c", "--conf_file", help="URL file", type=str, required=True)
    parser.add_argument(
        "-v",
        "--memgraph_version",
        help="Version of memgraph to use",
        type=str,
        choices=["3.11.0", "3.12.0", "3.13.0", "3.13.1"],
        required=True,
    )
    parser.add_argument(
        "-t",
        "--memgraph_type",
        help="Type of memgraph to use",
        type=str,
        choices=["memgraph", "memgraph-mage"],
        required=True,
    )
    parser.add_argument(
        "-s",
        "--system_version",
        help="System to use",
        type=str,
        choices=["ubuntu-24.04", "ubuntu-26.04"],
        required=True
    )
    parser.add_argument(
        "-a",
        "--architecture",
        help="Architecture",
        type=str,
        choices=["amd64", "arm64"],
        required=True
    )

    cmd_args = parser.parse_args()
    return cmd_args


def main(**kwargs):
    #print(kwargs)
    urls = []



    if kwargs['memgraph_type'] == 'memgraph-mage':
        urls.append(kwargs['memgraph_urls']['memgraph'][kwargs['memgraph_version']][kwargs['architecture']][kwargs['system_version']])

    urls.append(kwargs['memgraph_urls'][kwargs['memgraph_type']][kwargs['memgraph_version']][kwargs['architecture']][kwargs['system_version']])
    for entry in urls:
        sys.stdout.write(f'{entry} ')
    print()
    return urls

    # with open('memgraph_urls.json', 'w', encoding='utf-8') as out_file:
    #    json.dump(kwargs, out_file, indent=2)


if __name__ == "__main__":
    run_args = parse_cmd_args()
    with open(run_args.conf_file, "r", encoding="utf-8") as conf_file:
        # main_args = yaml.safe_load(conf_file)
        main_args = json.load(conf_file)
    main_kwargs = {
        'memgraph_urls': main_args,
    }
    main_kwargs.update(vars(run_args))
    main(**main_kwargs)
