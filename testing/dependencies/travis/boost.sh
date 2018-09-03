#!/usr/bin/env bash

set -eu -o pipefail

Boost_VERSION="1.60.0"
echo "-- Installing Boost $Boost_VERSION"
if [[ -f $HOME/Deps/boost/include/boost/version.hpp ]]; then
    echo "-- Boost $Boost_VERSION FOUND in cache"
else
    echo "-- Boost $Boost_VERSION NOT FOUND in cache"
    target_path=$HOME/Downloads/boost_"${Boost_VERSION//\./_}"
    boost_url="https://sourceforge.net/projects/boost/files/boost/$Boost_VERSION/boost_${Boost_VERSION//\./_}.tar.gz"
    mkdir -p "$target_path"
    curl -Ls "$boost_url" | tar -xz -C "$target_path" --strip-components=1
    cd "$target_path"
    # Configure, build, and install
    if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
       # Configure
       ./bootstrap.sh \
           --with-toolset=gcc \
           --with-libraries=filesystem,system,test,python \
           --with-python="$PYTHON3" \
           --prefix="$HOME/Deps/boost" &> /dev/null
       # Build and install
       ./b2 -q install \
            link=shared \
            threading=multi \
            variant=release \
            toolset=gcc-7 \
            --with-filesystem \
            --with-test \
            --with-system \
            --with-python &> /dev/null
    elif [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
        # With help from: https://thb.lt/blog/notes/2014/boost-python-3-osx.html
        # Configure
        ./bootstrap.sh \
            --with-toolset=gcc \
            --with-libraries=filesystem,system,test,python \
            --with-python-version=3.7 \
            --with-python-root=$(python3-config --prefix) \
            --with-python=$(python3-config --prefix)/bin/python3.7 \
            --prefix="$HOME/Deps/boost" &> /dev/null
        # Build and install
        ./b2 -q install \
             include="$(python3-config --prefix)/include/python3.7m" \
             link=shared \
             threading=multi \
             variant=release \
             toolset=gcc \
             --with-filesystem \
             --with-test \
             --with-system \
             --with-python
    fi
    cd "$TRAVIS_BUILD_DIR"
fi
echo "-- Done installing Boost $Boost_VERSION"
