#!/usr/bin/env bash

function usage {
    echo "Usage: run.sh [command]"
    echo
    echo "Commands:"
    echo
    echo "    bash:"
    echo "        starts a bash shell"
    echo
    echo "    jupyter:"
    echo "        starts jupyter notebook"
    echo "        args:"
    echo "            /path/to/notebooks"
    echo "            port_number (default 8888)"
    echo
    echo "    clean:"
    echo "         removes pcmdi docker images"
    echo "         args":
    echo "             -f: forces removal of both running and exited containers"
}

case "$1" in
    bash)
        docker run -it --init pcmdi bash
        ;;
    jupyter)
        if [ -z "$2" ] ; then
            echo "Missing the path to notebooks"
            exit 1
        fi
        WORKSPACE=$(readlink -f "$2")
        echo "Notebooks will be saved in ${WORKSPACE}"
        echo "Open http://localhost:${3:-8888} to access Jupyter"
        docker run -it -v ${WORKSPACE}:/opt/notebooks -p ${3:-8888}:8888 pcmdi bash -c ". activate pcmdi && jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root --NotebookApp.token=''"
        ;;
    clean)
        if [ "$2" == "-f" ] ; then
            FORCE="-f"
        else
            FILTER="--filter status=exited"
        fi
        for c in $(docker ps -a ${FILTER} | awk '{ print $1,$2 }' | grep pcmdi | awk '{ print $1 }')
        do
            docker container rm ${FORCE} $c
        done
        ;;
    *)
        usage
        exit 1
esac
