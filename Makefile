# Name of your emacs binary
EMACS=emacs

BATCH=$(EMACS) --batch --no-init-file					\
  --eval '(require (quote org))'					\
  --eval "(org-babel-do-load-languages 'org-babel-load-languages	\
         '((sh . t)))"							\
  --eval "(setq org-confirm-babel-evaluate nil)"			\
  --eval '(setq starter-kit-dir default-directory)'			\
  --eval '(org-babel-tangle-file "ow-publish.org")'	              		\
  --eval '(org-babel-load-file   "ow-publish.org")'

FILES = ow-main.org

doc: html

html: $(FILES)
	@mkdir -p pub/css
	@$(BATCH) --visit "$<" --funcall org-publish-html
	@rm -f *.el
	@echo "NOTICE: Documentation published to pub/"

publish: html
	@find pub -name *.*~ | xargs rm -f
	@(cd pub/ && tar czvf /tmp/org-website-publish.tar.gz .)
	@git checkout xgarrido.github.io
	@tar xzvf /tmp/org-website-publish.tar.gz
	# @if [ -n "`git status --porcelain`" ]; then git commit -am "update doc" && git push; fi
	# @git checkout master
	@echo "NOTICE: HTML documentation published"

clean:
	@rm -f *.elc *.aux *.tex *.pdf *~
	@rm -rf pub
