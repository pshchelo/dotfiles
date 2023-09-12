#!/home/ubuntu/.virtualenvs/jira/bin/python3
# /usr/bin/env python3
import os
import pathlib
import sys

from jira import JIRA

"""Download Jira issue attachments from CLI."""
# TODO: proper config load from some JSON in ~/.config or smth
JIRA_SERVER = os.getenv("JIRA_SERVER")
JIRA_USERNAME = os.getenv("JIRA_USERNAME")
JIRA_TOKEN = os.getenv("JIRA_TOKEN")
# TODO: use proper argparse
if len(sys.argv) < 2:
    sys.exit("Need issue ID")
issue_id = sys.argv[1].upper()
attachment_names = sys.argv[2:]
# TODO: explore using raw requests and JSON parsing
jira = JIRA(server=JIRA_SERVER, basic_auth=(JIRA_USERNAME, JIRA_TOKEN))
# TODO: interactive mode, list available attachments and ask what to download
# TODO: some progress bar / work being done feedback
issue = jira.issue(issue_id)
# FIXME: could there be duplicate .filename but different attachment id?
download_dir = pathlib.Path(issue_id)
os.makedirs(download_dir, exist_ok=True)
for a in issue.fields.attachment:
    if attachment_names and a.filename not in attachment_names:
        continue
    print(f"downloading {a.filename}")
    with open(download_dir / a.filename, "wb") as f:
        f.write(a.get())
