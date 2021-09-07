#!/bin/bash

nmcli radio all | awk 'FNR == 2 {print $2}'
