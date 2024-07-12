alias pingu="docker run -e DISPLAY=host.docker.internal:0 --volume /tmp/.X11-unix:/tmp/.X11-unix --network=\"host\" --rm -it --name pingu-container --volume .:/workspace pingu:latest bash"
