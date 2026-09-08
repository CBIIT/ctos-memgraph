FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and upgrade existing packages
RUN apt-get update && apt-get upgrade -y 
RUN apt-get install apt-utils adduser wget -y

# Get & install memgraph
RUN wget https://download.memgraph.com/memgraph/v3.12.0/ubuntu-24.04/memgraph_3.12.0-1_amd64.deb
RUN apt-get install ./memgraph_3.12.0-1_amd64.deb -y

# Clean up packages installed for process
RUN apt-get remove apt-utils adduser wget -y
RUN apt-get autoremove -y
RUN apt-get clean -y

# Set up memgraph to start
ENTRYPOINT ["/usr/lib/memgraph/memgraph"]
