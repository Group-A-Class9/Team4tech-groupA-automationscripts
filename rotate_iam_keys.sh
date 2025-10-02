usr/bin/env bash
# Rotate IAM access keys older than 90 days

USERNAME="$1"

if [ -z "$USERNAME" ]; then
  echo "Usage: $0 <iam-username>"
  exit 1
fi

NOW=$(date +%s)

# List access keys for the user
aws iam list-access-keys --user-name "$USERNAME" --output json | jq -c '.AccessKeyMetadata[]' | while read -r key; do
  ACCESS_KEY_ID=$(echo "$key" | jq -r '.AccessKeyId')
  CREATE_DATE=$(echo "$key" | jq -r '.CreateDate')
  CREATE_TS=$(date -d "$CREATE_DATE" +%s)

  AGE_DAYS=$(( (NOW - CREATE_TS) / 86400 ))

  if [ "$AGE_DAYS" -gt 90 ]; then
    echo "Key $ACCESS_KEY_ID is $AGE_DAYS days old. Rotating..."

    # Create new key
    NEW_KEY=$(aws iam create-access-key --user-name "$USERNAME" --output json)
    echo "New key created: $(echo "$NEW_KEY" | jq -r '.AccessKey.AccessKeyId')"

    # Deactivate old key
    aws iam update-access-key --user-name "$USERNAME" --access-key-id "$ACCESS_KEY_ID" --status Inactive

    # Delete old key
    aws iam delete-access-key --user-name "$USERNAME" --access-key-id "$ACCESS_KEY_ID"

    echo "Old key $ACCESS_KEY_ID deleted."
  fi
done
