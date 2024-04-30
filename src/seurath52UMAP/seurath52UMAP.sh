#!/usr/bin/env bash
# vim: set noexpandtab tabstop=2:

args=$(getopt -o hd:b:W:H:C:n:p:s:a: -l help,outdir:,bname:,width:,height:,need_cluster:,nfeatures:,npcs:,resolution:,algorithm: --name "$0" -- "$@") || exit "$?"
eval set -- "$args"

absdir=$(dirname $(readlink -f "$0"))
scriptname=$(basename "$0" .sh)

outdir=.
width=8
height=6
need_cluster=FALSE
nfeatures=2000
npcs=50
resolution=0.5
algorithm=1
while true
do
  case "$1" in
    -h|--help)
      exec cat "$absdir/$scriptname.txt"
      ;;
    -d|--outdir)
      outdir=$2
      shift 2
      ;;
    -b|--bname)
      bname=$2
      shift 2
      ;;
    -W|--width)
      width=$2
      shift 2
      ;;
    -H|--height)
      height=$2
      shift 2
      ;;
		-C|--need_cluster)
			need_cluster=$2
			shift 2
			;;
		-n|--nfeatures)
			nfeatures=$2
			shift 2
			;;
		-p|--npcs)
			npcs=$2
			shift 2
			;;
		-s|--resolution)
			resolution=$2
			shift 2
			;;
		-a|--algorithm)
			algorithm=$2
			shift 2
			;;
    --)
      shift
      break
      ;;
    *)
      echo "$0: not implemented option: $1" >&2
      exit 1
      ;;
  esac
done

[ "$bname" ] || { echo "$scriptname.sh: -b|--bname must be specified!"; exit 1; }

function cmd {
local f=$1
set -x
mkdir -p "$outdir" && R -s --vanilla \
  -e "infile='$f'"\
  -e "outdir='$outdir'"\
  -e "bname='$bname'" \
  -e "width=$width" \
  -e "height=$height" \
	-e "need_cluster=$need_cluster" \
	-e "nfeatures=$nfeatures" \
	-e "npcs=$npcs" \
	-e "resolution=$resolution" \
	-e "algorithm=$algorithm" \
  -e "source('$absdir/R/$scriptname.R')"
}

if (($#))
then
    cmd "$@"
fi
