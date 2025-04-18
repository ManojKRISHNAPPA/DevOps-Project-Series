#!/usr/bin/env bash

EMAIL="manojdevopstest@gmail.com"
SUBJECT="Docker Service Alert"
RESTART_SUBJECT="Docker Service Restart Attempt"

# Get Docker status, version, and current time
dockerStatus=$(systemctl is-active docker)
dockerVersion=$(docker -v | awk '{print $3}' | tr -d ',')
cdate=$(date)

# Print the variables
echo "Current time is          : $cdate"
echo "Current Version of Docker: $dockerVersion"
echo "Docker Status            : $dockerStatus"

# If Docker is not active, send email
if [[ "$dockerStatus" != "active" ]]; then
    MESSAGE="ALERT!!!: Docker service is NOT running.\n\nVersion : $dockerVersion\nDate    : $cdate"
    echo -e "$MESSAGE" | mail -s "$SUBJECT" "$EMAIL"
    echo "Docker is not active — sent email alert."

    # Attempt to restart Docker
    systemctl restart docker
    sleep 3

    # Refresh the date and recheck Docker status
    restartTime=$(date)
    newStatus=$(systemctl is-active docker)
    RESTART_MESSAGE="Docker restart attempted at $restartTime.\nNew status: $newStatus"

    echo -e "$RESTART_MESSAGE" | mail -s "$RESTART_SUBJECT" "$EMAIL"
    echo "Restart attempt result emailed."
else
    echo "Docker is running normally."
fi

