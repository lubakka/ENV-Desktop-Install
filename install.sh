#!/bin/sh

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

# Проврява потребителя дали е "root", ако не е го принуждава да стане
if [ "$(id -u)" != "0" ]; then
	echo "Execute whit 'sudo' $0"
	exit 1
fi

DIR=$( pwd )

ARGS=`getopt -o acjmdpkhwt --long auto,composer,jdk,mongodb,dotNet,packages,komodo,help,web \
     -n '$0' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$ARGS"

if [ -r includes/functions.sh ]; then
	. ./includes/functions.sh
else
	echo "Cannot open include file 'includes/functions.sh'">&2
	exit 1
fi

while true ; do
    case "$1" in
        -a|--auto)
            autoInstallAll
            ;;
        -c|--composer)
            installComposer
            ;;
        -e|--extra)
            installExtra
            ;;
        -j|--jdk)
            installJDK
            ;;
        -m|--mongodb)
            installMongodb
            ;;
        -d|--dotNet)
            installMonodevelop
            ;;
        -p|--packages)
            installPKG
            ;;
        -k|--komodo)
            installKomodo
            ;;
        -w|--web)
            installFrameworkPHP
            ;;
        -h|--help)
            show_help
            ;;
        -t)
            installPhuml
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
        --) shift ; break ;;
        *)
            show_help
	esac
shift
done