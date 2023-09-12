# Makefile to generate data:
#  template scripts -> final scripts
#  markdown files -> html files

TEMPLATE = $(wildcard *.template)
CAPSMAN = $(TEMPLATE:.template=.capsman)
LOCAL = $(TEMPLATE:.template=.local)

MARKDOWN = $(wildcard *.md)
HTML =  $(MARKDOWN:.md=.html)

all: $(CAPSMAN) $(LOCAL) $(HTML)

%.html: %.md Makefile
	markdown $< | sed 's/href="\([-[:alnum:]]*\)\.md"/href="\1.html"/g' > $@

%.local: %.template Makefile
	sed -e '/\/ caps-man/d' -e 's|%PATH%|interface wireless|' -e 's|%TEMPL%|$(suffix $@)|' \
		-e '/^# !!/,/^# !!/c # !! Do not edit this file, it is generated from template!' \
		< $< > $@

%.capsman: %.template Makefile
	sed -e '/\/ interface wireless/d' -e 's/%PATH%/caps-man/' -e 's/%TEMPL%/$(suffix $@)/' \
		-e '/^# !!/,/^# !!/c # !! Do not edit this file, it is generated from template!' \
		< $< > $@
