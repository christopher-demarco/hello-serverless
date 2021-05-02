all: clean test zip

clean:
	rm -f hello.zip

test:
	pytest --pep8 --clearcache

zip:
	zip hello.zip hello.py
