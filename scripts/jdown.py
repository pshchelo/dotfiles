#!/usr/bin/env python3
import os
import pathlib
import sys
import requests
"""Download Jira issue attachments from CLI."""
# TODO: proper config load from some JSON in ~/.config or smth
JIRA_SERVER = os.getenv("JIRA_SERVER")
JIRA_USERNAME = os.getenv("JIRA_USERNAME")
JIRA_TOKEN = os.getenv("JIRA_TOKEN")
JIRA_API_VERSION = 2
JIRA_CHUNK_SIZE = 1024 * 1024  # chunk size for downloads (in bytes)
JIRA_TIMEOUT = 60
JIRA_API = JIRA_SERVER.strip("/") + f"/rest/api/{JIRA_API_VERSION}"
# TODO: use proper argparse
if len(sys.argv) < 2:
    sys.exit("Need issue ID")
issue_id = sys.argv[1].upper()
attachment_names = sys.argv[2:]
s = requests.Session()
s.auth = (JIRA_USERNAME, JIRA_TOKEN)
# TODO: interactive mode, list available attachments and ask what to download
# TODO: some progress bar / work being done feedback
# TODO: do not overwrite existing files, may be check integrity somehow first
resp = s.get(JIRA_API + f"/issue/{issue_id}", timeout=JIRA_TIMEOUT)
if resp.status_code != 200:
    sys.exit(f"{resp.status_code}: {resp.text}")
attachments = resp.json()["fields"]["attachment"]
if not attachments:
    sys.exit(f"Issue {issue_id} has no attachments. Wrong issue id?")
# FIXME: could there be duplicate filename but different attachment id?
if not attachment_names:
    download_dir = pathlib.Path(issue_id)
    os.makedirs(download_dir, exist_ok=True)
else:
    download_dir = pathlib.Path(".")
for a in attachments:
    fname = a["filename"]
    if attachment_names and fname not in attachment_names:
        continue
    print(f"downloading {fname}")
    with open(download_dir / fname, "wb") as f:
        with s.get(a["content"], stream=True, timeout=JIRA_TIMEOUT) as r:
            for chunk in r.iter_content(chunk_size=JIRA_CHUNK_SIZE):
                f.write(chunk)
