#!/usr/bin/env python3
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


def fetch_running_pipelines(project: str, ref: str) -> Union[List[int], int]:
    try:
        r = requests.get(
            f"{GITLAB_URL}/api/v4/projects/{str_urlencode(project)}/pipelines{f'?ref={ref}' if ref != '' else ''}",
            headers={
                'PRIVATE-TOKEN': GITLAB_TOKEN
            }
        )
        if r.status_code >= 200 and r.status_code < 300:
            return list(map(lambda e: e["id"], r.json()))
        else:
            logger.error(f"Error while fetching running pipelines: {r.json()}")
            return -1
    except Exception as e:
        logger.exception(e)
    return -1


def fetch_pipeline_status(project: str, pipeline_id: int) -> Union[str, int]:
    try:
        r = requests.get(
            f"{GITLAB_URL}/api/v4/projects/{str_urlencode(project)}/pipelines/{pipeline_id}",
            headers={
                'PRIVATE-TOKEN': GITLAB_TOKEN
            }
        )
        if r.status_code >= 200 and r.status_code < 300:
            return r.json()["status"]
        else:
            logger.error(r.status_code, r.json())
            return -1
    except Exception as e:
        logger.exception(e)
    return -1


def get_pipelines_status(project: str, ref: str) -> Union[List[str], int]:
    try:
        pipelines_id = fetch_running_pipelines(project, ref)
        pipelines_status = list(
            map(lambda e: (e, fetch_pipeline_status(project, e)), pipelines_id))
        return pipelines_status
    except Exception as e:
        logger.exception(e)
    return -1


def format_pipelines_status(pipelines_status: Union[List[str], int]):
    if not isinstance(pipelines_status, list):
        raise TypeError
    for ps in pipelines_status:
        print(f"#{ps[0]}: {ps[1]}")
    return 0


if __name__ == "__main__":
    try:
        if len(sys.argv) < 2:
            print(f"Usage: [GITLAB_URL=...] {sys.argv[0]} project_dir/project [ref]")
            sys.exit(1)
        p = get_pipelines_status(
            sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else '')
        format_pipelines_status(p)
        sys.exit(1 if "failed" in p else 0)
    except Exception as e:
        logger.exception(e)
        sys.exit(1)
