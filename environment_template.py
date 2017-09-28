#!/usr/bin/env python
import os
import sys
import argparse
from jinja2 import Template

parser = argparse.ArgumentParser(description='Read a file and substitute environment variables')
parser.add_argument('template',
                    help='Template file',
                    type=argparse.FileType('r'),
                    default=sys.stdin)
parser.add_argument('output',
                    nargs='?',
                    help='Output file',
                    type=argparse.FileType('w+'),
                    default=sys.stdout)


def main():
    args = parser.parse_args()
    template = args.template.read()
    template = Template(template)
    args.output.write(template.render(**os.environ))
    args.output.close()


if __name__ == '__main__':
    main()
