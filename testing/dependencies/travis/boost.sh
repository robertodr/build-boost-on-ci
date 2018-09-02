#!/usr/bin/env bash

set -eu -o pipefail

Boost_VERSION="1.59.0"
echo "-- Installing Boost $Boost_VERSION"
if [[ -f $HOME/Deps/boost/include/boost/version.hpp ]]; then
    echo "-- Boost $Boost_VERSION FOUND in cache"
else
    echo "-- Boost $Boost_VERSION NOT FOUND in cache"
    target_path=$HOME/Downloads/boost_"${Boost_VERSION//\./_}"
    boost_url="https://sourceforge.net/projects/boost/files/boost/1.59.0/boost_${Boost_VERSION//\./_}.tar.gz"
    mkdir -p "$target_path"
    curl -Ls "$boost_url" | tar -xz -C "$target_path" --strip-components=1
    # Set the toolset
    if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
       toolset="gcc"
    elif [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
        toolset="darwin"
    fi
    cd "$target_path"
    # Configure
    ./bootstrap.sh \
        --with-toolset="$toolset" \
        --with-libraries=filesystem,system,test,python \
        --with-python="$PYTHON3" \
        --prefix="$HOME/Deps/boost"
    # Build and install
    ./b2 -q install \
         link=shared \
         threading=multi \
         variant=release \
         toolset="$toolset" \
         --with-filesystem \
         --with-test \
         --with-system \
         --with-python
    cd "$TRAVIS_BUILD_DIR"
fi
echo "-- Done installing Boost $Boost_VERSION"
