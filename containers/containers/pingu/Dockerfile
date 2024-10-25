FROM debian:latest

# Set up environment variables for cross-compilation
ENV CROSS_COMPILE=x86_64-linux-gnu-

# Add architecture
RUN dpkg --add-architecture amd64

# Update the package sources and upgrade packages
RUN apt update && apt upgrade -y

# Install required packages in separate lines for readability
RUN apt install -y \
    gcc-x86-64-linux-gnu \
    g++ \
    cmake \
    nasm \
    gcc \
    git \
    nodejs \
    npm \
    valgrind \
    gdb \
    libcsfml-dev \
    make \
    tmux \
    xorg

# Custom prompt
RUN echo 'export PS1="🐧 \[\e[1;36m\]\w\[\e[1;33m\]>\[\e[0m\]\n"' >> /root/.bashrc

# Custom aliases
RUN echo 'alias ll="ls -l"' >> /root/.bashrc && \
    echo 'alias la="ls -la"' >> /root/.bashrc && \
    echo 'alias m="make"' >> /root/.bashrc && \
    echo 'alias mr="make re"' >> /root/.bashrc && \
    echo 'alias mt="make test"' >> /root/.bashrc && \
    echo 'alias mc="make clean"' >> /root/.bashrc && \
    echo 'alias mfc="make fclean"' >> /root/.bashrc && \
    echo 'alias c="clear"' >> /root/.bashrc && \
    echo 'alias q="exit"' >> /root/.bashrc && \
    echo 'alias :q="exit"' >> /root/.bashrc && \
    echo 'clear' >> /root/.bashrc

# Create a working directory
WORKDIR /workspace

CMD ["/bin/bash"]
