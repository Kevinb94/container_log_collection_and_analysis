- backups
- log cleanup 
find /var/log/postgresql -name "postgresql-*.log" -type f -mtime +7 -delete
- init db
    - postgres init db function … 
        - create custom roles or databases before app runs
        - creating multiple databases
    - prisma/sequilize
        - sql frameworks scripts
        