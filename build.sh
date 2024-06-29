#!/bin/bash

touch .buildlist

reg=$1
target=$2

while IDS= read -r item; do
    if [[ -n "$item" ]] && [[ ! "${item:0:1}" == "#" ]]; then
        pushd $item > /dev/null
        if [[ -f .env ]] && [[ -n "$reg" ]] && [[ -n "$target" ]] then
            sed -i.bak 's,%REGISTRY%,'${reg}',; s,%TARGET%,'${target}',' .env
            task all
            retval=$?
            mv -f .env.bak .env
            if [[ $retval -ne 0 ]]; then
                exit $retval
            fi
        else
            echo "WARNING: Regisrty variables are not defined!"
        fi
        popd > /dev/null
    fi
done <.buildlist
