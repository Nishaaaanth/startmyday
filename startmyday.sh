#!/bin/bash

name=$(whoami)

greet() {
    echo "Hello $name"
}

greet
