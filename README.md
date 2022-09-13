## Docker file for Hive Metastore 3 standalone(without hdfs service)

### About

Example of running standalone Hive Metastore.

It contains following containers:
- mariadb as dependency
- hive metastore  3.1.2

### Docker Image Usage
```
docker pull hhlai1990/hive-standalone-metastore:latest
```

docker-compose.yml
```
version: "2"

services:
  hive-metastore-database:
    image: mariadb:latest
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PASSWORD: admin
      MYSQL_USER: admin
      MYSQL_PASSWORD: admin
      MYSQL_DATABASE: metastore_db  
   
  hive-standalone-metastore:
    image: hhlai1990/hive-standalone-metastore:latest
    ports:
      - 9083:9083
    volumes:
      - /tmp/hive:/tmp/hive      
    depends_on:
      - hive-metastore-database   
    command: ["/wait-for-it.sh", "hive-metastore-database:3306", "--", "/entrypoint.sh"]
  

```

### Spark

For spark use:

```
val spark = SparkSession
      .builder()
      .appName("SparkHiveTest")
      .config("hive.metastore.uris", "thrift://localhost:9083")
      .config("spark.sql.warehouse.dir", "/tmp/hive/warehouse")
      .enableHiveSupport()
      .getOrCreate()
```

### Build and run

use docker compose to build && start hive

```
$ docker-compose build
$ docker-compose up -d
```

#### Some useful Docker commmands
clean unused images after docker building.
```
docker rmi -f $(docker images -f "dangling=true" -q)
```

enter shell to this container 
```
docker exec -it  hive-metastore-docker_hive-metastore_1 /bin/bash
```