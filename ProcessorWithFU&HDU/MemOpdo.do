vsim -gui work.processor
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/reset \
sim:/processor/stall \
sim:/processor/int \
sim:/processor/inP \
sim:/processor/inPort \
sim:/processor/outP \
sim:/processor/outPort \
sim:/processor/pcSig \
sim:/processor/pcOut \
sim:/processor/opCode \
sim:/processor/IFIDOUT \
sim:/processor/regRead \
sim:/processor/ReadAd1 \
sim:/processor/ReadAd2 \
sim:/processor/regWrite \
sim:/processor/WriteAd1 \
sim:/processor/WriteAd2 \
sim:/processor/WBData \
sim:/processor/V1 \
sim:/processor/V2 \
sim:/processor/Imm \
sim:/processor/ControlUnit/mAdd \
sim:/processor/ControlUnit/spSel \
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
sim:/processor/registerFile/SPUNIT/spSig \
sim:/processor/registerFile/SPUNIT/spOut \
sim:/processor/registerFile/SPUNIT/spRegOut \
sim:/processor/registerFile/SPUNIT/spALUOut \
sim:/processor/IDEXOUT \
sim:/processor/R \
sim:/processor/CCR \
sim:/processor/EXMEMOUT \
sim:/processor/memWriteCheck \
sim:/processor/memAddCheck \
sim:/processor/spCheck \
sim:/processor/V2Check \
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
sim:/processor/dataMemPart/address \
sim:/processor/dataMemPart/dataIn \
sim:/processor/MEMWBOUT 
force -freeze sim:/processor/clk 1 0, 0 {150 ps} -r 300
force -freeze sim:/processor/reset 1 0
force -freeze sim:/processor/int 0 0
run
mem load -i MemOpMemory.mem /Processor/instructionMemory/ram
force -freeze sim:/processor/reset 1 0
run
force -freeze sim:/processor/reset 0 0
run
run
run
run
run
force -freeze sim:/processor/inPort 32'h0CDAFE19 0
run
run
run
force -freeze sim:/processor/inPort 32'h0000FFFF 0
run
run
run
force -freeze sim:/processor/inPort 32'h0000F320 0
run
run
run
