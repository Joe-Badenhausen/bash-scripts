#!/bin/bash
# READ ME 
# Run as root
# Make script executable
# USE A WRITEBLOCKER



###############################################################################
#                           NON-LIABILITY STATEMENT                           #
###############################################################################
#                                                                             #
# The script provided here is for demonstration purposes only. The author     #
# does not guarantee its accuracy, reliability, or suitability for any        #
# particular purpose.                                                         #
#                                                                             #
# The author shall not be held liable for any direct, indirect, incidental,   #
# special, exemplary, or consequential damages arising out of the use or      #
# misuse of this script.                                                      #
#                                                                             #
# Users are solely responsible for any risks associated with the use of       #
# this script.                                                                #
#                                                                             #
# It is recommended to review and test the script thoroughly before use.      #
#                                                                             #
###############################################################################







# List drives on system
lsblk
# Prompt user for drive or partition to clone
read -p "Enter the drive or partition to clone (e.g., /dev/sdb1): " source_drive

# Prompt user for the name of the output raw file
read -p "Enter the name of the output raw file: " output_file

# Generate the SHA512 hash of the source drive
hash_before=$(sha512sum "$source_drive" | awk '{print $1}')

# Clone the source drive to the output file using dd
dd if="$source_drive" of="$output_file" bs=4M status=progress

# Generate the SHA512 hash of the cloned drive
hash_after=$(sha512sum "$output_file" | awk '{print $1}')

# Check if the drive matches the image match
if [ "$hash_before" != "$hash_after" ]; then
    echo "ERROR - $output_file does not match $source_drive!!!"
else
    echo "$source_drive matches $output_file"
fi

# Generate sha512 hash of the source drive
hash_after_clone=$(sha512sum "$source_drive" | awk '{print $1}')

# Check if the drives hash changed
if [ "$hash_before" != "$hash_after_clone" ]; then
	echo "FATAL ERROR - DRIVE INTEGRITY INVALID"
else
	echo "Drive integrity valid."
fi

# Output the hashes
echo "Hash of $source_drive before cloning:	$hash_before"
echo "Hash of $source_drive after cloning: 	$hash_after_clone"
echo "Hash of $output_file:  			$hash_after"

