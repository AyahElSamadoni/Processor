vsim -gui work.processor
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/R \
sim:/processor/pcOut \
sim:/processor/reem \
sim:/processor/ayah1 \
sim:/processor/ayah2 \
sim:/processor/ayah3 \
sim:/processor/WBData \
sim:/processor/ReadAd1 \
sim:/processor/ReadAd2 \
sim:/processor/WriteAd1 \
sim:/processor/aluEn \
sim:/processor/opCode \
sim:/processor/opcheck \
sim:/processor/instruction \
sim:/processor/reset \
sim:/processor/pcSig \
sim:/processor/regWrite \
sim:/processor/MemAdd \
sim:/processor/func \
sim:/processor/V1 \
sim:/processor/V2 \
sim:/processor/stall \
sim:/processor/regRead \
sim:/processor/dest \
sim:/processor/wbSel \
sim:/processor/CCR \
sim:/processor/IFIDOUT \
sim:/processor/IFIDIN \
sim:/processor/IDEXOUT \
sim:/processor/IDEXIN \
sim:/processor/EXMEMOUT \
sim:/processor/EXMEMIN \
sim:/processor/MEMWBOUT \
sim:/processor/MEMWBIN \
sim:/processor/Imm \
sim:/processor/INDatafromregFile \
sim:/processor/inPort \
sim:/processor/outPort
force -freeze sim:/processor/clk 1 0, 0 {150 ps} -r 300
force -freeze sim:/processor/reset 1 0
force -freeze sim:/processor/int 0 0
mem load -i OneOperandMemory.mem /Processor/instructionMemory/ram
run
force -freeze sim:/processor/reset 1 0
run
force -freeze sim:/processor/reset 0 0
run