NAME = webserver

all: init
	go build -o $(NAME) main.go

init:
	./init.sh

dev:
	go run main.go

build:
	go build main.go -o $(NAME)

clean:
	rm $(NAME)
