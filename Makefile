.PHONY: cover

BIN_PATH:=node_modules/.bin/

all:	bitcore-wallet-client-ltz.min.js

clean:
	rm bitcore-wallet-client-ltz.js
	rm bitcore-wallet-client-ltz.min.js

bitcore-wallet-client-ltz.js: index.js lib/*.js
	${BIN_PATH}browserify $< > $@

bitcore-wallet-client-ltz.min.js: bitcore-wallet-client-ltz.js
	uglify  -s $<  -o $@

cover:
	./node_modules/.bin/istanbul cover ./node_modules/.bin/_mocha -- --reporter spec test
