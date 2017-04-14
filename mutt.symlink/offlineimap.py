#!/usr/bin/env python2

import locale
from subprocess import Popen, PIPE
from os import environ, path

encoding = locale.getdefaultlocale()[1]

def get_password(p):
    environ['DBUS_SESSION_BUS_ADDRESS'] = open(
            path.expandvars("$HOME/.Xdbus")).read()
    (out, err) = Popen(["pass", p],
            stdout=PIPE).communicate()
    return out.decode(encoding).splitlines()[0].strip()
