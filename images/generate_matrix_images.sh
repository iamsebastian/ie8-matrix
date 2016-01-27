#!/bin/bash
_fill=$1;
_mix_to=$2;
_bg=$3;
arg_fill=()
arg_blend=()
arg_bg=()

echo "Chosen colour: $_fill." >&2
echo "Chosen sublement: $_mix_to." >&2
echo "Chosen stroke: $_bg." >&2

#config

_start=0;
_steps=11;

#function definitions

function extract_rgbs {
  for k in `seq 0 2`;
  do
    cut=($(($k*2+2)))
    cut[1]=$((${cut[0]}+1))

    echo "String cuttings (#$k): ${cut[*]}"

    #cut {R}, than {G}, than {B} and convert them to decimas.
    arg_fill[$k]=$(echo "ibase=16; $(echo $_fill | cut -c${cut[0]}-${cut[1]})"|bc);

    #same with 2nd arg
    arg_blend[$k]=$(echo "ibase=16; $(echo $_mix_to | cut -c${cut[0]}-${cut[1]})"|bc);

    #same with 3rd arg
    arg_bg[$k]=$(echo "ibase=16; $(echo $_bg | cut -c${cut[0]}-${cut[1]})"|bc);
  done

  echo "arg_fill: ${arg_fill[*]} ..."
  echo "arg_blend: ${arg_blend[*]} ..."
  echo "arg_bg: ${arg_bg[*]} ..."
}

function calc_blend {
  j=$1;
  new_fill="#"
  bg_blend="#"

  echo -n "Generating blend $j: "

  for k in `seq 0 2`;
  do
    #calculate blend
    blends[$k]=$(((${arg_fill[$k]} * $j + ${arg_blend[$k]} * $_steps_over)/$_steps));
    bg_blends[$k]=$(((${blends[$k]} + ${arg_bg[$k]})/2));
    echo -n "${blends[$k]} (${bg_blends[$k]}) "

    #calculate blend as hex
    hex[$k]=$(echo "obase=16; ${blends[$k]}"|bc);
    hex_bg[$k]=$(echo "obase=16; ${bg_blends[$k]}"|bc);

    #prefix with 0, if hex would be single char, i.e. "0", "a"
    if [ "${blends[$k]}" -lt 16 ]; then
      hex[$k]=0${hex[$k]};
    fi
    if [ "${bg_blends[$k]}" -lt 16 ]; then
      hex_bg[$k]=0${hex_bg[$k]};
    fi

    #string concating hex values. I.e.: "#", "#A5", "#A533", "#A533F9".
    new_fill=$new_fill${hex[$k]}
    bg_blend=$bg_blend${hex_bg[$k]}
  done

  echo " ${hex[*]} (${hex_bg[*]})"

  blend=$(($j*1));
  blend_name=$(($j*10));
  filename="circle_"$blend_name".png";

  alpha=$(echo "obase=16; $(($blend+245))" | bc)
  alpha_fill=$new_fill$alpha;
  alpha_stroke=$bg_blend"AA";

  outer_padding=$(echo "($_start+$_steps+1)/$_steps * 7"|bc -l);
  delta_padding=$(echo "($j*0.6)"|bc -l)
  padding=$(echo "$outer_padding-$delta_padding"|bc -l);

  echo "Padding: $outer_padding - $delta_padding = $padding"
}

function draw_circle_and_save {
  convert \
    -size 17x17 \
    xc:transparent \
    -fill $alpha_fill \
    -stroke $alpha_stroke \
    -strokeWidth 1 \
    -draw "circle 8,8 8,$padding" \
    $filename;
}

function echo_infos {
  echo "Step: $1"
  echo "Blend: $blend"
  echo "Filename: $filename"
  echo "Fill: $alpha_fill"
}

#execution

extract_rgbs

for i in `seq $_start $(($_start + $_steps - 1))`;
do
  _steps_over=$(($_steps-$i));

  calc_blend $i
  echo_infos $i
  draw_circle_and_save $i
done

