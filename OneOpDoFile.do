vsim -gui work.processor
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/reset \
sim:/processor/int \
sim:/processor/inPort \
sim:/processor/outPort \
sim:/processor/pcSig \
sim:/processor/regWrite \
sim:/processor/MemAdd \
sim:/processor/func \
sim:/processor/pcPlusTwo \
sim:/processor/pcPlusOne \
sim:/processor/regIn \
sim:/processor/memIn \
sim:/processor/instruction \
sim:/processor/WBData \
sim:/processor/INDatafromregFile \
sim:/processor/V1 \
sim:/processor/V2 \
sim:/processor/V1toALU \
sim:/processor/R \
sim:/processor/DataInfromdataMem \
sim:/processor/MemData \
sim:/processor/pcOut \
sim:/processor/stall \
sim:/processor/regRead \
sim:/processor/InSig \
sim:/processor/memRead \
sim:/processor/memWrite \
sim:/processor/flush \
sim:/processor/immSel \
sim:/processor/aluEn \
sim:/processor/jmp \
sim:/processor/dest \
sim:/processor/inP \
sim:/processor/outP \
sim:/processor/JN \
sim:/processor/JZ \
sim:/processor/JC \
sim:/processor/SC \
sim:/processor/shift \
sim:/processor/wbSel \
sim:/processor/CallorInt \
sim:/processor/beforeDM \
sim:/processor/resetPc \
sim:/processor/ReadAd1 \
sim:/processor/ReadAd2 \
sim:/processor/WriteAd1 \
sim:/processor/CCROld \
sim:/processor/CCR \
sim:/processor/spSel \
sim:/processor/opCode \
sim:/processor/IFIDflushVal \
sim:/processor/IFIDOUT \
sim:/processor/IFIDIN \
sim:/processor/IDEXflushVal \
sim:/processor/IDEXOUT \
sim:/processor/IDEXIN \
sim:/processor/EXMEMflushVal \
sim:/processor/EXMEMOUT \
sim:/processor/EXMEMIN \
sim:/processor/MEMWBflushVal \
sim:/processor/MEMWBOUT \
sim:/processor/MEMWBIN \
sim:/processor/Imm
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/reset 1 0
force -freeze sim:/processor/int 0 0
mem load -i OneOperandMemory.mem /Processor/instructionMemory/ram