#!/bin/bash

BAT=/sys/class/power_supply/BAT1

cat $BAT/capacity
cat $BAT/status

