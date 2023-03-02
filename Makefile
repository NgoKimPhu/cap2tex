# Self documented Makefile
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show list of make targets and their description
	@grep -E '^[/%.a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL:= help

ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif

/usr/local/bin/tesseract:
	brew install tesseract

/usr/local/share/tessdata/HanS.traineddata:
	curl -L 'https://github.com/tesseract-ocr/tessdata_best/raw/main/script/HanS.traineddata' -o /usr/local/share/tessdata/HanS.traineddata

.PHONY: deps install
deps: /usr/local/bin/tesseract /usr/local/share/tessdata/HanS.traineddata ## Install dependencies (tesseract, language models, and python tools)
	pip3 install -r requirements.txt

install: deps ## Install dependencies and install main python script to PREFIX bin
	install -m 755 cap2tex $(DESTDIR)$(PREFIX)/bin/
