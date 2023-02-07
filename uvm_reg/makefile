.PHONY: com sim cov clean debug

#DEFINE
ALL_DEFINE = +define+VPD_ON

#OUTPUT
OUTPUT = simv

#code coverage command 
CM = -cm line+cond+fsm+branch+tgl
CM_NAME = -cm_name $(OUTPUT)
CM_DIR = -cm_dir ./$(OUTPUT).vdb

#vpd file name
VPD_NAME = +vpdfile+$(OUTPUT).vpd

VLOGAN_OPT = vlogan -full64 -kdb -timescale=1ns/1ps \
			 +v2k -sverilog \
			 -debug_access+all \
		         -Mupdate \
			 -ntb_opts uvm-1.1 \
			 +incdir+. \
			 $(ALL_DEFINE) \
			 -l vlogan.log

VCSOPT = vcs -full64 -sverilog +v2k -timescale=1ns/1ps -debug_access+all \
		 -error=IWNF \
		 +lint=TFIPC-L \
		 -Mupdate \
		 -ntb_opts uvm-1.1 \
		 +incdir+. \
		 $(CM) \
		 $(CM_NAME) \
		 $(CM_DIR) \
		 -o $(OUTPUT) \
		 -l compile.log

#simulation command
SIM = ./$(OUTPUT) $(CM) $(CM_NAME) $(CM_DIR) $(ALL_DEFINE) $(VPD_NAME) -l $(OUTPUT).log

#compile VHDL lib
vhdl:
	vhdlan1 -full64 -l vhdlan.log -f vhdl.f
#compile verilog/systenverilog
vlog:
	$(VLOGAN_OPT) -f verilog.f

#elaboration
elab:
	$(VCSOPT) -f verilog.f 

#sim
run:
	$(SIM)
#coverage
cov:
	dve -full64 -covdir *vdb &

#debug
debug:
	dve -full64 -vpd  $(OUTPUT).vpd &

#clean
clean:
	rm -rf ./csrc *.daidir *.log *.vpd *.vdb *.key $(OUTPUT) DVEfiles
#

