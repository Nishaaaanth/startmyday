#!/bin/bash

# initializing variables
name=$(whoami)
ip=$(curl -s https://ipinfo.io/ip)
city=$(curl -s http://ip-api.com/json/$ip | jq '.["city"]')
status=$(curl -s http://ip-api.com/json/$ip | jq '.["status"]')
weather=$(curl -s wttr.in/$city?format=3)

# greetings
greet() {
    echo "Hello $name"
    sleep 2
    echo "Hope you'll have a wonderful day ahead"
}

# weather
weather() {
    echo "How do you want your weather update. Based on your:"
    echo "1. IP Location"
    echo "2. Default Location"
    echo "3. Manual location"
    read location

    case $location in
        1)
            if [ $status == '"success"' ]; then
                echo "Today's weather in $weather"
                ;;
            else 
                echo "Didn't find the city you live in sorry :(."
                ;;
            fi

        2)
            echo "Please provide your default city"
            read dCity

            # insert the city inside bashrc. If the city is already present then don't prompt for city. If the user wants to change the default location then that question should be asked in the echo above

            weather=$(curl -s wttr.in/$city?format=3)
            echo "Today's weather in $weather"
            ;;

        3)
            echo "Please provide your default city"
            read city

            weather=$(curl -s wttr.in/$city?format=3)
            echo "Today's weather in $weather"
            ;;
}

flow() {
    greet
    sleep 2
    
    echo "Want some weather updates? (y/n)"
    read response

    if [ $response == 'y' || $response == 'Y' ]; then
        weather
    fi
}

flow
