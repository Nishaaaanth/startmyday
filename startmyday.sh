#!/bin/bash

# greet, weather
name=$(whoami)
ip=$(curl -s https://ipinfo.io/ip)
city=$(curl -s http://ip-api.com/json/$ip | jq '.["city"]')
status=$(curl -s http://ip-api.com/json/$ip | jq '.["status"]')
weather=$(curl -s wttr.in/$city?format=3)

greet() {
    echo "Hello $name"
    sleep 2
    echo "Hope you'll have a wonderful day ahead"
}

weather() {
    echo "Want to know weather based on your ip location? (y/n)"
    read location

    if [ $location == 'y' || $location == 'Y' ]; then
        if [ $status == '"success"' ]; then
            echo "Today's weather in $weather"
        else 
            echo "Didn't find the city you live in sorry :(. Would be interested in knowing about the weather today?(y/n)"
            
            if [ $response == 'y' || $response == 'Y' ]; then
                echo "Please mention your city"
                read city
            else
                echo "Okay I hope the weather is good :)"
            fi
        fi
    else
        read 
    fi
}

flow() {
    greet
    sleep 2
    
    weather
}

flow
