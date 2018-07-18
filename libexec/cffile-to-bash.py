#!/usr/bin/env python
# -*- coding: utf-8 -*-
# SPDX-License-Identifier: LGPL-2.1-or-later
# Copyright © 2017-2018 ANSSI. All Rights Reserved.

from __future__ import print_function
import json
import sys
import os.path

def usage_and_exit():
    "print usage"
    print("Usage: %s json.file" % sys.argv[0], file=sys.stderr)
    sys.exit(1)

def string_convert(my_str):
    """Translate characters in a string to something that look like a Bash variable
    - All letters become uppercase
    - "-" -> "_"
    - "." -> ""
    """
    new_str = list(my_str.upper())

    i=0
    for v in my_str:
        if v == ".":
            del new_str[i]
            continue
        if v == "-":
            new_str[i] = "_"

        i+=1
    return "".join(new_str)

def json_to_var(json_obj, prefix="", dict_func=None):
    "convert json object to bash variables"

    if dict_func == None: dict_func=json_to_var

    vars = ""
    for k in json_obj:
        # skip comments
        if k == "_comment": continue

        if prefix:
            local_prefix = prefix + "_" + string_convert(k)
        else:
            local_prefix = string_convert(k)

        if isinstance(json_obj[k], dict):
            vars +=  dict_func(json_obj[k], local_prefix)
        elif isinstance(json_obj[k], unicode) \
             or isinstance(json_obj[k], bool):
            vars += "%s=%s\n" % (local_prefix, varify(json_obj[k]))
        else:
            raise NotImplementedError, type(json_obj[k])
    return vars

def varify(var):
    """turn a python variable value in a bash variable value

    e.g. True => 1, False => 0"""

    if isinstance(var, unicode):
        return '"' + expand_home(var) + '"' # nothing to do
    elif isinstance(var, bool):
        return "1" if var else "0"
    else:
        raise NotImplementedError, type(var)

def expand_home(my_str):
    if my_str.startswith("~"):
        return os.path.expanduser(my_str)

    return my_str


def json_to_array(json_obj, prefix=""):
    """Translate a Python dict in a Bash associative array

    Return a string"""
    if not isinstance(json_obj, dict): raise NotImplementedError

    # TODO: are we in a nested map ?
    nested=""
    notnested=dict()

    for k,v in json_obj.iteritems():
        # this is a nested dict
        if isinstance(v, dict):
            nested += json_to_array(v, prefix + "_" + string_convert(k))
        else:
            notnested[k]=v

    return "declare -A %s\n" % string_convert(prefix) + \
            "\n".join(["{}[\"{}\"]={}".format(prefix, k, varify(v)) for \
                k, v in notnested.iteritems() if k != "_comment"]) + "\n" + \
            nested

if __name__ == "__main__":
    if len(sys.argv) != 2:
        usage_and_exit()
    try:
        fd=open(sys.argv[1], "r")
    except IOError, e:
        print("error: %s" % e)
        sys.exit(1)
    b=json.load(fd)
    print("# This file has been automaticatilly generated from %s" % sys.argv[1])
    print("# flattened JSON tree of the configuration file")
    print(json_to_var(b, prefix="CLIP"))
    print("# Same JSON tree, in the form of an associative array")
    print(json_to_var(b, prefix="CLIP", dict_func=json_to_array))


