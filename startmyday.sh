#!/bin/bash

# Initialising variables
name=$(whoami)
ip=$(curl -s https://ipinfo.io/ip)
city=$(curl -s http://ip-api.com/json/$ip | jq '.["city"]')
status=$(curl -s http://ip-api.com/json/$ip | jq '.["status"]')
dCity=$(grep -oP '(?<=dCity=).+' ~/.bashrc)
time=$(curl -s http://worldtimeapi.org/api/timezone/$continent/$city)
width=$(tput cols)

# sleep can be edited from here
# global sleep
gSleep=3
# intermediate sleep
intSleep=1

# functions
# line break
break() {
    for (( i=0 ; i<$width ; i++ )); do
        echo -n "-"
    done
}

# globalizing the default city to city
globalCity() {
    declare -g city=$dCity
}

# wishing message
wish() {
    echo "Wishing you a happy day!"
}

# weather based on city
ipCity() {
    if [ $status == '"success"' ]; then
        weather=$(curl -s wttr.in/$city?format=3)
        echo "Today's weather in $weather"
    else 
        echo "Didn't find the weather info for the city you provided in sorry :(."

        sleep $gSleep
        weather
    fi
}


defaultCity() {
    if [ -n dCity ]; then
        globalCity
        weather=$(curl -s wttr.in/$dCity?format=3)
        echo "Today's weather in $weather"

    elif [ -z dCity ]; then
        echo -n "Please provide your default city: "
        read dCity
        globalCity

        echo "dCity=$dCity" >> ~/.bashrc
        weather=$(curl -s wttr.in/$dCity?format=3)

        if [ -n weather ]; then
            echo "Today's weather in $weather"
        else
            echo "Didn't find the weather info for the city you provided in sorry :(."

            sleep $gSleep
            weather
        fi
    fi

    echo -n "Do you want to change your default city? (y/n): "
    read change

    if [ "$change" == 'y' ] || [ "$change" == 'Y' ]; then
        echo -n "Please provide your default city: "
        read dCity
        globalCity
        weather=$(curl -s wttr.in/$dCity?format=3)

        if [ -n weather ]; then
            sed -i '/dCity/d' ~/.bashrc
            echo "dCity=$dCity" >> ~/.bashrc
            echo "Today's weather in $weather"
        else
            echo "Didn't find the weather info for the city you provided in sorry :(."
            weather
        fi

    elif [ "$change" == 'n' ] || [ "$change" == 'N' ]; then
        echo "Okay, bye"
    else
        echo "Invalid choice"
        weather
    fi
}

manualCity() {
    echo -n "Please provide your city name: "
    read city
    globalCity
    weather=$(curl -s wttr.in/$city?format=3)

    if [ -n weather ]; then
        echo "Today's weather in $weather"
    else
        echo "Didn't find the weather info for the city you provided in sorry :(."
        weather
    fi
}

# greeting the user
greet() {
    echo "Hello $name"
    sleep $intSleep

    echo -e "Let's have a look at the forecast for the day!\n"
    sleep $intSleep

    echo "What do you want to do today?"
    echo "1. Let me get some weather reports today."
    echo "2. Let know todos for today."
    echo "3. Both"
    read option
}

# weather updates based on location
weather() {
        echo "What do you want your weather update to be based on:"
        echo "    1. IP Location"
        echo "    2. Default Location"
        echo "    3. Manual location"
        
        echo -n "Enter your choice here: "
        read location
        echo -e "\n"

        sleep $intSleep

        case $location in
            1)
                ipCity
                ;;

            2)
                defaultCity
                ;;

            3)
                manualCity
                ;;
            *) 
                echo "Invalid choice"
                weather
                ;;
        esac
}

# todo list functionality
# todo should be added at night and should be displayed in the morning
# it should be saved in a file
todo() {
   echo "Let's have a look at todays tasks shall we?" 
   sleep 1


   echo "Wishing you with luck to finish of the task!"
}

# main function
flow() {
    greet
    
    if [ $option == '1' ]; then
        break
        sleep $gSleep
        weather

        sleep $gSleep
        wish

    elif [ $option == '2' ]; then
        break
        sleep $gSleep
        todo

        sleep $gSleep
        wish
        
    elif [ $option == '3' ]; then
        break
        sleep $gSleep
        weather

        break
        sleep $gSleep
        todo

        sleep $gSleep
        wish
        
    else 
        echo "nothing that I can do about it"
        sleep $gSleep
        wish
    fi
}

flow
