all: clean test zip

clean:
	rm -f hello.zip

test:
	py.test --cache-clear

zip:
	zip hello.zip hello.py
