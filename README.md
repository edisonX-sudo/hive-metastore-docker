## Docker file for Hive Metastore 3 standalone(without hdfs service)

### About

Example of running standalone Hive Metastore.

It contains following containers:
- mariadb as dependency
- hive metastore  3.1.2

### Docker Image Usage
```
docker run --rm hhlai1990/hive-standalone-metastore:latest
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