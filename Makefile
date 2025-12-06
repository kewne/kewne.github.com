.PHONY: setup-dev-env \
	run


setup-dev-env:
	bundle install

run:
	bundle exec jekyll serve --watch --livereload --drafts
