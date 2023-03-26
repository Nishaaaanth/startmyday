#!/bin/bash

name=$(whoami)

greet() {
    echo "Hello $name"

    sleep 1

    echo "Hope you'll have a wonderful day ahead"
}

greet
