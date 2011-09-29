#!/bin/bash

find /home/pblair/normalized/ -type f | awk -F/ '{print $NF}' | xargs ./convert_index_to_filenames.pl | tee filename_map.txt
