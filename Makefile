.PHONY: setup-dev-env \
	run \
	build

setup-dev-env:
	bundle install

run:
	bundle exec jekyll serve --watch --livereload --drafts

build:
	find _patterns -name "*.puml" -exec plantuml -tsvg {} \;
