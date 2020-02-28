all: Makefile.coq
	make -f Makefile.coq

clean: Makefile.coq
	make -f Makefile.coq clean

install: Makefile.coq
	make -f Makefile.coq install COQLIB=$(COQLIB)

fullclean: clean
	rm -f .*.aux Makefile.coq Makefile.coq.conf

Makefile.coq: _CoqProject
	coq_makefile -f $< -o $@
