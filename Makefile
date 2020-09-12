V = $(shell git describe --abbrev=0)

FILE_PREFIX = chaotic
PREFIX = /usr/local
DEFAULT_KEY = 3056513887B78AEB

install:
	install -dm755 $(DESTDIR)$(PREFIX)/share/pacman/keyrings/
	install -m0644 ${FILE_PREFIX}{.gpg,-trusted,-revoked} $(DESTDIR)$(PREFIX)/share/pacman/keyrings/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/share/pacman/keyrings/${FILE_PREFIX}{.gpg,-trusted,-revoked}
	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/share/pacman/keyrings/
dist:
	git archive --format=tar --prefix=${FILE_PREFIX}-keyring-$(V)/ master | gzip -9 > ${FILE_PREFIX}-keyring-$(V).tar.gz
	gpg --default-key ${DEFAULT_KEY} --detach-sign --use-agent ${FILE_PREFIX}-keyring-$(V).tar.gz

upload:
	rsync --chmod 644 --progress ${FILE_PREFIX}-keyring-$(V).tar.gz ${FILE_PREFIX}-keyring-$(V).tar.gz.sig ${FILE_PREFIX}.org:/nginx/var/www/keyring/

.PHONY: install uninstall dist upload

