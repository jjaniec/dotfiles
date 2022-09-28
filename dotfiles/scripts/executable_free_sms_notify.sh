#!/bin/bash

#d Send an sms notification to a free mobile number using smsapi
#u free_sms_notify.sh payload

set -o nounset
set -o verbose
set -o pipefail
# set -o verbose

ID="${FREE_SMS_API_ID}"
API_KEY="${FREE_SMS_API_KEY}"
MSG=${1:=test}

curl -v "https://smsapi.free-mobile.fr/sendmsg?user=${ID}&pass=${API_KEY}&msg=$(urlencode.sh ${MSG})"
