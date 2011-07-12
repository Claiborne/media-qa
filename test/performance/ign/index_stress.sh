#!/bin/sh

autobench --single_host --host1 www.ign.com --uri1 / --quiet --low_rate 1 --high_rate 5 --rate_step 1 --num_call 1 --num_conn 10 --timeout 5 --file results.csv

bench2graph results.csv results.pdf
