#!/bin/bash

echo $(iw dev | grep ssid | awk {'first = $1; $1=""; print $0'}|sed 's/^ //g')


