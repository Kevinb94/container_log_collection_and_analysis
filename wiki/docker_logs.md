Run this command to view logs for your PostgreSQL container:
docker logs postgres-db
docker logs --tail 50 postgres-db

On the other hand, if you want to follow the logs in real-time, this is the command you want to run:
docker logs -f postgres-db