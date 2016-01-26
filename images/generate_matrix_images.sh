#!/bin/bash
_fill=$1;

echo "Chosen colour: $_fill." >&2

for i in {0..10};
do
  _blend=$(($i*10));
  echo "Blend: $_blend"
  _alpha=$(echo "obase=16; $(($_blend+155))" | bc)
  _filename=circle_$_blend.png;
  _alpha_fill=$_fill$_alpha;
  _padding=$(echo "12-$i*1.1"|bc -l);
  echo "Filename: $_filename";
  echo "Fill: $_alpha_fill";
  convert \
    -size 31x31 \
    xc:transparent \
    -fill $_alpha_fill \
    -draw "circle 15,15 15,$_padding" \
    $_filename;
done
