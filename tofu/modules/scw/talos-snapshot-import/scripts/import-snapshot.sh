#!/usr/bin/env bash
set -euo pipefail

eval "$(jq -r '@sh "ZONE=\(.zone) NAME=\(.name) BUCKET=\(.bucket) KEY=\(.key) SIZE=\(.size)"')"

# Idempotency: check if a snapshot with this name already exists
EXISTING=$(scw block snapshot list zone="$ZONE" name="$NAME" -o json | jq -c '.[0] // empty')

if [ -n "$EXISTING" ]; then
  SNAPSHOT_ID=$(echo "$EXISTING" | jq -r '.id')
else
  # Kick off the import (no --wait supported here)
  IMPORT_RESULT=$(scw block snapshot import-from-object-storage \
    zone="$ZONE" \
    name="$NAME" \
    bucket="$BUCKET" \
    key="$KEY" \
    size="$SIZE" \
    -o json)

  SNAPSHOT_ID=$(echo "$IMPORT_RESULT" | jq -r '.id')
fi

# Poll until the snapshot is available
for i in $(seq 1 60); do
  STATUS=$(scw block snapshot get "$SNAPSHOT_ID" zone="$ZONE" -o json | jq -r '.status')

  if [ "$STATUS" = "available" ]; then
    break
  elif [ "$STATUS" = "error" ]; then
    echo "{\"error\": \"snapshot import failed, status=error\"}" >&2
    exit 1
  fi

  sleep 5
done

if [ "$STATUS" != "available" ]; then
  echo "{\"error\": \"timed out waiting for snapshot to become available, last status=$STATUS\"}" >&2
  exit 1
fi

jq -n --arg id "$SNAPSHOT_ID" --arg status "$STATUS" '{id: $id, status: $status}'
