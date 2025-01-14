#!/usr/bin/env python3
import argparse
import os
import pathlib
import sys
import requests
"""Download Jira issue attachments from CLI."""

# TODO: proper config load from some JSON in ~/.config or smth
def make_cli():
    parser = argparse.ArgumentParser(
        prog="jdown",
        description="Download Jira ticket attachments via CLI"
    )
    parser.add_argument("issue", help="Jira issue (case-insensitive)")
    parser.add_argument("attachments", nargs="*",
                        help="Attachment names. If none specified, all existing "
                             "attachments for the given issue will be downloaded")
    parser.add_argument("--jira-version", default="2",
                        help="Jira API version (default is 2)")
    parser.add_argument("--jira-server", default=os.getenv("JIRA_SERVER"),
                        help="URL of Jira server, defaults to JIRA_SERVER env var")
    parser.add_argument("--jira-username", default=os.getenv("JIRA_USERNAME"),
                        help="Jira user name, defaults to JIRA_USERNAME env var")
    parser.add_argument("--jira-token", default=os.getenv("JIRA_TOKEN"),
                        help="Jira API token, defaults to JIRA_TOKEN env var")
    parser.add_argument("--jira-timeout", type=int, default=60,
                        help="HTTP timeout for Jira API, in seconds, "
                             "defaults to 60.")
    parser.add_argument("--jira-chunk_size", type=int, default=1024*1024,
                         help="Downolad chunk size in bytes, defaults to 1MB")
    return parser.parse_args()


def discover_attachments(args, session):
    resp = session.get(
        args.jira_server.strip("/")
        + f"/rest/api/{args.jira_version}"
        + f"/issue/{args.issue}",
        timeout=args.jira_timeout,
    )
    if resp.status_code != 200:
        sys.exit(f"{resp.status_code}: {resp.text}")
    attachments = resp.json()["fields"]["attachment"]
    if args.attachments:
        return [a for a in attachments if a["filename"] in args.attachments]
    else:
        return attachments


def jdown(args):
    s = requests.Session()
    s.auth = (args.jira_username, args.jira_token)

    attachments = discover_attachments(args, s)
    if not attachments:
        sys.exit(f"Issue {args.issue} has no requested attachments.")

    # TODO: interactive mode, list available attachments and ask what to download
    # TODO: some progress bar / work being done feedback
    # TODO: do not overwrite existing files, may be check integrity somehow first
    # TODO: download in parallel
    # FIXME: could there be duplicate filename but different attachment id?
    if not args.attachments:
        download_dir = pathlib.Path(args.issue)
        os.makedirs(download_dir, exist_ok=True)
    else:
        download_dir = pathlib.Path(".")
    for a in attachments:
        fname = a["filename"]
        print(f"downloading {fname}")
        with open(download_dir / fname, "wb") as f:
            with s.get(
                a["content"], stream=True, timeout=args.jira_timeout
            ) as r:
                for chunk in r.iter_content(chunk_size=args.jira_chunk_size):
                    f.write(chunk)

if __name__ == "__main__":
    jdown(make_cli())
