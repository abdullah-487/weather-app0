#!/bin/bash

API_KEY="83ce93ce46956a246592da0b8a92a48a"  # ⚠️ Use environment variables for better security
LOCATION="$1"

# ✅ Check if API key is present
if [ -z "$API_KEY" ]; then
  echo -e "\e[31m❌ API key is missing. Please set the API_KEY variable.\e[0m"
  exit 1
fi

# ✅ Check if city name provided
if [ -z "$LOCATION" ]; then
  echo -e "\e[31m❌ Please provide a location. Example: ./weather_info.sh lahore\e[0m"
  exit 1
fi

# ✅ Fetch weather data from OpenWeatherMap
response=$(curl -s "http://api.openweathermap.org/data/2.5/weather?q=$LOCATION&appid=$API_KEY&units=metric")

# ✅ Check if curl command succeeded
if [ $? -ne 0 ]; then
  echo -e "\e[31m❌ Error: Failed to retrieve weather information.\e[0m"
  exit 1
fi

# ✅ Check if API returned an error
code=$(echo "$response" | jq -r '.cod')
if [ "$code" != "200" ]; then
  message=$(echo "$response" | jq -r '.message')
  echo -e "\e[31m❌ API Error: $message\e[0m"
  exit 1
fi

# ✅ Extract values
weather=$(echo "$response" | jq -r '.weather[0].description')
temperature=$(echo "$response" | jq -r '.main.temp')
humidity=$(echo "$response" | jq -r '.main.humidity')
country=$(echo "$response" | jq -r '.sys.country')
date=$(date +"%A, %d %B %Y %I:%M %p")

# ✅ Display results
echo -e "\e[34m==============================="
echo -e "📅 $date"
echo -e "🌍 Weather for $LOCATION, $country"
echo -e "📋 Description: \e[33m$weather\e[34m"
echo -e "🌡️ Temperature: \e[36m$temperature °C\e[34m"
echo -e "💧 Humidity: \e[35m$humidity%\e[34m"
echo -e "===============================\e[0m"
exit 0s
