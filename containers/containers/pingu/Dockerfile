FROM debian:latest

# Set up environment variables for cross-compilation
ENV CROSS_COMPILE=x86_64-linux-gnu-

# Add architecture
RUN dpkg --add-architecture amd64

# Update the packages sources
RUN apt update

# Update the packages
RUN apt upgrade -y

# Install the required packages
RUN apt install -y gcc-x86-64-linux-gnu nasm gcc git nodejs npm valgrind gdb libcsfml-dev make tmux xorg

# Custom prompt
RUN echo 'export PS1="🐧 \[\e[1;36m\]\w\[\e[1;33m\]>\[\e[0m\]\n"' >> /root/.bashrc

# Custom aliases
RUN echo 'alias ll="ls -l"' >> /root/.bashrc
RUN echo 'alias la="ls -la"' >> /root/.bashrc
RUN echo 'alias m="make"' >> /root/.bashrc
RUN echo 'alias mr="make re"' >> /root/.bashrc
RUN echo 'alias mt="make test"' >> /root/.bashrc
RUN echo 'alias mc="make clean"' >> /root/.bashrc
RUN echo 'alias mfc="make fclean"' >> /root/.bashrc
RUN echo 'alias c="clear"' >> /root/.bashrc
RUN echo 'alias q="exit"' >> /root/.bashrc
RUN echo 'alias :q="exit"' >> /root/.bashrc
RUN echo 'clear' >> /root/.bashrc

# Create a working directory
WORKDIR /workspace

CMD ["/bin/bash"]
