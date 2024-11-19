#!/usr/bin/env python3
import datetime as dt
import sys

import bs4
from rich import table, console
from selenium import webdriver

"""Optima online college progress report."""

OPTIMA_COLLEGE_SITE = "https://b.optima-osvita.org"
LAST_DAY = dt.date(2024, 12, 27)
EXCLUDE_WEEKDAYS = (6,)

now = dt.datetime.now()
TODAY = dt.date(now.year, now.month, now.day)

class PParserException(Exception):
    pass


def guess_semester(date):
    return 2 if 1 < date.month < 8 else 1


def days_between(fromdate, todate, exclude_weekdays=None):
    """Calculate days between two given dates, last day exclusive

    Optionally exclude given weekdays indexes (0-based!).
    For example, to exclude weekends (Sat, Sun), use [5, 6].
    """
    if exclude_weekdays is None:
        exclude_weekdays = []
    daygenerator = (
        fromdate + dt.timedelta(x + 1)
        for x in range((todate - fromdate).days)
    )
    return sum(
        1 for day in daygenerator
        if day.weekday() not in exclude_weekdays
    )


def parse_subject_data(html: bs4.Tag) -> dict:
    data = {}
    barRows = [
        e for e in html.children
        if isinstance(e, bs4.Tag)
        and e.name == "div"
        and "barRow" in e.get("class", [])
    ]
    if len(barRows) != 1:
        raise PParserException(
            f"Element does not has a single barRow child: {html}"
        )
    for child in barRows[0].children:
        if not isinstance(child, bs4.Tag):
            continue
        classes = child.get("class", [])
        if child.name == "h6":
            semester = child.text
        elif child.name == "div" and "progressBarCell" in classes:
            data.setdefault(semester, [])
            item = {
                "task": child.get("data-original-title", child["title"]),
                "late": "progressBarCell--future" not in classes,
                "finished": (
                    "progressBarCell--attempted" in classes or
                    "progressBarCell--submittednotcomplete" in classes
                ),
                "grade": (
                    "progressBarCell--quiz" in classes or
                    "progressBarCell--assign" in classes
                ),
            }
            data[semester].append(item)
    return data


def parse_progress_from_html(soup: bs4.BeautifulSoup) -> dict:
    data = {}
    tasks_el = soup.find("div", class_="progressBarCell").parent.parent.parent
    for el in tasks_el.children:
        if not isinstance(el, bs4.Tag):
            continue
        if el.name == "h3":
            current_subject = el.text
        elif el.name == "div" and "barContainer" in el.get("class", []):
            data[current_subject] = parse_subject_data(el)
    return data


def filter_semester(data, semester: int) -> dict:
    semester_data = {}
    for subject in data:
        for semester_text in data[subject]:
            if f"{semester} семестр" in semester_text:
                semester_data[subject] = data[subject][semester_text]
    return semester_data


def parse_left(data: dict) -> dict:
    ret = {
        "learn": {"todo": 0, "late": 0, "total": 0},
        "grade": {"todo": 0, "late": 0, "total": 0},
    }
    for tasks in data.values():
        for task in tasks:
            task_type = "grade" if task["grade"] else "learn"
            ret[task_type]["total"] += 1
            if not task["finished"]:
                if task["late"]:
                    ret[task_type]["late"] += 1
                else:
                    ret[task_type]["todo"] += 1
    for t in ("learn", "grade"):
        ret[t]["done"] = ret[t]["total"] - ret[t]["todo"] - ret[t]["late"]
    ret["total"] = {
        "todo": ret["learn"]["todo"] + ret["grade"]["todo"],
        "late": ret["learn"]["late"] + ret["grade"]["late"],
        "done": ret["learn"]["done"] + ret["grade"]["done"],
        "total": ret["learn"]["total"] + ret["grade"]["total"],
    }

    return ret


def percent_done_todate(summary, type_):
    data = summary[type_]
    return 100 * data["done"] / (data["done"] + data["late"])


def display_semester(semester, summary):
    n_of_days = days_between(
        TODAY, LAST_DAY, exclude_weekdays=EXCLUDE_WEEKDAYS
    )

    report = table.Table(
        title=f"{TODAY} report for {semester} semester, last date {LAST_DAY}",
        caption=f"Working days left: {n_of_days} "
                f"(excluding days {EXCLUDE_WEEKDAYS})"
    )

    report.add_column("Type")
    report.add_column("Total", justify="right")
    report.add_column("Done", style="green", justify="right")
    report.add_column("Late", style="yellow", justify="right")
    report.add_column("ToDo", style="blue", justify="right")
    report.add_column("% done to date", justify="right")
    report.add_column("Tasks per day left")

    for type_ in ("learn", "grade", None, "total"):
        if type_ is None:
            report.add_section()
            continue
        row_data = summary[type_]
        report.add_row(
            type_.upper(),
            str(row_data["total"]),
            str(row_data["done"]),
            str(row_data["late"]),
            str(row_data["todo"]),
            str(round(percent_done_todate(summary, type_), 2)),
            str(round(row_data["todo"]/n_of_days, 2)),
        )
    out = console.Console()
    out.print()
    out.print(report)


def make_soup() -> bs4.BeautifulSoup:
    driver = webdriver.Firefox()
    driver.get(OPTIMA_COLLEGE_SITE)
    # TODO: implement login and switch to headless
    input("Login and press any key to contunue...")
    html = driver.execute_script("return document.documentElement.outerHTML")
    driver.close()
    soup = bs4.BeautifulSoup(html, "html.parser")
    return soup


def main():
    soup = make_soup()
    data = parse_progress_from_html(soup)
    semester = guess_semester(LAST_DAY)
    semester_data = filter_semester(data, semester)
    result = parse_left(semester_data)
    display_semester(semester, result)


if __name__ == "__main__":
    main()
