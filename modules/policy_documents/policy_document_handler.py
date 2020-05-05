Skip to content
Search or jump to…

Pull requests
Issues
Marketplace
Explore
 
@saisantoshg 
plus3it
/
terraform-aws-tardigrade-iam-principals
3
02
 Code
 Issues 6
 Pull requests 1 Actions
 Security 0
 Insights
terraform-aws-tardigrade-iam-principals/modules/policy_documents/policy_document_handler.py /
@lorengordon lorengordon Updates policy doc handler to expect all values to be jsonencoded
533f44c 18 days ago
@lorengordon@confusdcodr
127 lines (97 sloc)  3.19 KB
  
"""IAM policy document handler.
Merges an arbitrary number of policy document templates.
"""
from __future__ import print_function

import argparse
import collections
import copy
import io
import json
import logging
import os
import sys

DEFAULT_LOG_LEVEL = logging.DEBUG
LOG_LEVELS = collections.defaultdict(
    lambda: DEFAULT_LOG_LEVEL,
    {
        "critical": logging.CRITICAL,
        "error": logging.ERROR,
        "warning": logging.WARNING,
        "info": logging.INFO,
        "debug": logging.DEBUG,
    },
)

# Lambda initializes a root logger that needs to be removed in order to set a
# different logging config
root = logging.getLogger()
if root.handlers:
    for handler in root.handlers:
        root.removeHandler(handler)

logging.basicConfig(
    filename="iam_handler.log",
    format="%(asctime)s.%(msecs)03dZ [%(name)s][%(levelname)-5s]: %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S",
    level=LOG_LEVELS[os.environ.get("LOG_LEVEL", "").lower()],
)
log = logging.getLogger(__name__)


def _join_paths(*paths):
    return "/".join(*paths).replace("//", "/")


def _read(path, encoding="utf8", **kwargs):
    """Read a file."""
    with io.open(path, encoding=encoding, **kwargs) as fh_:
        return fh_.read()


def _merge_iam_policy_doc(doc1, doc2):
    # adopt doc2's Id
    if doc2.get("Id"):
        doc1["Id"] = doc2["Id"]

    # let doc2 upgrade our Version
    if doc2.get("Version", "") > doc1.get("Version", ""):
        doc1["Version"] = doc2["Version"]

    # merge in doc2's statements, overwriting any existing Sids
    for doc2_statement in doc2["Statement"]:
        if not doc2_statement.get("Sid"):
            doc1["Statement"].append(doc2_statement)
            continue

        seen = False
        for index, doc1_statement in enumerate(doc1["Statement"]):
            if doc1_statement.get("Sid") == doc2_statement.get("Sid"):
                doc1["Statement"][index] = doc2_statement
                seen = True
                break

        if not seen:
            doc1["Statement"].append(doc2_statement)

    return doc1


def main(name, template_paths, template, **kwargs):
    """Merge policy documents for all template paths."""
    iam_policy_doc = {"Statement": []}

    ret = {
        "name": name,
        "policy": copy.deepcopy(iam_policy_doc),
    }

    log.info("=" * 40)
    log.info("name = %s", name)
    log.info("template = %s", template)
    log.info("template_paths = %s", template_paths)

    for path in template_paths:
        policy_path = _join_paths([path, template])

        if os.path.isfile(policy_path):
            ret["policy"] = _merge_iam_policy_doc(
                ret["policy"], json.loads(_read(policy_path))
            )

    ret["policy"] = json.dumps(ret["policy"])

    return ret


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "json",
        type=argparse.FileType("r"),
        default=sys.stdin,
        help="Parses input from a json file or stdin",
    )

    args = parser.parse_args()

    json_args = {}
    with args.json as fp_:
        json_args = json.load(fp_)

    for arg, val in json_args.items():
        json_args[arg] = json.loads(val)

    sys.exit(print(json.dumps(main(**json_args))))
© 2020 GitHub, Inc.
Terms
Privacy
Security
Status
Help
Contact GitHub
Pricing
API
Training
Blog
About
