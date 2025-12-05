#!/usr/bin/env python3
# coding=UTF-8

# saved to ~/bin/batcharge.py and from
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/#my-right-prompt-battery-capacity

import math
import re
import subprocess
import sys

result = subprocess.run(
    ["ioreg", "-rc", "AppleSmartBattery"],
    capture_output=True,
    text=True
)
output = result.stdout

# Match top-level "MaxCapacity" = <number> (not nested in BatteryData)
# Use regex to find standalone capacity values
max_match = re.search(r'^\s+"MaxCapacity"\s*=\s*(\d+)', output, re.MULTILINE)
cur_match = re.search(r'^\s+"CurrentCapacity"\s*=\s*(\d+)', output, re.MULTILINE)

if not max_match or not cur_match:
    sys.exit(0)  # No battery or can't parse

b_max = float(max_match.group(1))
b_cur = float(cur_match.group(1))

if b_max == 0:
    sys.exit(0)

charge = b_cur / b_max
charge_threshold = int(math.ceil(10 * charge))

# Output
total_slots = 10
filled = int(math.ceil(charge_threshold * (total_slots / 10.0))) * '◼'
# old arrow: ▹▸▶
empty = (total_slots - len(filled)) * '◻'

color_green = '%{[32m%}'
color_yellow = '%{[33m%}'
color_red = '%{[31m%}'
color_reset = '%{[00m%}'
color_out = (
    color_green if len(filled) > 6
    else color_yellow if len(filled) > 4
    else color_red
)

out = color_out + filled + empty + color_reset
sys.stdout.write(out)
