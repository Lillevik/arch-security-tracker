PYTEST?=py.test
PYTEST_OPTIONS+=-v -s
PYTEST_INPUT?=test
PYTEST_COVERAGE_OPTIONS+=--cov-report=term-missing --cov-report=html:test/coverage --cov=app

.PHONY: update test

all: update

setup: submodule
	mkdir -p ./pacman/{cache,log}
	mkdir -p ./pacman/arch/{i686,x86_64}/db
	./db_create

submodule:
	git submodule update --recursive --init --rebase

update: setup
	./update

test coverage: setup
	PYTHONPATH=".:${PYTHONPATH}" ${PYTEST} ${PYTEST_INPUT} ${PYTEST_OPTIONS} ${PYTEST_COVERAGE_OPTIONS}

open-coverage: coverage
	${BROWSER} test/coverage/index.html

clean:
	rm -rf ./pacman/{cache,log}
	rm -rf ./pacman/arch/{i686,x86_64}/db
