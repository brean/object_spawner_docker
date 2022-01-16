#!/bin/bash
xhost +local:root
docker-compose run object_spawner
xhost -local:root