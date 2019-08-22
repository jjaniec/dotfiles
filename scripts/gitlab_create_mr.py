#!/usr/bin/env python3
#d Create a merge request on a $GITLAB_URL server

#u GITLAB_URL='https://example.com/' GITLAB_TOKEN='' ./gitlab_create_mr.py repo_subdir/repo dev master

import json
import sys
import typing
from typing import List, Union
import requests
import urllib
import time
import logging
import re
import os

if (os.environ.get("GITLAB_TOKEN", '') != ''):
    GITLAB_TOKEN = os.environ.get("GITLAB_TOKEN")
else:
    GITLAB_TOKEN = ''

GITLAB_URL = os.environ.get('GITLAB_URL', '')

logger = logging.getLogger()


def str_urlencode(str):
    return urllib.parse.quote(str, safe='')


def create_merge_request(project: str, source_branch: str, target_branch: str, title: str = None) -> int:
    try:
        r = requests.post(
            f"{GITLAB_URL}/api/v4/projects/{str_urlencode(project)}/merge_requests",
            headers={
                'PRIVATE-TOKEN': GITLAB_TOKEN
            },
            data={
                "source_branch": source_branch,
                "target_branch": target_branch,
                "title": title if title != None and title != '' else f'Merge {source_branch} -> {target_branch}'
            }
        )
        if r.status_code >= 200 and r.status_code < 300:
            rjson = r.json()
            print(
                f"Created merge request {project} {source_branch}->{target_branch}\nid: {rjson['id']}\niid: {rjson['iid']}\nweb_url: {rjson['web_url']}")
            return rjson['iid']
        elif r.status_code == 409:
            print(r.text)
            resp = input("Use current open merge request ? [y/n]")
            if resp == "y":
                message_str = json.loads(r.text)["message"][0]
                match = re.search(r'\d+$', message_str)
                if match is not None:
                    return match.group(0)
        else:
            logger.error(r.status_code, r.text)
            return -1
    except Exception as e:
        logger.exception(e)
    return -1


if __name__ == "__main__":
    try:
        if len(sys.argv) < 4:
            print(
                f"Usage: [GITLAB_URL=...] {sys.argv[0]} project_dir/project source_branch target_branch [title]")
            sys.exit(1)
        r = create_merge_request(
            sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4] if len(sys.argv) >= 5 else None)
        if r != -1:
            print(f"#{r}")
        sys.exit(0 if r != -1 else 1)
    except Exception as e:
        logger.exception(e)
        sys.exit(1)
