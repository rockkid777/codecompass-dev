#!/bin/bash

set -e

echo "command: $0 $@"

export LD_LIBRARY_PATH="/opt/cc/lib:/opt/cc/lib/parserplugin:/opt/cc/lib/serviceplugin/:/opt/cc/lib64:$LD_LIBRARY_PATH"
export CLASSPATH="/opt/cc/lib/java/*"

clean_dir() {
    dir=$1
    if [ -d $1 ]; then
        rm -rf $1
    fi
    mkdir -p $1
}

build() {
    newsum=$(ls -alR /src/cc | md5sum)
    if [ -f ~/sourcesum ]; then
        oldsum=$(cat ~/sourcesum)

        if [ $oldsum = $newsum ]; then
            echo "No changes, skipping build"
            return 0
        fi
    fi
    echo -n $newsum > ~/sourcesum

    clean_dir /tmp/cc-build
    rm -rf /opt/cc/*
    rm -rf /opt/cc/.done

    cd /tmp/cc-build

    cmake /src/cc -DDATABASE=pgsql -DCMAKE_INSTALL_PREFIX=/opt/cc/ -DCMAKE_BUILD_TYPE=Debug
    make -j 4 install
    cd /
    rm -rf /tmp/cc-build
    touch /opt/cc/.done
}

run() {
    until [ -f /opt/cc/.done ]; do
        echo 'Waiting for build... :)'
        sleep 1
    done

    while [ 1 -eq 1 ]; do
        sleep 1
    done

    echo "Start parsing..."

    clean_dir ~/cc/workdir
    /opt/cc/bin/CodeCompass_parser -w ~/cc/workdir \
        --name $name \
        --database "pgsql:host=$dbhost;port=$dbport;database=$name;user=$dbuser;password=$dbpass" \
        $PARSER_ARGS

    echo "Start server..."

    /opt/cc/bin/CodeCompass_webserver \
        -p 6251 \
        --dbhost $dbhost \
        --dbuser $dbuser \
        --dbpass $dbpass \
        $SERVER_ARGS
}

if [ $1 = "build" ]; then
    build
    exit 0
fi

name=$1
shift
dbhost=$(getent hosts $1 | awk '{print $1}')
shift
dbport=$1
shift
dbuser=$1
shift
dbpass=$1

run
