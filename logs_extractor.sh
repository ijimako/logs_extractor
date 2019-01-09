#!/bin/bash

# This script helps you search for strings (case sensitive or not) in a flexible way
# You can make search act like an OR or an AND between the different strings you're searching
# ex: use -s "string1\|string2" to make the search act like an OR
# ex2: use  -s "string1" -s "string2" to make the search act like an AND

# You can also specify one or multiple hosts to search on using the option -h
# If you don't specify any host (-h option) the search will act locally
# ex: use -h prod1@prod1.com for one host
# ex2: use -h prod1@prod1.com -h prod2@prod2.com

usage() { echo "Usage: $0 -f <file_path> [-h <host>] -s <string> [-S <string_case_sensitive_ignore>]" 
	echo "Good to know: Multiple -h accepted. Multiple -s and -S accepted to make the search act like an AND operator." 1>&2; exit 1; }

s=''
servers=()

while getopts ":h:f:s:S:" o; do
    case "${o}" in
        h)
            h=${OPTARG}
            servers[${#servers[@]}]=${h}
            ;;
    	f)
    	    f=${OPTARG}
    	    ;;
        s)
            string=${OPTARG}
            s+=' | grep "'${string}'"'
            keywords+=' "'${string}'"'
            ;;
        S)
            S=${OPTARG}
            s+=' | grep -i "'${S}'"'
            keywords+=' "'${S}'"(S)'
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))


if [ ! -z "${h}" ] ; then
    if [ ! -z "${f}" ] ; then
    	echo 'Searching in logs for keywords :'${keywords}' on the following servers : '${servers[@]}
    	echo "Please wait..."
    	for server in "${servers[@]}"
    	do
    		echo "Searching on $server..."
    		echo 'Exec : ssh '$server' gzcat -f $(ls -tr '${f}'*)'${s}
    		echo "------------------------ Logs found on $server ------------------------"
            	eval ssh $server gzcat -f $(ls -tr ${f}*)${s}
    		echo "------------------------ End logs found on $server ------------------------"
    	done
    else
        usage
    fi
elif [ ! -z "${s}" ] || [ ! -z "${S}" ]; then
    if [ ! -z "${f}" ] ; then
	   echo "Searching in logs for keywords :${keywords} on local machine."
	   echo "Please wait..."
	   echo 'Exec : gzcat -f $(ls -tr '${f}'*)'${s}
	   echo "------------------------ Logs found ------------------------"
	   eval gzcat -f $(ls -tr ${f}*)${s}
	   echo "------------------------ End logs found ------------------------"
    else
	   usage
    fi
else
    usage
fi
