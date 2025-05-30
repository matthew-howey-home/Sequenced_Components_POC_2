Proof of concept for Sequenced Components on FPGA (Second attempt)

Prerequisites:

Quartus Prime 22.1 SC Lite Edition. FPGA FAMILY "MAX 10" DEVICE 10M04SAE144C8G

Clone project from Git Repository Open Quartus Prime Select File / Open, go into project diretory and open: SequencedComponentsPOC.qpf

After opening the Project, you need to generate the Internal Oscillator files:

Go to Tools

Select Platform Designer

Select Internal_Oscillator.qsys

Select Generate HDL...

Select VHDL as the language type

Select Generate

Select Close

Select Finish

then, select Processing and Start Compilation to verify this has worked.
