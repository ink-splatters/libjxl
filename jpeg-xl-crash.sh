#!/bin/sh

./benchmark_xl  --print_details --print_more_stats  --print_distance_percentiles  --save_decompressed --save_heatmap --show_progress --input $1 # crashes it; input is *.jxl
