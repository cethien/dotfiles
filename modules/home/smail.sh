#!/usr/bin/env bash

# @option -s --subject Custom email subject
# @flag --spam-test Send a suspicious spam-like test mail
# @arg recipient! Target email address

eval "$(argc --argc-eval "$0" "$@")"

if [ -n "$argc_spam_test" ]; then
	subject="+ + + F R E E   B I T C O I N   N O W + + +"
elif [ -n "$argc_subject" ]; then
	subject="$argc_subject"
else
	subject="Untitled Email $(date '+%Y-%m-%d %H:%M') - forgot title or testing"
fi

body=$(cat)

if [ -z "$body" ] && [ -n "$argc_spam_test" ]; then
	body="Congratulations! You won. Click here: https://youtu.be/dQw4w9WgXcQ"
fi

msmtp \
	--set-from-header=auto \
	--set-date-header=auto \
	--set-msgid-header=auto \
	-a default \
	-t <<EOF
To: $argc_recipient
Subject: $subject

$body
EOF
