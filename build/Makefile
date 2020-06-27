
all: \
	alpg.tar.gz \
	dact_attrib \
	dact_attrib_v6

alpg.tar.gz: \
		/home/peter/web/urd/www/alpinograph/* \
		/home/peter/web/urd/www/alpinograph/ag/* \
		/home/peter/web/urd/www/alpinograph/bin/* \
		/home/peter/web/urd/www/alpinograph/images/* \
		/home/peter/web/urd/www/alpinograph/tools/*
	rm -f alpg.tar.gz
	cd /home/peter/web/urd/www/alpinograph && \
	tar vczf /my/docker/AlpinoGraph/build/alpg.tar.gz \
		--exclude=.git --exclude=docs --exclude=tmp --exclude=spul \
		--exclude login --exclude login.home --exclude login.urd2 \
		--exclude=.dc --exclude .vscode --exclude=.gitignore \
		.

dact_attrib: /home/peter/web/urd/www/alpinograph/tools/dact_attrib.go
	perl -p -e 's!github.com/pebbe/dbxml!github.com/pebbe/dbxml2!' $< > $@.go
	GOPATH=/go/alpinograph go build -o $@ $@.go
	rm $@.go

dact_attrib_v6: /home/peter/web/urd/www/alpinograph/tools/dact_attrib.go
	cp $< $@.go
	GOPATH=/go/alpinograph go build -o $@ $@.go
	rm $@.go
