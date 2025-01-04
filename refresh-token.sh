#!/bin/bash

# Client ID for the vscode copilot
client_id="01ab8ac9400c4e429b23" 

# Get the response from the first curl command (silently)
response=$(curl -s https://github.com/login/device/code -X POST -d "client_id=$client_id&scope=user:email")

# Extract the device_code
device_code=$(echo "$response" | grep -oE 'device_code=[^&]+' | cut -d '=' -f 2)

# Extract the user_code
user_code=$(echo "$response" | grep -oE 'user_code=[^&]+' | cut -d '=' -f 2)

# Print instructions for the user
echo "Please open https://github.com/login/device/ and enter the following code: $user_code"
echo "Press Enter once you have authorized the application..."
read

# Get the access token (silently)
response_access_token=$(curl -s https://github.com/login/oauth/access_token -X POST -d "client_id=$client_id&scope=user:email&device_code=$device_code&grant_type=urn:ietf:params:oauth:grant-type:device_code")

access_token=$(echo "$response_access_token" | grep -oE 'access_token=[^&]+' | cut -d '=' -f 2)

# Print the access token
echo "Your access token is: $access_token"
echo "Run the app with the following command:"
echo "REFRESH_TOKE=$access_token" > .env
echo "REFRESH_TOKEN=$access_token poetry run uvicorn copilot_more.server:app --port 15432"