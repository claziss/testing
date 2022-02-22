TESTS ?=
DJ = timeout 4h runtest
CPU = none fpus fpud fpud_mwide fpud_mwide_m128 none_m128_msimd none_mcpu=hs5x none_mcpu=hs58

ARC_TOOLS=`arc64-elf-gcc -dumpversion`
DATE=`date +'%y.%m.%d %H:%M:%S'`
MACHINE=`arc64-elf-gcc -dumpmachine`


all: git

$(CPU):
	@mkdir -p tmp_$@
	@echo "Running $(subst _, -,$@)"
	cp site.exp tmp_$@; \
	cd tmp_$@; mkdir -p tmp; mkdir -p dump1; mkdir -p dump2; \
	mkdir -p tmp/dump1; mkdir -p tmp/dump2; \
	GCC_TEST_RUN_EXPENSIVE=1 ARC_MULTILIB_OPTIONS="-mfpu=$(subst _, -,$@)" \
	$(DJ) --tool=gcc $(TESTS) || true
	mv -u tmp_$@/gcc.sum gcc_$(MACHINE)_$@.sum

git: $(CPU)
	git add *.sum
	echo "$(MACHINE) $(ARC_TOOLS) $(DATE)" > timestamp
	git commit -aF timestamp
	git push

clean:
	rm -rf tmp*
