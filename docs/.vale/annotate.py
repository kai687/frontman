"""Write GitHub annotations for Vale data."""

import argparse
from dataclasses import dataclass
from enum import Enum
from io import TextIOWrapper


class LogLevel(Enum):
    ERROR = "error"
    WARNING = "warning"
    SUGGESTION = "suggestion"

    @staticmethod
    def from_string(s):
        try:
            return LogLevel[s.upper()]
        except KeyError:
            raise ValueError(f"{s} is not a valid log level")


@dataclass
class Record:
    filename: str
    line: str
    column: str
    severity: LogLevel
    check: str
    message: str


def parse_vale_log(file: TextIOWrapper) -> list[Record]:
    """Assigns Vale log data to a dictionary."""
    logs: list[Record] = []

    for line in file:
        filename, line, column, severity, check, message = line.split(":")
        logs.append(
            Record(
                filename, line, column, LogLevel.from_string(severity), check, message
            )
        )
    return logs


def annotate(record: Record) -> tuple[str, bool]:
    """Format each log record with GitHub annotations."""
    level = record.severity.value
    if record.severity == LogLevel.SUGGESTION:
        level = "notice"
    annotation = f"::{level} file={record.filename},line={record.line},col={record.column},title={record.check}::{record.message}"
    error_found = True if record.severity == LogLevel.ERROR else False
    return annotation, error_found


if __name__ == "__main__":
    log_list: list[str] = []
    error_list: list[str] = []
    parser = argparse.ArgumentParser()
    parser.add_argument("log", help="Log file from running Vale", type=str)
    args = parser.parse_args()

    with open(args.log) as f:
        vale_data = parse_vale_log(f)

    errors = False
    for entry in vale_data:
        ann, err = annotate(entry)
        if err:
            errors = True

        print(ann)

    if errors:
        print(
            "Vale found errors against our style guide. Check the annotations in your PR and fix the errors."
        )
