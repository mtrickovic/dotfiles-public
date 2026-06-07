#!/bin/bash

journalctl -k -b --no-pager > ~/kernel.txt
journalctl -k -b -p err --no-pager > ~/kernel-errors.txt
journalctl -k --no-pager | grep -B 30 "Call Trace" > ~/trace-full.txt
