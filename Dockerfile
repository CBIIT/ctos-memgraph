ARG MEMGRAPH_TYPE="memgraph"
ARG MEMGRAPH_VERSION="3.13"
ARG UBUNTU_VERSION="26.04"
ARG OSTYPE="linux"
ARG MEMGRAPH_URLS_FILENAME="memgraph_urls.json"

FROM ubuntu:${UBUNTU_VERSION}
ENV DEBIAN_FRONTEND=noninteractive

ARG MEMGRAPH_TYPE
ARG MEMGRAPH_VERSION
ARG UBUNTU_VERSION
ARG OSTYPE
ARG MEMGRAPH_URLS_FILENAME

# Update the package list and upgrade existing packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install apt-utils -y
RUN apt-get install adduser wget libkrb5-dev python3 python3-wheel -y

# Install memgraph packages
COPY return_urls.py .
COPY ${MEMGRAPH_URLS_FILENAME} .
COPY get_url.sh .
RUN bash ./get_url.sh ${MEMGRAPH_TYPE} ${MEMGRAPH_VERSION} ${UBUNTU_VERSION} ${OSTYPE} ${MEMGRAPH_URLS_FILENAME}
#RUN echo "Packages to download: $DL_URL"
#RUN find . -iname "*.deb" -exec apt-get install {} -y \;

# Clean up packages installed for process
RUN apt-get remove apt-utils adduser wget python-pip python3-pip -y
RUN apt-get autoremove -y
RUN apt-get clean -y
# Clean up files
RUN rm /usr/bin/pebble -f

USER memgraph:memgraph

# Set up memgraph to start
ENTRYPOINT ["/usr/lib/memgraph/memgraph"]
