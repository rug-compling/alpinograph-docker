
all: \
	dact_attrib \
	dact_attrib_v6

dact_attrib: /home/peter/web/urd/www/alpinograph/tools/dact_attrib.go
	perl -p -e 's!github.com/pebbe/dbxml!github.com/pebbe/dbxml2!' $< > $@.go
	GOPATH=/go/alpinograph go build -o $@ $@.go
	rm $@.go

dact_attrib_v6: /home/peter/web/urd/www/alpinograph/tools/dact_attrib.go
	cp $< $@.go
	GOPATH=/go/alpinograph go build -o $@ $@.go
	rm $@.go
