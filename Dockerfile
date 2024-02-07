FROM ubuntu:20.04

# Update package lists
RUN apt-get update

# Install required packages
RUN apt-get install -y docker-compose git

# Clone the repository
RUN git clone https://github.com/iqblsnnta5/panel /panel

# Set working directory
WORKDIR /panel

# Run the application
CMD ["docker-compose", "up", "-d"]
