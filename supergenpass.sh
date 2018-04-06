#!/bin/bash

################################################################################

secret_password=""              ### Leave empty for none.
hashing_algorithm="md5"         ### Default is "md5". Alternate value is "sha512".
default_password_length="10"    ### Default is 10. It can be overwritten on an individual basis by adding the custom length as a second argument after the domain when invoking the command.

################################################################################

domain=$(echo $1 | tr A-Z a-z)
length=${2:-$default_password_length}

read -srp 'Password: ' master_password

full_password="$master_password$secret_password"
hash=$full_password:$domain

i=0
while true
do
	hash=$(echo -n "$hash" | openssl "$hashing_algorithm" -binary | base64 | tr +/= 98A)
	i=$(($i + 1))
	if [ $i -lt 10 ]
	then
		continue
	fi
	valid=$(echo "${hash:0:$length}" | egrep '^[a-z]' | egrep '.[A-Z]' | egrep '.[0-9]' )
	if [ "$valid" != "" ]
	then
		break
	fi
done
echo ${hash:0:$length}
