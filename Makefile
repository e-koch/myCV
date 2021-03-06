# This work is dedicated to the public domain.

# Basic settings

toolsdir = ../worklog-tools

# `make` targets are:
#
#        all - the default; create {cv,pubs}.{pdf,html}
#    summary - summarize entries
# update-ads - update ADS citation counts
#      clean - delete generated files

# Settings that probably won't need to be changed:

driver = $(toolsdir)/wltool
infos = $(wildcard *.txt)

# Rules:

all: cv.pdf cv_short.pdf cv_nopubs.pdf pubs.pdf cv.html pubs.html

cv.tex: $(driver) cv.tmpl.tex $(infos)
	python2 $< latex cv.tmpl.tex >$@.new && mv -f $@.new $@

cv_short.tex: $(driver) cv_short.tmpl.tex $(infos)
	python2 $< latex cv_short.tmpl.tex >$@.new && mv -f $@.new $@

cv_nopubs.tex: $(driver) cv_short.tmpl.tex $(infos)
	python2 $< latex cv_nopubs.tmpl.tex >$@.new && mv -f $@.new $@

pubs.tex: $(driver) pubs.tmpl.tex $(infos)
	python2 $< latex pubs.tmpl.tex >$@.new && mv -f $@.new $@

cv.html: $(driver) cv.tmpl.html $(infos)
	python2 $< html cv.tmpl.html >$@.new && mv -f $@.new $@

pubs.html: $(driver) pubs.tmpl.html $(infos)
	python2 $< html pubs.tmpl.html >$@.new && mv -f $@.new $@

summary: $(infos)
	python2 $(driver) summarize

update-ads:
	python2 $(driver) update-cites

clean:
	-rm -f *.aux *.log *.log2 *.out *.html *.pdf cv.tex cv_short.tex cv_nopubs.tex pubs.html pubs.pdf pubs.tex

%.pdf: %.tex
	@echo + making $@ -- error messages are in $*.log2 if anything goes wrong
	pdflatex $< >$*.log2
	pdflatex $< >$*.log2


# clear default make rules:
.SUFFIXES:
