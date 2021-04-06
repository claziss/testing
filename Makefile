TESTS ?=
DJ = timeout 4h runtest
CPU = none fpus fpud

ARC_TOOLS=`arc64-elf-gcc -dumpversion`
DATE=`date +'%y.%m.%d %H:%M:%S'`
MACHINE=`arc64-elf-gcc -dumpmachine`

all: git

$(CPU):
	mkdir -p tmp_$@
	cp site.exp tmp_$@; \
	cd tmp_$@; mkdir -p tmp; mkdir -p tmp/dump1; mkdir -p tmp/dump2;	 \
	GCC_TEST_RUN_EXPENSIVE=1 ARC_MULTILIB_OPTIONS="-mfpu=$@" $(DJ) --tool=gcc $(TESTS) || true
	mv -u tmp_$@/gcc.sum gcc_$(MACHINE)_$@.sum

git: $(CPU)
	git add *.sum
	echo "$(MACHINE) $(ARC_TOOLS) $(DATE)" > timestamp
	git commit -aF timestamp
	git push

clean:
	rm -rf tmp*
