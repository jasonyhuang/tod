SHELL = /bin/csh
#VCS = vcs +incdir+. +incdir+../rtl +incdir+../tb +incdir+../test -full64 -sverilog +v2k +libext+.v -timescale=1ns/100ps -Mupdate -Mdir=crsc.simv -o simv
#VCS = vcs -full64 -cpp g++-7 -cc gcc-7 -LDFLAGS -Wl,--no-as-needed +incdir+. +incdir+../rtl +incdir+../tb +incdir+../test -sverilog +v2k +libext+.v -timescale=1ns/100ps -Mupdate -Mdir=crsc.simv -o simv
VCS = vcs -LDFLAGS -Wl,--no-as-needed +incdir+. +incdir+../rtl +incdir+../tb +incdir+../test -full64 -sverilog +v2k +libext+.v -timescale=1ns/100ps -Mupdate -Mdir=crsc.simv -o simv
VCS_OPTION = +vcs+initreg+random+noreg
VERDI = verdi +incdir+. +incdir+../rtl +incdir+../tb +incdir+../test -sverilog +v2k
VERDI_OPTION = -nologo -autoalias
FSDB_OPTION = +define+DUMP_FSDB
VPD_OPTION = +define+DUMP_VPD
CM_OPTION = +define+NO_STOP_ON_ERR -cm line+assert+tgl+cond+branch+fsm -cm_dir simv.vdb
CM_OPTION2 = -cm_tgl mda
SIMV = ./simv
f = $(shell ls -t *.f | head -1 | sed -r "s/\.f//g")
l = sim

vcs_fsdb: com_fsdb sim
vcs_vpd: com_vpd sim
vcs_cm: com_cm sim_cm
vcs_deb: com_fsdb sim deb
vcs_dve: com_vpd sim dve
vcs_cov: com_cm sim_cm cov

com_fsdb::
	$(VCS) $(FSDB_OPTION) -f $(f).f -l vcs.log -debug_access+all

com_vpd::
	$(VCS) $(VPD_OPTION) -f $(f).f -l vcs.log -debug_access+all

com_cm::
	$(VCS) $(CM_OPTION) -f $(f).f -cm_line contassign -cm_cond allops -l vcs.log -debug_access+all

com::
	$(VCS) +lint=all,noVCDE,noIWU,noNS,noZERO -f $(f).f -l vcs.log -debug_access+all

sim_cm::
	$(SIMV) $(CM_OPTION) -l $(l).log

sim::
	$(SIMV) -l $(l).log

vcs::
	$(VCS) -j8 +rad -f $(f).f -R -l $(l).log

deb::
ifneq ($(wildcard $(f).fsdb), )
	$(VERDI) $(VERDI_OPTION) -f $(f).f -ssf $(f).fsdb &
else
	$(VERDI) $(VERDI_OPTION) -f $(f).f &
endif

dve::
ifneq ($(wildcard $(f).vpd), )
	dve -full64 -vpd $(f).vpd &
else
	dve -full64 &
endif

cov::
ifneq ($(wildcard merged_cov_db.vdb), )
	verdi -cov -covdir merged_cov_db.vdb &
else ifneq ($(wildcard simv.vdb), )
	verdi -cov -covdir simv.vdb &
else
	verdi -cov &
endif

vcf::
	vcf -verdi -f $(f).tcl

clean::
	rm -rf ./csrc ./urgReport ./vdCovLog ./crsc.simv *.daidir *.log  *.vpd  *.vdb  simv* *.key verdi* *fsdb DVE* novas.* *.bak vcst_rtdb
