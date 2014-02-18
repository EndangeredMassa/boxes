default: build

BINDIR = bin
SRCDIR = src
LIBDIR = lib
TESTDIR = test
DISTDIR = dist

SRC = $(shell find "$(SRCDIR)" -name "*.coffee" -type f | sort)
LIB = $(SRC:$(SRCDIR)/%.coffee=$(LIBDIR)/%.js)
TEST = $(shell find "$(TESTDIR)" -name "*.coffee" -type f | sort)

COFFEE=node_modules/.bin/coffee --js
MOCHA=node_modules/.bin/mocha --compilers coffee:coffee-script-redux/register -r coffee-script-redux/register -u tdd -R dot

build: $(LIB)

dev: build
	@node lib/index.js

$(LIBDIR)/%.js: $(SRCDIR)/%.coffee
	@mkdir -p "$(@D)"
	$(COFFEE) <"$<" >"$@"

.PHONY: phony-dep release test loc clean
phony-dep:

test: build
	$(MOCHA) $(TEST)
$(TESTDIR)/%.coffee: phony-dep
	$(MOCHA) "$@"

clean:
	@rm -rf "$(LIBDIR)" "$(DISTDIR)"
