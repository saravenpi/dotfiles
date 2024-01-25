CC = gcc
CFLAGS = -Wall

SRCS = main.c
NAME = my_program

OBJS = $(SRCS:.c=.o)

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f $(OBJS) $(NAME)

fclean: clean

re: clean all

.PHONY: all clean re
