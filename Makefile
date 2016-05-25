#TESTS=compile.exp builtins.exp execute.exp ieee.exp unsorted.exp autopar.exp \
	charset.exp compat.exp struct-layout-1.exp cpp.exp trad.exp debug.exp  \
	dwarf2.exp dfp.exp dg.exp fixed-point.exp format.exp gomp.exp \
	graphite.exp ipa.exp lto.exp noncompile.exp pch.exp plugin.exp \
	simulate-thread.exp special.exp tls.exp tm.exp dg-torture.exp \
	stackalign.exp tree-prof.exp  tree-ssa.exp vect.exp weak.exp arc.exp
TESTS=compile.exp builtins.exp execute.exp ieee.exp unsorted.exp dg.exp\
	compat.exp struct-layout-1.exp lto.exp dg-torture.exp
DJ=timeout 60m runtest
CPU=em arcem em4 em4_dmips em4_fpus em4_fpuda hs archs hs34 hs38 hs38_linux \
	arc700 arc600 arc600_norm arc600_mul64  arc601 arc601_norm \
	arc601_mul64

ARC_TOOLS=`arc-elf32-gcc -dumpversion`
DATE=`date +'%y.%m.%d %H:%M:%S'`
MACHINE=`arc-elf32-gcc -dumpmachine`

all: git

$(CPU):
	mkdir -p tmp_$@
	cd tmp_$@; mkdir -p tmp; ARC_MULTILIB_OPTIONS="-mcpu=$@" $(DJ) --tool=gcc $(TESTS) || true
	mv tmp_$@/gcc.sum gcc_$(MACHINE)_$@.sum

git: $(CPU)
	git add *.sum
	echo "$(MACHINE) $(ARC_TOOLS) $(DATE)" > timestamp
	git commit -aF timestamp
	git push
