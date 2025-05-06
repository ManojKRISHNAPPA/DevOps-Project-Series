#!/bin/bash

# Check for input arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <username> <email>"
    exit 1
fi

USERNAME="$1"
EMAIL="$2"

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists."
    exit 2
fi

# Generate random password
PASSWORD=$(openssl rand -base64 12)

# Create the user and set the password
sudo useradd -m "$USERNAME"
echo "$USERNAME:$PASSWORD" | sudo chpasswd

# Force password change on first login
sudo chage -d 0 "$USERNAME"

# Email the credentials
echo -e "Hello $USERNAME,\n\nYour new account has been created.\nUsername: $USERNAME\nPassword: $PASSWORD\n\nPlease change your password upon first login." | mail -s "Your new user account" "$EMAIL"

echo "User '$USERNAME' created and credentials sent to $EMAIL"

## usgae
## ./user-add.sh manoj manojdevopstest@gmail.com
