#!/bin/bash
CC=gcc        # clang should work too
BUILD=build

mkdir -p $BUILD

# Relay 1
$CC -o $BUILD/relay1 relay1.c
$BUILD/relay1 > $BUILD/relay1.sh
bash $BUILD/relay1.sh > $BUILD/relay1.out

if ! diff -u relay1.c $BUILD/relay1.out; then
    echo
    echo "relay1 failed"
    exit 1
fi

# Relay 2
bash relay2.sh > $BUILD/relay2.c
$CC -o $BUILD/relay2 $BUILD/relay2.c
$BUILD/relay2 > $BUILD/relay2.out

if ! diff -u relay2.sh $BUILD/relay2.out; then
    echo
    echo "relay2 failed"
    exit 1
fi

# Polyquine
$CC -o $BUILD/polyquine -x c polyquine
$BUILD/polyquine > $BUILD/polyquine-c.out
bash polyquine > $BUILD/polyquine-bash.out

if ! (diff -u polyquine $BUILD/polyquine-c.out &&
      diff -u polyquine $BUILD/polyquine-bash.out)
then
    echo
    echo "polyquine failed"
    exit 1
fi

echo
echo "All quines passed."
