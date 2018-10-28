all: comp sim

create_lib:
	vlib work

comp:
	vlog -l comp.log claw_machine_2nd.sv claw_machine_tb.sv -sv

sim:
	vsim -l sim.log -c claw_machine_tb -do "log -r *; run -all"

clean:
	rm -f mti_lib transcript modelsim.ini *.log *.wlf 
