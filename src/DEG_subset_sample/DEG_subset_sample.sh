#!/usr/bin/env bash
# vim: set noexpandtab tabstop=2:

args=$(getopt -o hd:b:q:n:s:F:m:c: -l help,outdir:,bname:,q_val:,number:,slope:,fold:,model:,celltype: --name "$0" -- "$@") || exit "$?"
eval set -- "$args"

absdir=$(dirname $(readlink -f "$0"))
scriptname=$(basename "$0" .sh)

outdir=.
q_val=0.01
number=200
fold=0.5
slope=1
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
		-q|--q_val)
			q_val=$2
			shift 2
			;;
		-n|--number)
			number=$2
			shift 2
			;;
		-s|--slope)
			slope=$2
			shift 2
			;;
		-F|--fold)
			fold=$2
			shift 2
			;;
		-m|--model)
			model=$2
			shift 2
			;;
		-c|--celltype)
			celltype+=("$2")
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
	-e "model='$model'"\
	-e "outdir='$outdir'"\
	-e "bname='$bname'" \
	-e "celltype=$(basharr2Rvec.sh -c -- "${celltype[@]}")"\
	-e "q_val=$q_val" \
	-e "number=$number" \
	-e "slope=$slope" \
	-e "fold=$fold" \
	-e "source('$absdir/R/$scriptname.R')"
}

if (($#))
then
	cmd "$@"
fi
