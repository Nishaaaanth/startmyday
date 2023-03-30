#!/bin/bash

# Add do while loop wherever invalid input is given
# Add a todo list functionality

# Initialising variables
name=$(whoami)
ip=$(curl -s https://ipinfo.io/ip)
city=$(curl -s http://ip-api.com/json/$ip | jq '.["city"]')
status=$(curl -s http://ip-api.com/json/$ip | jq '.["status"]')
dCity=$(grep -oP '(?<=dCity=).+' ~/.bashrc)

# greeting the user
greet() {
    echo "Hello $name"
    sleep 1
    echo -e "Let's have a look at the forecast for the day!\n\n"
}

# weather updates based on location
weather() {
    echo -n "Want some weather updates? (y/n): "
    read response
    echo -e "\n"

    sleep 1

    if [ $response == 'y' ] || [ $response == 'Y' ]; then

        echo "what do you want your weather update to be based on:"
        echo "    1. IP Location"
        echo "    2. Default Location"
        echo "    3. Manual location"
        
        echo -n "Enter your choice here: "
        read location
        echo -e "\n"

        case $location in
            1)
                if [ $status == '"success"' ]; then
                    weather=$(curl -s wttr.in/$city?format=3)
                    echo "Today's weather in $weather"
                else 
                    echo "Didn't find the weather info for the city you provided in sorry :(."
                fi
                ;;

            2)
                if [ -n dCity ]; then
                    declare -g city=$dCity

                    weather=$(curl -s wttr.in/$dCity?format=3)
                    echo "Today's weather in $weather"
                elif [ -z dCity ]; then
                    echo -n "Please provide your default city: "
                    read dCity

                    declare -g city=$dCity

                    echo "dCity=$dCity" >> ~/.bashrc
                    weather=$(curl -s wttr.in/$dCity?format=3)

                    if [ -n weather ]; then
                        echo "Today's weather in $weather"
                    else
                        echo "Didn't find the weather info for the city you provided in sorry :(."
                    fi
                fi

                echo -n "Do you want to change your defualt city? (y/n): "
                read change

                if [ "$change" == 'y' ] || [ "$change" == 'Y' ]; then
                    sed -i '/dCity/d' ~/.bashrc
                    echo -n "Please provide your default city: "
                    read dCity

                    declare -g city=$dCity

                    echo "dCity=$dCity" >> ~/.bashrc
                    weather=$(curl -s wttr.in/$dCity?format=3)

                    if [ -n weather ]; then
                        echo "Today's weather in $weather"
                    else
                        echo "Didn't find the weather info for the city you provided in sorry :(."
                    fi
                elif [ "$change" == 'n' ] || [ "$change" == 'N' ]; then
                    echo "Okay, wishing you a happy day ahead!"
                else
                    echo "Invalid choice"
                fi
                ;;

            3)
                echo -n "Please provide your city name: "
                read city

                declare -g city=$dCity

                weather=$(curl -s wttr.in/$city?format=3)
                echo "Today's weather in $weather"
                ;;
            *) 
                echo "Invalid choice"
                ;;
        esac

    else
        echo "Okay, wishing you a happy day ahead!"
        return 0
    fi

}

# todo list functionality
# todo should be added at night and should be displayed in the morning
# it should be saved in a file
todo() {
   echo "Let's have a look at todays tasks shall we?" 
   sleep 1

   time=$(curl http://worldtimeapi.org/api/timezone/city)
}

# main function
flow() {
    greet
    sleep 3
    weather
}

# calling the main function
flow
