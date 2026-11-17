#!/bin/bash
# usage: replay.sh <blind_id> <N>   (command text on stdin, original as in report)
S=/mnt/scratch/tmp/rcrescore1117/scorer
id=$1; n=$2; d=$S/out/replays/$id; mkdir -p $d
sed -e "s#/home/monkey/scratch/rc1-bundle/corpus/A1/hookcanary-report.md#$S/corpus/A1/hookcanary-report.md#g" \
    -e "s#/home/monkey/reasoning-compiler-freeze/hookcanary-report.md#$S/corpus/A1/hookcanary-report.md#g" \
    -e "s#/home/monkey/scratch/rc1-bundle#$S#g" > $d/cmd$n.sh
cd $S && timeout 300 bash $d/cmd$n.sh > $d/cmd$n.out 2>&1; echo $? > $d/cmd$n.exit
echo "--- exit $(cat $d/cmd$n.exit)"; cat $d/cmd$n.out
