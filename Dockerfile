ARG ROS_DISTRO
FROM ros:${ROS_DISTRO}

SHELL ["/bin/bash", "-c"]
WORKDIR /root/ws

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654

RUN apt-get update && apt-get install -y \
  ros-${ROS_DISTRO}-rviz \
  ros-${ROS_DISTRO}-gazebo-ros \
  ros-${ROS_DISTRO}-gazebo-ros-control && \
  if test $ROS_DISTRO = 'noetic'; then \
      apt-get install python3-catkin-tools python3-rospkg -y; \
  else \
      apt-get install python-catkin-tools python-rospkg; \
  fi && \
  rm -rf /var/lib/apt/lists/*

ARG CATKIN_WS=/root/ws/src/
RUN mkdir -p ${CATKIN_WS}

# Create WS
RUN source /opt/ros/${ROS_DISTRO}/setup.bash &&\
    mkdir -p src/rosplan &&\
    catkin build --no-status

COPY ./object_spawner/ ${CATKIN_WS}/object_spawner/

COPY ./entrypoint.bash /entrypoint.bash
RUN chmod +x /entrypoint.bash
ENTRYPOINT [ "/entrypoint.bash" ]

RUN /entrypoint.bash catkin build