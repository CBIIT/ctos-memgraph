ARG MEMGRAPH_TYPE="memgraph"
ARG MEMGRAPH_VERSION="3.13"
ARG UBUNTU_VERSION="26.04"

FROM ubuntu:${UBUNTU_VERSION}
ENV DEBIAN_FRONTEND=noninteractive

ARG MEMGRAPH_TYPE
ARG MEMGRAPH_VERSION
ARG UBUNTU_VERSION

# Update the package list and upgrade existing packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install apt-utils adduser wget -y

COPY get_url.sh .
RUN DL_URL=`bash ./get_url.sh ${MEMGRAPH_TYPE} ${MEMGRAPH_VERSION} ${UBUNTU_VERSION}`
RUN find . -iname "*.deb" -exec apt-get install {} -y \;

# Clean up packages installed for process
RUN apt-get remove apt-utils adduser wget python-pip python3-pip -y
RUN apt-get autoremove -y
RUN apt-get clean -y
# Clean up files
RUN rm /usr/bin/pebble -f

# Set up memgraph to start
ENTRYPOINT ["/usr/lib/memgraph/memgraph"]
