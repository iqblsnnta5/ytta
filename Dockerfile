FROM ubuntu:20.04

# Update and install required packages
RUN apt-get update && \
    apt-get install -y docker-compose git && \
    apt-get upgrade -y && \
    apt-get install -y git

# Clone the repository
RUN git clone https://github.com/iqblsnnta5/panel /panel

# Set working directory
WORKDIR /panel

# Start Docker
RUN systemctl start docker

# Start the application
CMD ["docker-compose", "up", "-d"]
