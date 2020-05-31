vsim -gui work.processor
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/reset \
sim:/processor/stall \
sim:/processor/inP \
sim:/processor/inPort \
sim:/processor/outP \ 
sim:/processor/outPort \
sim:/processor/pcSig \
sim:/processor/pcOut \
sim:/processor/IFIDOUT \
sim:/processor/regRead \ 
sim:/processor/ReadAd1 \
sim:/processor/ReadAd2 \
sim:/processor/regWrite \ --
sim:/processor/WriteAd1 \
sim:/processor/WriteAd2 \
sim:/processor/WBData \
sim:/processor/WBData2 \ -------
sim:/processor/V1 \
sim:/processor/V2 \
sim:/processor/ControlUnit/mAdd \
sim:/processor/ControlUnit/spSel \
sim:/processor/ControlUnit/spIn \
sim:/processor/ControlUnit/spOut \
sim:/processor/ControlUnit/immSel \
sim:/processor/ControlUnit/jmp \
sim:/processor/ControlUnit/dest \
sim:/processor/ControlUnit/JN \
sim:/processor/ControlUnit/JZ \
sim:/processor/ControlUnit/JC \
sim:/processor/ControlUnit/memRead \
sim:/processor/ControlUnit/memWrite \
sim:/processor/ControlUnit/SC \
sim:/processor/ControlUnit/shift \
sim:/processor/ControlUnit/wbSel \
sim:/processor/ControlUnit/CallorInt \
sim:/processor/IDEXOUT \
sim:/processor/R \
sim:/processor/CCR \
sim:/processor/EXMEMOUT \
sim:/processor/dataMemPart/aluRes \
sim:/processor/dataMemPart/spOld \
sim:/processor/dataMemPart/spNew \
sim:/processor/dataMemPart/MemAdd \
sim:/processor/dataMemPart/pcPlusOne \
sim:/processor/dataMemPart/V2 \
sim:/processor/dataMemPart/CallorInt \
sim:/processor/dataMemPart/MemRead \
sim:/processor/dataMemPart/MemWrite \
sim:/processor/dataMemPart/MemData \
sim:/processor/MEMWBOUT 
force -freeze sim:/processor/clk 1 0, 0 {150 ps} -r 300
force -freeze sim:/processor/reset 1 0
force -freeze sim:/processor/int 0 0
mem load -i OneOperandMemory.mem /Processor/instructionMemory/ram
run
force -freeze sim:/processor/reset 1 0
run
force -freeze sim:/processor/reset 0 0
run
