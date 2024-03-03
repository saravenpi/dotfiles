FROM rofrano/vagrant-provider:debian

# Set up environment variables for cross-compilation
ENV CROSS_COMPILE=x86_64-linux-gnu-

# Add architecture
RUN dpkg --add-architecture amd64

# Update the packages sources
RUN apt update

# Update the packages
RUN apt upgrade -y

# Install the required packages
RUN apt install -y gcc-x86-64-linux-gnu nasm gcc git nodejs npm stow

RUN yes | curl -fsSL https://raw.githubusercontent.com/saravenpi/dotfiles/main/install.sh | bash

# Create a working directory
WORKDIR /workspace
