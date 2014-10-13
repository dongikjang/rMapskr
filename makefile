push:
	git push git@github.com:dongikjang/rMapskr master:master
	
docs:
	cd inst/docs && \
	git add . && \
	git commit -am "update documentations" && \
	git push git@github.com:dongikjang/rMapskr master:gh-pages && \

