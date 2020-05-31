vsim -gui work.processor
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/opCode \
sim:/processor/WBData \
sim:/processor/jumpsig \
sim:/processor/regIn \
sim:/processor/V2 \
sim:/processor/V2Check \
sim:/processor/Imm \
sim:/processor/ForwordingUnit/* \
sim:/processor/R \
sim:/processor/FUNC \
sim:/processor/SC \
sim:/processor/CCR \
sim:/processor/CCRFromAlu \
sim:/processor/CCROLD \
sim:/processor/outPort \
sim:/processor/pcOut \
sim:/processor/ReadAd1 \
sim:/processor/ReadAd2 \
sim:/processor/WriteAd1 \
sim:/processor/WriteAd2 \
sim:/processor/aluEn \
sim:/processor/opcheck \
sim:/processor/instruction \
sim:/processor/reset \
sim:/processor/pcSig \
sim:/processor/regWrite \
sim:/processor/func \
sim:/processor/V1 \
sim:/processor/stall \
sim:/processor/regRead \
sim:/processor/dest \
sim:/processor/IFIDOUT \
sim:/processor/IFIDIN \
sim:/processor/IDEXOUT \
sim:/processor/IDEXIN \
sim:/processor/EXMEMOUT \
sim:/processor/EXMEMIN \
sim:/processor/MEMWBOUT \
sim:/processor/MEMWBIN \
sim:/processor/INDatafromregFile \
sim:/processor/inPort \
sim:/processor/registerFile/SPUNIT/Cout
force -freeze sim:/processor/clk 1 0, 0 {150 ps} -r 300
force -freeze sim:/processor/reset 1 0
force -freeze sim:/processor/int 0 0
mem load -i  HazardMem.mem /Processor/instructionMemory/ram
mem load -i RegFile.mem /Processor/registerFile/reg
run
force -freeze sim:/processor/reset 1 0
run
force -freeze sim:/processor/reset 0 0
run
force -freeze sim:/processor/reset 0 0
run
