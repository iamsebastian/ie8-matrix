#!/bin/bash
_fill=$1;
_mix_to=$2;

echo "Chosen colour: $_fill." >&2
echo "Chosen sublement: $_mix_to." >&2

_start=0;
_steps=11;

_red_a=$(echo "ibase=16; $(echo $_fill | cut -c2-3)"|bc);
_green_a=$(echo "ibase=16; $(echo $_fill | cut -c4-5)"|bc);
_blue_a=$(echo "ibase=16; $(echo $_fill | cut -c6-7)"|bc);

_red_b=$(echo "ibase=16; $(echo $_mix_to | cut -c2-3)"|bc);
_green_b=$(echo "ibase=16; $(echo $_mix_to | cut -c4-5)"|bc);
_blue_b=$(echo "ibase=16; $(echo $_mix_to | cut -c6-7)"|bc);

for i in `seq $_start $(($_start + $_steps - 1))`;
do
  _steps_over=$(($_steps-$i));

  _red_blend=$((($_red_a * $i + $_red_b * $_steps_over)/$_steps));
  _green_blend=$((($_green_a * $i + $_green_b * $_steps_over)/$_steps));
  _blue_blend=$((($_blue_a * $i + $_blue_b * $_steps_over)/$_steps));

  echo "Blends: $_red_blend, $_green_blend, $_blue_blend";

  _nu_red_hex=$(echo "obase=16; $_red_blend"|bc);
  _nu_green_hex=$(echo "obase=16; $_green_blend"|bc);
  _nu_blue_hex=$(echo "obase=16; $_blue_blend"|bc);

  if [ "$_red_blend" -lt 16 ]; then
    _nu_red_hex=0$_nu_red_hex;
  fi
  if [ "$_green_blend" -lt 16 ]; then
    _nu_green_hex=0$_nu_green_hex;
  fi
  if [ "$_blue_blend" -lt 16 ]; then
    _nu_blue_hex=0$_nu_blue_hex;
  fi

  _nufill=\#$_nu_red_hex$_nu_green_hex$_nu_blue_hex;
  _blend=$(($i*10));
  echo "Blend: $_blend"
  #_alpha=$(echo "obase=16; $((234))" | bc)
  _alpha=$(echo "obase=16; $(($_blend+145))" | bc)
  _filename=circle_$_blend.png;
  _alpha_fill=$_nufill$_alpha;
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
