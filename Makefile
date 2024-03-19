
ifeq ($(findstring rootless, $(shell docker info --format '{{.SecurityOptions}}')), )
DOCKERARGS = --net=host
else
DOCKERARGS = --volume=/tmp/.X11-unix/:/tmp/.X11-unix/
endif

# parallel execution werkt niet met -i voor docker
# zonder -i voor docker zijn processen in docker niet te onderbreken
.NOTPARALLEL:

.PHONY: help
help:
	@echo Beschikbare targets voor make:
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[34m%-8s\033[0m %s\n", $$1, $$2}'

shell:
	docker run $(DOCKERARGS) --rm -i -t \
		-e DISPLAY \
		-v $(PWD)/alpinograph-in-docker/build/opt:/opt \
		-v $(PWD)/src:/src \
		-v $(PWD)/tmp:/tmp \
		-v $(PWD)/work:/work \
		localhost/alpinograph-devel:latest

distclean:
	if [ -d work/cache/go ]; then chmod -cR u+w work/cache/go; fi
	rm -fr \
		alpinograph-in-docker/build/alpinograph \
		alpinograph-in-docker/build/opt/agensgraph \
		alpinograph-in-docker/build/opt/bin \
		alpinograph-in-docker/build/opt/dbxml? \
		work

step0:	## deze repo bijwerken
	git pull

step1:	## maak/update het image dat in de volgende stappen gebruikt wordt
	build/build.sh

step2:	step1 ## installeer DbXML
	if [ ! -f src/dbxml-6.1.4.tar.gz ]; \
		then cp /net/corpora/docker/alpino/src/dbxml-6.1.4.tar.gz src; fi
	docker run $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/alpinograph-in-docker/build/opt:/opt \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/src:/src \
		-v $(PWD)/work/dbxml:/dbxml \
		localhost/alpinograph-devel:latest \
		/scripts/install-dbxml.sh

step3:	step1 ## installeer AgensGraph
	if [ ! -d work/agensgraph-2.13.1 ]; \
		then mkdir -p work && \
		cd work && \
		curl -s -L https://github.com/bitnine-oss/agensgraph/archive/refs/tags/v2.13.1.tar.gz | tar vxzf -; \
		fi
	docker run $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/alpinograph-in-docker/build/opt:/opt \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/work/agensgraph-2.13.1:/agensgraph \
		localhost/alpinograph-devel:latest \
		/scripts/install-agensgraph.sh

step4:	step2 ## installeer AlpinoGraph
	docker run $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/alpinograph-in-docker/build:/build \
		-v $(PWD)/alpinograph-in-docker/build/opt:/opt \
		-v $(PWD)/work/cache:/cache \
		-v $(PWD)/scripts:/scripts \
		localhost/alpinograph-devel:latest \
		/scripts/install-alpinograph.sh

step5:	step2 ## installeer dact_attrib
	docker run $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/alpinograph-in-docker/build/opt:/opt \
		-v $(PWD)/work/cache:/cache \
		-v $(PWD)/src:/src \
		-v $(PWD)/scripts:/scripts \
		localhost/alpinograph-devel:latest \
		/scripts/install-tools.sh

step8:	step3 step4 step5 ## maak image van AlpinoGraph in Docker
	alpinograph-in-docker/build/build.sh

step9:	step8 ## push image van AlpinoGraph in Docker naar de server
	@echo
	@echo -e '\e[1mVergeet niet af en toe oude versies te verwijderen, anders is ons quotum op\e[0m'
	@echo https://registry.webhosting.rug.nl/harbor/projects/57/repositories/alpinograph/artifacts-tab
	@echo
	cd alpinograph-in-docker/build && ./push.sh

