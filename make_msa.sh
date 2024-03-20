#!/bin/bash

# inputs
in_fasta="$1"
out_dir="$2"

# resources
CPU="$3"
MEM="$4"

# template database
DB_TEMPL="$5"

# current script directory (i.e., pipe directory)
SCRIPT=`realpath -s $0`
export PIPE_DIR=`dirname $SCRIPT`

echo "Running PSIPRED"
mkdir -p $out_dir/log
$PIPE_DIR/input_prep/make_ss.sh $out_dir/t000_.msa0.a3m $out_dir/t000_.ss2 > $out_dir/log/make_ss.stdout 2> $out_dir/log/make_ss.stderr

if [ ! -s $out_dir/t000_.hhr ]
then
    echo "Running hhsearch"
    HH="hhsearch -b 50 -B 500 -z 50 -Z 500 -mact 0.05 -cpu $CPU -maxmem $MEM -aliw 100000 -e 100 -p 5.0 -d $DB_TEMPL"
    
    cat $out_dir/t000_.ss2 $out_dir/t000_.msa0.a3m > $out_dir/t000_.msa0.ss2.a3m
    $HH -i $out_dir/t000_.msa0.ss2.a3m -o $out_dir/t000_.hhr -atab $out_dir/t000_.atab -v 0
fi
