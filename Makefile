# Makefile for dnsdist server
# 

RED="\e[31m"
ORANGE="\e[33m"
BLUE="\e[94m"
GREEN="\e[92m"
STOP="\e[0m"
fwstat=$(shell echo ? | socat - UDP:localhost:53474)

commit:
	git -C /etc commit -a -m 'autocommit, see logs' 

logview:
	tail -F /var/log/messages

restart:
	service dnsdist restart
	make logview

enable:
	@bash -c 'echo 1 > /dev/udp/127.0.0.1/53474'
	@printf ${RED}
	@figlet -w 200 -f  small ON
	@printf ${STOP}

on: enable
	
disable:
	@bash -c 'echo 0 > /dev/udp/127.0.0.1/53474'
	@printf ${GREEN}
	@figlet -w 200 -f  small OFF
	@printf ${STOP}

off: disable

.SHELL=/bin/bash
status:
	@echo socat udp:53474 '->' ${fwstat}
	@if [ "${fwstat}" = "1" ]; then\
		printf ${RED}; \
	        figlet ON;\
		printf ${STOP}; \
	else \
		printf ${GREEN}; \
		figlet OFF; \
		printf ${STOP}; \
	fi
	@# 0 = disabled, 1 = enabled

fwrestart:
	service fwstat.service restart

rules:
	@sed -e '1,/BEGIN_RULES/d' -e '/END_RULES/,$$d' < dnsdist.conf | pygmentize -l lua

PKGMGR="apk" # for Alpine Linux, or apt for Debian, or pkg for FreeBSD
PKGCMD="add" # or install
dependencies:
	$(PKGMGR) $(PKGCMD) vim rsync git tig postfix logger py3-pygments figlet
	$(PKGMGR) $(PKGCMD) lua5.4 lua5.4-socket socat

5 10 15 25 30 35 40 45 50 55:
	@make off
	@echo "make on" | at now +$@ minutes
	@at -l | sort 
