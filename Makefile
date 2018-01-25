# Name of your emacs binary
EMACS=emacs

BATCH=$(EMACS) --batch --no-init-file					\
  --eval '(require (quote org))'					\
  --eval "(org-babel-do-load-languages 'org-babel-load-languages	\
         '((shell . t)))"						\
  --eval "(setq org-confirm-babel-evaluate nil)"			\
  --eval '(setq starter-kit-dir default-directory)'			\
  --eval '(org-babel-tangle-file "ow-publish.org")'	              	\
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
	@(cd ../xgarrido.github.io;tar xzvf /tmp/org-website-publish.tar.gz; git commit -am "update website" && git push)
	@echo "NOTICE: HTML documentation published"

clean:
	@rm -f *.elc *.aux *.tex *.pdf *~
	@rm -rf pub
