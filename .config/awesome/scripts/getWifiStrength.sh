#!/bin/bash

DEV=$(iw dev | awk '$1=="Interface"{print $2}')
echo $(iwconfig $DEV | grep -i signal | sed -r 's/^([^.]+).*$/\1/; s/^[^0-9]*([0-9]+).*$/\1/')

