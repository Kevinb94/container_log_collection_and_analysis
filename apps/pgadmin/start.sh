#!/bin/bash

# Format: pgadmin-YYYY-MM-DD.log
LOGFILE="/var/lib/pgadmin/logs/pgadmin.log"

# Run original entrypoint and append output
exec /entrypoint.sh "$@" >> "$LOGFILE" 2>&1
