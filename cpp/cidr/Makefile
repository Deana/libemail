.PHONY=all clean test
CPPFLAGS=-O2 

all:	t t.pthread

test:	t
	./t < ip.list

clean:
	rm -f *.o t t.pthread match

t:	main.o cidr.o ip.o 
	g++ main.o cidr.o ip.o -o t

ip.o:	ip.cpp
	g++ $(CPPFLAGS) -c ip.cpp

main.o:	main.cpp
	g++ $(CPPFLAGS) -c main.cpp

cidr.o:	cidr.cpp
	g++ $(CPPFLAGS) -c cidr.cpp

utility.o:	utility.cpp
	g++ $(CPPFLAGS) -c utility.cpp

main_pthread.o:	main_pthread.c
	gcc $(CFLAGS) -c main_pthread.c

t.pthread:	main_pthread.o utility.o ip.o cidr.o
	gcc main_pthread.o utility.o ip.o cidr.o -lpthread -lstdc++ -o t.pthread
