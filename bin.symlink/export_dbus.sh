#!/bin/bash
touch "$HOME/.Xdbus"
chmod 0600 "$HOME/.Xdbus"
echo "$DBUS_SESSION_BUS_ADDRESS" > "$HOME/.Xdbus"
