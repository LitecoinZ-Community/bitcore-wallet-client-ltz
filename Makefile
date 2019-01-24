.PHONY: cover

BIN_PATH:=node_modules/.bin/

all:	bitcore-wallet-client-ltz.js

clean:
	rm bitcore-wallet-client-ltz.js

bitcore-wallet-client-ltz.js: index.js lib/*.js
	${BIN_PATH}browserify $< > $@
