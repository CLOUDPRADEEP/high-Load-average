#!/bin/bash

echo "Checking Load Average for Remote Servers..."

# File containing the list of servers
IP_FILE="/home/sahoo/Desktop/test/IP.txt"

# Check if the file exists
if [ ! -f "$IP_FILE" ]; then
    echo "Error: File $IP_FILE not found."
    exit 1
fi

# Read the list of servers from the file
SERVERS=$(cat "$IP_FILE")

# Output temporary file
OUTPUT_FILE="/tmp/load_average_report_$(date +%Y%m%d%H%M).txt"

# Email details
EMAIL_TO="pradeep.sahoo@cloudpradeep.com"
EMAIL_SUBJECT="Load Average Report $(date +\%d-\%b-\%Y)"
EMAIL_BODY="Please find the attached load average report."

# Function to generate load average report for a server and ssh timeout will be 10 sec.
generate_load_report() {
    local host=$1
    echo "-------------------------------------" >> "$OUTPUT_FILE"
    echo "* HOST: $host " >> "$OUTPUT_FILE"
    echo "-------------------------------------" >> "$OUTPUT_FILE"
    ssh -o ConnectTimeout=10 "$host" uptime >> "$OUTPUT_FILE"
}

# Generate load average report for each server
for server in $SERVERS; do
    generate_load_report "$server"
done

echo "Sending mail..."

# Send an email after the script has completed
echo "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" "$EMAIL_TO" -A "$OUTPUT_FILE" -a "From:noreply@services.cloudpradeep.com"


echo "Mail sent successfully."

# Remove the temporary file
rm "$OUTPUT_FILE"

sleep 1

echo "Temporary file removed."

echo "Load average check completed."
