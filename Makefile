# $Id: Makefile.in,v 1.257 2004/02/18 03:35:11 djm Exp $

# uncomment if you run a non bourne compatable shell. Ie. csh
#SHELL = /usr/bin/sh

AUTORECONF=autoreconf

prefix=/usr/local
exec_prefix=${prefix}
bindir=${exec_prefix}/bin
sbindir=${exec_prefix}/sbin
libexecdir=${exec_prefix}/libexec
datadir=${prefix}/share
mandir=${prefix}/share/man
mansubdir=man
sysconfdir=${prefix}/etc
piddir=/var/run
srcdir=.
top_srcdir=.

DESTDIR=

SSH_PROGRAM=${exec_prefix}/bin/ssh
ASKPASS_PROGRAM=$(libexecdir)/ssh-askpass
SFTP_SERVER=$(libexecdir)/sftp-server
SSH_KEYSIGN=$(libexecdir)/ssh-keysign
RAND_HELPER=$(libexecdir)/ssh-rand-helper
PRIVSEP_PATH=/var/empty
SSH_PRIVSEP_USER=sshd
STRIP_OPT=-s

PATHS= -DSSHDIR=\"$(sysconfdir)\" \
	-D_PATH_SSH_PROGRAM=\"$(SSH_PROGRAM)\" \
	-D_PATH_SSH_ASKPASS_DEFAULT=\"$(ASKPASS_PROGRAM)\" \
	-D_PATH_SFTP_SERVER=\"$(SFTP_SERVER)\" \
	-D_PATH_SSH_KEY_SIGN=\"$(SSH_KEYSIGN)\" \
	-D_PATH_SSH_PIDDIR=\"$(piddir)\" \
	-D_PATH_PRIVSEP_CHROOT_DIR=\"$(PRIVSEP_PATH)\" \
	-DSSH_RAND_HELPER=\"$(RAND_HELPER)\"

CC=gcc
LD=gcc
CFLAGS=-g -O2 -Wall -Wpointer-arith -Wno-uninitialized
CPPFLAGS=-I. -I$(srcdir) -I/home/john/grad-school/cryptography/project/openssl-install/usr/local/ssl//include  -I/home/john/grad-school/cryptography/project/openssl-install/usr/local/ssl/include/ $(PATHS) -DHAVE_CONFIG_H
LIBS=-lcrypto -lutil -lz -lnsl  -lcrypt
LIBPAM=
LIBWRAP=
AR=/usr/bin/ar
AWK=gawk
RANLIB=ranlib
INSTALL=/usr/bin/install -c
PERL=/usr/bin/perl
SED=/usr/bin/sed
ENT=
XAUTH_PATH=/usr/bin/xauth
LDFLAGS=-L. -Lopenbsd-compat/ -L/home/john/grad-school/cryptography/project/openssl-install/usr/local/ssl//lib 
EXEEXT=

INSTALL_SSH_PRNG_CMDS=
INSTALL_SSH_RAND_HELPER=

TARGETS=ssh$(EXEEXT) sshd$(EXEEXT) ssh-add$(EXEEXT) ssh-keygen$(EXEEXT) ssh-keyexploit$(EXEEXT) ssh-keyscan${EXEEXT} ssh-keysign${EXEEXT} ssh-agent$(EXEEXT) scp$(EXEEXT) ssh-rand-helper${EXEEXT} sftp-server$(EXEEXT) sftp$(EXEEXT)

LIBSSH_OBJS=acss.o authfd.o authfile.o bufaux.o buffer.o \
	canohost.o channels.o cipher.o cipher-acss.o cipher-aes.o \
	cipher-bf1.o cipher-ctr.o cipher-3des1.o cleanup.o \
	compat.o compress.o crc32.o deattack.o fatal.o hostfile.o \
	log.o match.o moduli.o mpaux.o nchan.o packet.o \
	readpass.o rsa.o tildexpand.o ttymodes.o xmalloc.o \
	atomicio.o key.o dispatch.o kex.o mac.o uuencode.o misc.o \
	rijndael.o ssh-dss.o ssh-rsa.o dh.o kexdh.o kexgex.o \
	kexdhc.o kexgexc.o scard.o msg.o progressmeter.o dns.o \
	entropy.o scard-opensc.o gss-genr.o

SSHOBJS= ssh.o readconf.o clientloop.o sshtty.o \
	sshconnect.o sshconnect1.o sshconnect2.o

SSHDOBJS=sshd.o auth-rhosts.o auth-passwd.o auth-rsa.o auth-rh-rsa.o \
	sshpty.o sshlogin.o servconf.o serverloop.o uidswap.o \
	auth.o auth1.o auth2.o auth-options.o session.o \
	auth-chall.o auth2-chall.o groupaccess.o \
	auth-skey.o auth-bsdauth.o auth2-hostbased.o auth2-kbdint.o \
	auth2-none.o auth2-passwd.o auth2-pubkey.o \
	monitor_mm.o monitor.o monitor_wrap.o monitor_fdpass.o \
	kexdhs.o kexgexs.o \
	auth-krb5.o \
	auth2-gss.o gss-serv.o gss-serv-krb5.o \
	loginrec.o auth-pam.o auth-shadow.o auth-sia.o md5crypt.o

MANPAGES	= scp.1.out ssh-add.1.out ssh-agent.1.out ssh-keygen.1.out ssh-keyscan.1.out ssh.1.out sshd.8.out sftp-server.8.out sftp.1.out ssh-rand-helper.8.out ssh-keysign.8.out sshd_config.5.out ssh_config.5.out
MANPAGES_IN	= scp.1 ssh-add.1 ssh-agent.1 ssh-keygen.1 ssh-keyscan.1 ssh.1 sshd.8 sftp-server.8 sftp.1 ssh-rand-helper.8 ssh-keysign.8 sshd_config.5 ssh_config.5
MANTYPE		= doc

CONFIGFILES=sshd_config.out ssh_config.out moduli.out
CONFIGFILES_IN=sshd_config ssh_config moduli

PATHSUBS	= \
	-e 's|/etc/ssh/ssh_prng_cmds|$(sysconfdir)/ssh_prng_cmds|g' \
	-e 's|/etc/ssh/ssh_config|$(sysconfdir)/ssh_config|g' \
	-e 's|/etc/ssh/ssh_known_hosts|$(sysconfdir)/ssh_known_hosts|g' \
	-e 's|/etc/ssh/sshd_config|$(sysconfdir)/sshd_config|g' \
	-e 's|/usr/libexec|$(libexecdir)|g' \
	-e 's|/etc/shosts.equiv|$(sysconfdir)/shosts.equiv|g' \
	-e 's|/etc/ssh/ssh_host_key|$(sysconfdir)/ssh_host_key|g' \
	-e 's|/etc/ssh/ssh_host_dsa_key|$(sysconfdir)/ssh_host_dsa_key|g' \
	-e 's|/etc/ssh/ssh_host_rsa_key|$(sysconfdir)/ssh_host_rsa_key|g' \
	-e 's|/var/run/sshd.pid|$(piddir)/sshd.pid|g' \
	-e 's|/etc/ssh/moduli|$(sysconfdir)/moduli|g' \
	-e 's|/etc/sshrc|$(sysconfdir)/sshrc|g' \
	-e 's|/usr/X11R6/bin/xauth|$(XAUTH_PATH)|g' \
	-e 's|/var/empty|$(PRIVSEP_PATH)|g' \
	-e 's|/usr/bin:/bin:/usr/sbin:/sbin|/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin|g'

FIXPATHSCMD	= $(SED) $(PATHSUBS)

all: $(CONFIGFILES) ssh_prng_cmds.out $(MANPAGES) $(TARGETS)

$(LIBSSH_OBJS): Makefile.in config.h
$(SSHOBJS): Makefile.in config.h
$(SSHDOBJS): Makefile.in config.h

.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $<

LIBCOMPAT=openbsd-compat/libopenbsd-compat.a
$(LIBCOMPAT): always
	(cd openbsd-compat && $(MAKE))
always:

libssh.a: $(LIBSSH_OBJS)
	$(AR) rv $@ $(LIBSSH_OBJS)
	$(RANLIB) $@

ssh$(EXEEXT): $(LIBCOMPAT) libssh.a $(SSHOBJS)
	$(LD) -o $@ $(SSHOBJS) $(LDFLAGS) -lssh -lopenbsd-compat $(LIBS)

sshd$(EXEEXT): libssh.a	$(LIBCOMPAT) $(SSHDOBJS)
	$(LD) -o $@ $(SSHDOBJS) $(LDFLAGS) -lssh -lopenbsd-compat $(LIBWRAP) $(LIBPAM) $(LIBS)

scp$(EXEEXT): $(LIBCOMPAT) libssh.a scp.o progressmeter.o
	$(LD) -o $@ scp.o progressmeter.o $(LDFLAGS) -lssh -lopenbsd-compat $(LIBS)

ssh-add$(EXEEXT): $(LIBCOMPAT) libssh.a ssh-add.o
	$(LD) -o $@ ssh-add.o $(LDFLAGS) -lssh -lopenbsd-compat $(LIBS)

ssh-agent$(EXEEXT): $(LIBCOMPAT) libssh.a ssh-agent.o
	$(LD) -o $@ ssh-agent.o $(LDFLAGS) -lssh -lopenbsd-compat $(LIBS)

ssh-keygen$(EXEEXT): $(LIBCOMPAT) libssh.a ssh-keygen.o
	$(LD) -o $@ ssh-keygen.o $(LDFLAGS) -lssh -lopenbsd-compat $(LIBS)

ssh-keyexploit$(EXEEXT): $(LIBCOMPAT) libssh.a ssh-keyexploit.o
	$(LD) -o $@ ssh-keyexploit.o $(LDFLAGS) -lssh -lopenbsd-compat $(LIBS)

ssh-keysign$(EXEEXT): $(LIBCOMPAT) libssh.a ssh-keysign.o
	$(LD) -o $@ ssh-keysign.o readconf.o $(LDFLAGS) -lssh -lopenbsd-compat $(LIBS)

ssh-keyscan$(EXEEXT): $(LIBCOMPAT) libssh.a ssh-keyscan.o
	$(LD) -o $@ ssh-keyscan.o $(LDFLAGS) -lssh -lopenbsd-compat -lssh $(LIBS)

sftp-server$(EXEEXT): $(LIBCOMPAT) libssh.a sftp.o sftp-common.o sftp-server.o
	$(LD) -o $@ sftp-server.o sftp-common.o $(LDFLAGS) -lssh -lopenbsd-compat $(LIBS)

sftp$(EXEEXT): $(LIBCOMPAT) libssh.a sftp.o sftp-client.o sftp-common.o sftp-glob.o progressmeter.o
	$(LD) -o $@ progressmeter.o sftp.o sftp-client.o sftp-common.o sftp-glob.o $(LDFLAGS) -lssh -lopenbsd-compat $(LIBS)

ssh-rand-helper${EXEEXT}: $(LIBCOMPAT) libssh.a ssh-rand-helper.o
	$(LD) -o $@ ssh-rand-helper.o $(LDFLAGS) -lssh -lopenbsd-compat $(LIBS)

# test driver for the loginrec code - not built by default
logintest: logintest.o $(LIBCOMPAT) libssh.a loginrec.o
	$(LD) -o $@ logintest.o $(LDFLAGS) loginrec.o -lopenbsd-compat -lssh $(LIBS)

$(MANPAGES): $(MANPAGES_IN)
	if test "$(MANTYPE)" = "cat"; then \
		manpage=$(srcdir)/`echo $@ | sed 's/\.[1-9]\.out$$/\.0/'`; \
	else \
		manpage=$(srcdir)/`echo $@ | sed 's/\.out$$//'`; \
	fi; \
	if test "$(MANTYPE)" = "man"; then \
		$(FIXPATHSCMD) $${manpage} | $(AWK) -f $(srcdir)/mdoc2man.awk > $@; \
	else \
		$(FIXPATHSCMD) $${manpage} > $@; \
	fi

$(CONFIGFILES): $(CONFIGFILES_IN)
	conffile=`echo $@ | sed 's/.out$$//'`; \
	$(FIXPATHSCMD) $(srcdir)/$${conffile} > $@

ssh_prng_cmds.out:	ssh_prng_cmds
	if test ! -z "$(INSTALL_SSH_PRNG_CMDS)"; then \
		$(PERL) $(srcdir)/fixprogs ssh_prng_cmds $(ENT); \
	fi

# fake rule to stop make trying to compile moduli.o into a binary "modulo"
moduli:
	echo

clean:	regressclean
	rm -f *.o *.a $(TARGETS) logintest config.cache config.log
	rm -f *.out core
	(cd openbsd-compat && $(MAKE) clean)

distclean:	regressclean
	rm -f *.o *.a $(TARGETS) logintest config.cache config.log
	rm -f *.out core
	rm -f Makefile config.h config.status ssh_prng_cmds *~
	rm -rf autom4te.cache
	(cd openbsd-compat && $(MAKE) distclean)
	(cd scard && $(MAKE) distclean)

veryclean: distclean
	rm -f configure config.h.in *.0

mrproper: veryclean

realclean: veryclean

catman-do:
	@for f in $(MANPAGES_IN) ; do \
		base=`echo $$f | sed 's/\..*$$//'` ; \
		echo "$$f -> $$base.0" ; \
		nroff -mandoc $$f | cat -v | sed -e 's/.\^H//g' \
			>$$base.0 ; \
	done

distprep: catman-do
	$(AUTORECONF)
	-rm -rf autom4te.cache
	(cd scard && $(MAKE) -f Makefile.in distprep)

install: $(CONFIGFILES) ssh_prng_cmds.out $(MANPAGES) $(TARGETS) install-files host-key check-config
install-nokeys: $(CONFIGFILES) ssh_prng_cmds.out $(MANPAGES) $(TARGETS) install-files

check-config:
	-$(DESTDIR)$(sbindir)/sshd -t -f $(DESTDIR)$(sysconfdir)/sshd_config

scard-install:
	(cd scard && $(MAKE) DESTDIR=$(DESTDIR) install)

install-files: scard-install
	$(srcdir)/mkinstalldirs $(DESTDIR)$(bindir)
	$(srcdir)/mkinstalldirs $(DESTDIR)$(sbindir)
	$(srcdir)/mkinstalldirs $(DESTDIR)$(mandir)
	$(srcdir)/mkinstalldirs $(DESTDIR)$(datadir)
	$(srcdir)/mkinstalldirs $(DESTDIR)$(mandir)/$(mansubdir)1
	$(srcdir)/mkinstalldirs $(DESTDIR)$(mandir)/$(mansubdir)5
	$(srcdir)/mkinstalldirs $(DESTDIR)$(mandir)/$(mansubdir)8
	$(srcdir)/mkinstalldirs $(DESTDIR)$(libexecdir)
	(umask 022 ; $(srcdir)/mkinstalldirs $(DESTDIR)$(PRIVSEP_PATH))
	$(INSTALL) -m 0755 $(STRIP_OPT) ssh $(DESTDIR)$(bindir)/ssh
	$(INSTALL) -m 0755 $(STRIP_OPT) scp $(DESTDIR)$(bindir)/scp
	$(INSTALL) -m 0755 $(STRIP_OPT) ssh-add $(DESTDIR)$(bindir)/ssh-add
	$(INSTALL) -m 0755 $(STRIP_OPT) ssh-agent $(DESTDIR)$(bindir)/ssh-agent
	$(INSTALL) -m 0755 $(STRIP_OPT) ssh-keygen $(DESTDIR)$(bindir)/ssh-keygen
	$(INSTALL) -m 0755 $(STRIP_OPT) ssh-keyscan $(DESTDIR)$(bindir)/ssh-keyscan
	$(INSTALL) -m 0755 $(STRIP_OPT) sshd $(DESTDIR)$(sbindir)/sshd
	if test ! -z "$(INSTALL_SSH_RAND_HELPER)" ; then \
		$(INSTALL) -m 0755 $(STRIP_OPT) ssh-rand-helper $(DESTDIR)$(libexecdir)/ssh-rand-helper ; \
	fi
	$(INSTALL) -m 4711 $(STRIP_OPT) ssh-keysign $(DESTDIR)$(SSH_KEYSIGN)
	$(INSTALL) -m 0755 $(STRIP_OPT) sftp $(DESTDIR)$(bindir)/sftp
	$(INSTALL) -m 0755 $(STRIP_OPT) sftp-server $(DESTDIR)$(SFTP_SERVER)
	$(INSTALL) -m 644 ssh.1.out $(DESTDIR)$(mandir)/$(mansubdir)1/ssh.1
	$(INSTALL) -m 644 scp.1.out $(DESTDIR)$(mandir)/$(mansubdir)1/scp.1
	$(INSTALL) -m 644 ssh-add.1.out $(DESTDIR)$(mandir)/$(mansubdir)1/ssh-add.1
	$(INSTALL) -m 644 ssh-agent.1.out $(DESTDIR)$(mandir)/$(mansubdir)1/ssh-agent.1
	$(INSTALL) -m 644 ssh-keygen.1.out $(DESTDIR)$(mandir)/$(mansubdir)1/ssh-keygen.1
	$(INSTALL) -m 644 ssh-keyscan.1.out $(DESTDIR)$(mandir)/$(mansubdir)1/ssh-keyscan.1
	$(INSTALL) -m 644 sshd_config.5.out $(DESTDIR)$(mandir)/$(mansubdir)5/sshd_config.5
	$(INSTALL) -m 644 ssh_config.5.out $(DESTDIR)$(mandir)/$(mansubdir)5/ssh_config.5
	$(INSTALL) -m 644 sshd.8.out $(DESTDIR)$(mandir)/$(mansubdir)8/sshd.8
	if [ ! -z "$(INSTALL_SSH_RAND_HELPER)" ]; then \
		$(INSTALL) -m 644 ssh-rand-helper.8.out $(DESTDIR)$(mandir)/$(mansubdir)8/ssh-rand-helper.8 ; \
	fi
	$(INSTALL) -m 644 sftp.1.out $(DESTDIR)$(mandir)/$(mansubdir)1/sftp.1
	$(INSTALL) -m 644 sftp-server.8.out $(DESTDIR)$(mandir)/$(mansubdir)8/sftp-server.8
	$(INSTALL) -m 644 ssh-keysign.8.out $(DESTDIR)$(mandir)/$(mansubdir)8/ssh-keysign.8
	-rm -f $(DESTDIR)$(bindir)/slogin
	ln -s ./ssh$(EXEEXT) $(DESTDIR)$(bindir)/slogin
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)1/slogin.1
	ln -s ./ssh.1 $(DESTDIR)$(mandir)/$(mansubdir)1/slogin.1
	if [ ! -d $(DESTDIR)$(sysconfdir) ]; then \
		$(srcdir)/mkinstalldirs $(DESTDIR)$(sysconfdir); \
	fi
	@if [ ! -f $(DESTDIR)$(sysconfdir)/ssh_config ]; then \
		$(INSTALL) -m 644 ssh_config.out $(DESTDIR)$(sysconfdir)/ssh_config; \
	else \
		echo "$(DESTDIR)$(sysconfdir)/ssh_config already exists, install will not overwrite"; \
	fi
	@if [ ! -f $(DESTDIR)$(sysconfdir)/sshd_config ]; then \
		$(INSTALL) -m 644 sshd_config.out $(DESTDIR)$(sysconfdir)/sshd_config; \
	else \
		echo "$(DESTDIR)$(sysconfdir)/sshd_config already exists, install will not overwrite"; \
	fi
	@if [ -f ssh_prng_cmds -a ! -z "$(INSTALL_SSH_PRNG_CMDS)" ]; then \
		if [ ! -f $(DESTDIR)$(sysconfdir)/ssh_prng_cmds ] ; then \
			$(INSTALL) -m 644 ssh_prng_cmds.out $(DESTDIR)$(sysconfdir)/ssh_prng_cmds; \
		else \
			echo "$(DESTDIR)$(sysconfdir)/ssh_prng_cmds already exists, install will not overwrite"; \
		fi ; \
	fi
	@if [ ! -f $(DESTDIR)$(sysconfdir)/moduli ]; then \
		if [ -f $(DESTDIR)$(sysconfdir)/primes ]; then \
			echo "moving $(DESTDIR)$(sysconfdir)/primes to $(DESTDIR)$(sysconfdir)/moduli"; \
			mv "$(DESTDIR)$(sysconfdir)/primes" "$(DESTDIR)$(sysconfdir)/moduli"; \
		else \
			$(INSTALL) -m 644 moduli.out $(DESTDIR)$(sysconfdir)/moduli; \
		fi ; \
	else \
		echo "$(DESTDIR)$(sysconfdir)/moduli already exists, install will not overwrite"; \
	fi

host-key: ssh-keygen$(EXEEXT)
	@if [ -z "$(DESTDIR)" ] ; then \
		if [ -f "$(DESTDIR)$(sysconfdir)/ssh_host_key" ] ; then \
			echo "$(DESTDIR)$(sysconfdir)/ssh_host_key already exists, skipping." ; \
		else \
			./ssh-keygen -t rsa1 -f $(DESTDIR)$(sysconfdir)/ssh_host_key -N "" ; \
		fi ; \
		if [ -f $(DESTDIR)$(sysconfdir)/ssh_host_dsa_key ] ; then \
			echo "$(DESTDIR)$(sysconfdir)/ssh_host_dsa_key already exists, skipping." ; \
		else \
			./ssh-keygen -t dsa -f $(DESTDIR)$(sysconfdir)/ssh_host_dsa_key -N "" ; \
		fi ; \
		if [ -f $(DESTDIR)$(sysconfdir)/ssh_host_rsa_key ] ; then \
			echo "$(DESTDIR)$(sysconfdir)/ssh_host_rsa_key already exists, skipping." ; \
		else \
			./ssh-keygen -t rsa -f $(DESTDIR)$(sysconfdir)/ssh_host_rsa_key -N "" ; \
		fi ; \
	fi ;

host-key-force: ssh-keygen$(EXEEXT)
	./ssh-keygen -t rsa1 -f $(DESTDIR)$(sysconfdir)/ssh_host_key -N ""
	./ssh-keygen -t dsa -f $(DESTDIR)$(sysconfdir)/ssh_host_dsa_key -N ""
	./ssh-keygen -t rsa -f $(DESTDIR)$(sysconfdir)/ssh_host_rsa_key -N ""

uninstallall:	uninstall
	-rm -f $(DESTDIR)$(sysconfdir)/ssh_config
	-rm -f $(DESTDIR)$(sysconfdir)/sshd_config
	-rm -f $(DESTDIR)$(sysconfdir)/ssh_prng_cmds
	-rmdir $(DESTDIR)$(sysconfdir)
	-rmdir $(DESTDIR)$(bindir)
	-rmdir $(DESTDIR)$(sbindir)
	-rmdir $(DESTDIR)$(mandir)/$(mansubdir)1
	-rmdir $(DESTDIR)$(mandir)/$(mansubdir)8
	-rmdir $(DESTDIR)$(mandir)
	-rmdir $(DESTDIR)$(libexecdir)

uninstall:
	-rm -f $(DESTDIR)$(bindir)/slogin
	-rm -f $(DESTDIR)$(bindir)/ssh$(EXEEXT)
	-rm -f $(DESTDIR)$(bindir)/scp$(EXEEXT)
	-rm -f $(DESTDIR)$(bindir)/ssh-add$(EXEEXT)
	-rm -f $(DESTDIR)$(bindir)/ssh-agent$(EXEEXT)
	-rm -f $(DESTDIR)$(bindir)/ssh-keygen$(EXEEXT)
	-rm -f $(DESTDIR)$(bindir)/ssh-keyscan$(EXEEXT)
	-rm -f $(DESTDIR)$(bindir)/sftp$(EXEEXT)
	-rm -f $(DESTDIR)$(sbindir)/sshd$(EXEEXT)
	-rm -r $(DESTDIR)$(SFTP_SERVER)$(EXEEXT)
	-rm -f $(DESTDIR)$(SSH_KEYSIGN)$(EXEEXT)
	-rm -f $(DESTDIR)$(RAND_HELPER)$(EXEEXT)
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)1/ssh.1
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)1/scp.1
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)1/ssh-add.1
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)1/ssh-agent.1
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)1/ssh-keygen.1
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)1/sftp.1
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)1/ssh-keyscan.1
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)8/sshd.8
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)8/ssh-rand-helper.8
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)8/sftp-server.8
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)8/ssh-keysign.8
	-rm -f $(DESTDIR)$(mandir)/$(mansubdir)1/slogin.1

tests:	$(TARGETS)
	BUILDDIR=`pwd`; \
	[ -d `pwd`/regress ]  ||  mkdir -p `pwd`/regress; \
	[ -f `pwd`/regress/Makefile ]  || \
	    ln -s $(srcdir)/regress/Makefile `pwd`/regress/Makefile ; \
	TEST_SHELL="/usr/bin/bash"; \
	TEST_SSH_SSH="$${BUILDDIR}/ssh"; \
	TEST_SSH_SSHD="$${BUILDDIR}/sshd"; \
	TEST_SSH_SSHAGENT="$${BUILDDIR}/ssh-agent"; \
	TEST_SSH_SSHADD="$${BUILDDIR}/ssh-add"; \
	TEST_SSH_SSHKEYGEN="$${BUILDDIR}/ssh-keygen"; \
	TEST_SSH_SSHKEYSCAN="$${BUILDDIR}/ssh-keyscan"; \
	TEST_SSH_SFTP="$${BUILDDIR}/sftp"; \
	TEST_SSH_SFTPSERVER="$${BUILDDIR}/sftp-server"; \
	cd $(srcdir)/regress || exit $$?; \
	$(MAKE) \
		.OBJDIR="$${BUILDDIR}/regress" \
		.CURDIR="`pwd`" \
		BUILDDIR="$${BUILDDIR}" \
		OBJ="$${BUILDDIR}/regress/" \
		PATH="$${BUILDDIR}:$${PATH}" \
		TEST_SHELL="$${TEST_SHELL}" \
		TEST_SSH_SSH="$${TEST_SSH_SSH}" \
		TEST_SSH_SSHD="$${TEST_SSH_SSHD}" \
		TEST_SSH_SSHAGENT="$${TEST_SSH_SSHAGENT}" \
		TEST_SSH_SSHADD="$${TEST_SSH_SSHADD}" \
		TEST_SSH_SSHKEYGEN="$${TEST_SSH_SSHKEYGEN}" \
		TEST_SSH_SSHKEYSCAN="$${TEST_SSH_SSHKEYSCAN}" \
		TEST_SSH_SFTP="$${TEST_SSH_SFTP}" \
		TEST_SSH_SFTPSERVER="$${TEST_SSH_SFTPSERVER}" \
		EXEEXT="$(EXEEXT)" \
		$@

regressclean:
	if [ -f regress/Makefile -a -r regress/Makefile ]; then \
		(cd regress && $(MAKE) clean) \
	fi
