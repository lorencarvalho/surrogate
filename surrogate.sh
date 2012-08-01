#!/bin/bash

# ----
# SURROGATE database control utility
# ----


#
# Get defaults / call mainloop
#

source ./lib/surrogate.lib

#
# Usage, getops
#

function usage() { 
cat << EOF

	usage: $0 options

	This script expects some arguments, please oblige!

	OPTIONS:
	-h	Shows this message
	-b	Backup, either incremental or full, "-b incremental"
	-r 	Restore, accepts the full path of a restore list "-r /path/to/file"
	-c	Compress, compresses everything in 'last_backup'
	-p	Promote

EOF
}

type=
restore=
promote=

while getopts "hb:r:p:c:" option 
do
	case $option in

		h)
		usage
		exit 1
		;;
	
		b)
		type=$OPTARG
		if [[ "$type" == "full" ]]; then
			fullbackup
		elif [[ "$type" == "inc" ]]; then
			
			incbackup

		else

			echo "Please specify full or incremental"
			exit 1
		fi
		;;
	
		r)
		restore=$OPTARG
		restorebackup
		;;

		c)
		compress=$OPTARG
		echo $compress
		compressbackup
		;;
		
		p)
		promote=$OPTARG
		# then run the promote case
		;;

	esac
done

echo $type
echo $restore
echo $promote
