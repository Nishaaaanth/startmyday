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
    sleep 1
    echo -e "Let's have a look at the forecast for the day!\n"
}

# weather
weather() {
    echo -n "Want some weather updates? (y/n): "
    read response

    if [ $response == 'y' ] || [ $response == 'Y' ]; then

        echo "what do you want your weather update to be based on:"
        echo "    1. IP Location"
        echo "    2. Default Location"
        echo "    3. Manual location"
        
        echo -n "Enter your choice here: "
        read location

        case $location in
            1)
                if [ $status == '"success"' ]; then
                    echo "Today's weather in $weather"
                else 
                    echo "Didn't find the city you live in sorry :(."
                fi
                ;;

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
        esac

    else
        echo "Okay, wishing you with a happy day ahead"
        return 0
    fi

}



flow() {
    greet
    sleep 2
    weather
}

flow
