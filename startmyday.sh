#!/bin/bash

# Initialising variables
name=$(whoami)
ip=$(curl -s https://ipinfo.io/ip)
city=$(curl -s http://ip-api.com/json/$ip | jq '.["city"]')
status=$(curl -s http://ip-api.com/json/$ip | jq '.["status"]')
dCity=$(grep -oP '(?<=dCity=).+' ~/.bashrc)
time=$(curl -s http://worldtimeapi.org/api/timezone/$continent/$city)
width=$(tput cols)

# line break
break() {
    for (( i=0 ; i<$width ; i++ )); do
        echo -n "-"
    done
}

dDeclare() {
    declare -g city=$dCity
}

# greeting the user
greet() {
    echo "Hello $name"
    sleep 1

    echo -e "Let's have a look at the forecast for the day!\n"

    echo -e "What do you want to do today?\n"
    echo -e "1. Let me get some weather reports today."
    echo -e "2. Let know todos for today."
    echo -e "3. Both"
    read option
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
                    dDeclare

                    weather=$(curl -s wttr.in/$dCity?format=3)
                    echo "Today's weather in $weather"
                elif [ -z dCity ]; then
                    echo -n "Please provide your default city: "
                    read dCity

                    dDeclare

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

                    dDeclare

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

    elif [ $response == 'n' ] || [ $response == 'N' ]; then
        echo "Okay, wishing you a happy day ahead!"
    fi



}

# todo list functionality
# todo should be added at night and should be displayed in the morning
# it should be saved in a file
todo() {
   echo "Let's have a look at todays tasks shall we?" 
   sleep 1
}

# main function
flow() {
    greet
    break

    sleep 3

    weather
    break
}

# calling the main function
flow
