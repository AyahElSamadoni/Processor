LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

Entity Processor is 
Generic ( n : integer := 16 ; m : integer := 16);
PORT(   clk,reset,int: in std_logic;
	inPort: in std_logic_vector(31 downto 0);
	outPort:out std_logic_vector(31 downto 0));

end Processor;

Architecture ProcessorModel of Processor is 

component GenericBuffer is
generic (n :integer :=32);
PORT(
     clk,stall: in std_logic;
     flush: in std_logic;
     flushVal: in std_logic_vector(n-1 downto 0);
     BuffIn : in std_logic_vector(n-1 downto 0);
     BuffOut : out std_logic_vector(n-1 downto 0));
end component;

component pcCu is 
port( pcSig: in std_logic_vector(1 downto 0);
      pcOld : out std_logic_vector(31 downto 0);	
      pcPlusTwo : in std_logic_vector(31 downto 0);
      pcPlusOne : in std_logic_vector(31 downto 0);
      regIn: in std_logic_vector(31 downto 0);
      memIn: in std_logic_vector(31 downto 0);
      stall: in std_logic;
      int: in std_logic;
      reset: in std_logic;
      clk: in std_logic);
end component;


component instMem is
port( 
resetPc: out std_logic_vector(31 downto 0);
address: in std_logic_vector(31 downto 0);
dataout : out std_logic_vector(31 downto 0));
end component;


component RegFile IS
GENERIC ( n : integer := 32);
PORT( 
Clk,Rst : IN std_logic;
ReadEn : IN std_logic;
WriteEn : IN std_logic_vector(1 DOWNTO 0);
ReadAd1 : IN std_logic_vector(2 DOWNTO 0);
ReadAd2 : IN std_logic_vector(2 DOWNTO 0);
WriteAd1 : IN std_logic_vector(2 DOWNTO 0);
WBData: IN std_logic_vector(31 DOWNTO 0);
WriteAd2 : IN std_logic_vector(2 DOWNTO 0);
WBData2: IN std_logic_vector(31 DOWNTO 0);
INData: IN std_logic_vector(31 DOWNTO 0);
InSig: IN std_logic;
V1: OUT std_logic_vector(31 DOWNTO 0);
V2: OUT std_logic_vector(31 DOWNTO 0);

spSig: in std_logic_vector(2 DOWNTO 0);
opCode : in std_logic_vector(4 DOWNTO 0);
spOut: out std_logic_vector(31 DOWNTO 0);

shiftAdd: in std_logic_vector (2 downto 0);
dest: in std_logic
 
);

END component;

component ALU is 
PORT(
clk,SC,JZ,JC,JN: in std_logic;
V1,V2 : in  std_logic_vector(31 DOWNTO 0);
immVal : in  std_logic_vector(15 DOWNTO 0);
OpCode: in std_logic_vector(4 DOWNTO 0);
CCROld: in std_logic_vector(2 DOWNTO 0);
aluEn,immSel:in std_logic;
CCR: out std_logic_vector(2 DOWNTO 0);
R: out std_logic_vector(31 DOWNTO 0);
EXMEMV1,MEMWBV1,EXMEMV2,MEMWBV2:in std_logic_vector(31 downto 0);
SV1,SV2 :in std_logic_vector(1 downto 0)
);
End COMPONENT;


component dataMemory is 
Generic ( n : integer := 16 ; m : integer := 16);
PORT(
clk,reset : in std_logic;
aluRes: in std_logic_vector(31 DOWNTO 0);
spOld: in std_logic_vector(31 DOWNTO 0);
spNew: in std_logic_vector(31 DOWNTO 0);
MemAdd: in std_logic_vector(1 DOWNTO 0);
pcPlusOne: in std_logic_vector(31 DOWNTO 0);
V2: in std_logic_vector(31 DOWNTO 0);
CallorInt: in std_logic;
MemRead, MemWrite: in std_logic;
MemData: out std_logic_vector(31 DOWNTO 0);
EA : in std_logic_vector(31 downto 0);
push, pop : in std_logic
);
End component;

component CU is
PORT(   clk,int,reset: in std_logic;
	opCode: in std_logic_vector(4 downto 0);
	func:in std_logic_vector(1 downto 0);
	regWrite,mAdd, PC:out std_logic_vector(1 downto 0);
	spSel:out std_logic_vector(2 downto 0);
	--CCR : out std_logic_vector (2 downto 0 );
	--CCROld : in std_logic_vector(2 downto 0 );
immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC,memRead,memWrite,SC,regRead,shift,bufferEn,wbSel,CallorInt,push, pop:out std_logic);
end component;


component CCRLU is 
PORT(
CCRfromALU,CCRfromJMP :in std_logic_vector(2 DOWNTO 0);
clk,reset,jump:in std_logic;
output : out std_logic_vector(2 DOWNTO 0));
end component;


component JumpUnit is 
port (
clk : in std_logic;
jmp,jz,jn,jc : in std_logic;
ccrold : in std_logic_vector(2 downto 0);
ccrOut : out std_logic_vector(2 downto 0);
jump : out std_logic);
END component;

component FU IS
PORT(
clk: in std_logic;
Rsrc1: in std_logic_vector(2 DOWNTO 0);
Rsrc2: in std_logic_vector(2 DOWNTO 0);
WA1MEMWB: in std_logic_vector(2 DOWNTO 0);
WA2MEMWB: in std_logic_vector(2 DOWNTO 0);
WA1EXMEM: in std_logic_vector(2 DOWNTO 0);
WA2EXMEM: in std_logic_vector(2 DOWNTO 0);
RegWriteMEMWB, RegWriteEXMEM: in std_logic_vector(1 DOWNTO 0);
SV1: out std_logic_vector(1 DOWNTO 0);
SV2: out std_logic_vector(1 DOWNTO 0)
);
END Component;

--signals 
SIGNAL pcSig, regWrite, MemAdd,func,ayah1,ayah2, ayah3,funcforImm, memAddCheck, SV1, SV2: std_logic_vector(1 DOWNTO 0);

SIGNAL pcPlusTwo,pcPlusOne,regIn,instruction,WBData,INDatafromregFile,V1,V2 ,R,DataInfromdataMem,MemData,pcOut,spCheck, V2Check, EA, temp: std_logic_vector(31 DOWNTO 0);

SIGNAL WBselfrombuff,stall,regRead,memRead, memWrite, flush,immSel,aluEn,reem,jmp,dest,Jumpsig,inP,outP,JN,JZ,JC ,SC,shift,wbSel,CallorInt,destfromWb,destfromdecode,destfromEx, memWriteCheck, push, pop: std_logic;

SIGNAL resetPc:  std_logic_vector(31 downto 0);

SIGNAL spOut, spIn, spOld, spNew: std_logic_vector(31 downto 0);

SIGNAL ReadAd1, ReadAd2, WriteAd1, WriteAd2 ,CCROld, CCR,CCRfromAlu,CCRfromJmp,spSel, WriteAd1temp: std_logic_vector(2 DOWNTO 0);

SIGNAL opCode, opcheck: std_logic_vector(4 DOWNTO 0);

--IFD Buffer
SIGNAL IFIDflushVal, IFIDOUT,IFIDIN:std_logic_vector(63 downto 0);

--DEX Buffer
SIGNAL IDEXflushVal, IDEXOUT,IDEXIN:std_logic_vector(262 downto 0);

--EXMEM Buffer
SIGNAL EXMEMflushVal, EXMEMOUT,EXMEMIN:std_logic_vector(246 downto 0);

--MEMWB Buffer
SIGNAL MEMWBflushVal, MEMWBOUT,MEMWBIN:std_logic_vector(142 downto 0);

--to be deleted later
SIGNAL Imm, MemImm: std_logic_vector(15 downto 0);

--Registers 


begin 


--Fetch Stage:
regIn <= IDEXOUT(96 downto 65);
PcController: pcCu port map (pcSig,pcOut,pcPlusTwo,pcPlusOne,V1,resetPc,stall,int,reset, clk);

instructionMemory:instMem port map(resetPc, pcOut,instruction);

--Concatenating Buffer Value 
IFIDIN <= pcPlusOne & instruction;
pcPlusOne <= pcOut;
IFIDflushVal <= (others => '0');

--Flush and flushvalue is hard coded to be changed later 

IFIDBuff:GenericBuffer generic map (64) port map( clk,'0',reset,IFIDflushVal,IFIDIN,IFIDOUT);

--Decode Stage:

--Instantiating the control unit
opCode <= instruction(15 downto 11);
opcheck <= IFIDOUT(15 downto 11);
func <= instruction(1 downto 0);
funcforImm <= IFIDOUT(1 downto 0);
readAd1<=IFIDOUT(10 downto 8);
readAd2<=IFIDOUT(7 downto 5);

--ControlUnit : CU port map (clk,int,reset,opCode,func,regWrite,MemAdd,pcSig,spSel,EXMEMOUT(173 downto 142),spOut,CCR,CCROld,immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC,memRead,memWrite,SC,regRead,shift,stall,wbSel,CallorInt,beforeDM);

ControlUnit : CU port map (clk,int,reset,opCode,func,regWrite,MemAdd,pcSig,spSel,immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC,memRead,memWrite,SC,regRead,shift,stall,wbSel,CallorInt,push, pop);
WriteAd1 <= MEMWBOUT(5 downto 3);
WriteAd2 <= MEMWBOUT(2 downto 0);
destfromWb <= MEMWBOUT(139);

--add here case for swap that will set the writeAdd1 and writeAdd2  
--add here case for shift that will set immVal 
registerFile: RegFile port map (clk,reset,regRead,MEMWBOUT(104 downto 103),IFIDOUT(10 downto 8),IFIDOUT(7 downto 5),MEMWBOUT(5 downto 3),WBData,MEMWBOUT(2 downto 0),MEMWBOUT(37 DOWNTO 6),MEMWBOUT(137 downto 106),MEMWBOUT(105),V1,V2,spSel,opCode,spOut,MEMWBOUT(142 downto 140),MEMWBOUT(139));


Imm <= "00000000000" & IFIDOUT (4 downto 2) & funcforImm  when shift ='1'
else IFIDOUT (31 downto 16);

MemImm <= "000000000000" & IFIDOUT(3 downto 0) when (opCode = "10011" or opCode = "10100")
else (others => '0');

WriteAd1temp <= IFIDOUT (7 DOWNTO 5) WHEN dest ='1'
else IFIDOUT(4 DOWNTO 2);

IDEXIN <= pop & push & MemImm & stall & outP & InPort & InP & SC & spOut & spOut & shift & ALUen & dest & ImmSel & JN & JC & JZ & jmp & memWrite & memRead & CallorInt & MemAdd & regWrite & wbSel & IFIDOUT(63 downto 32) & V1 & V2 & WriteAd1temp & IFIDOUT(10 downto 8) & Imm &  IFIDOUT(15 downto 11)  & IFIDOUT( 10 downto 8) & IFIDOUT(7 downto 5);

IDEXflushVal <= (others => '0');

IDEXBuff: GenericBuffer generic map (263) port map (clk,stall, reset, IDEXflushVal, IDEXIN, IDEXOUT);

--Execute Stage:

JU: JumpUnit port map (clk,IDEXOUT(137),IDEXOUT(138),IDEXOUT(140),IDEXOUT(139),CCR,CCRfromJmp,jumpsig);
--JumpUnit: Jump port map(clk,IDEXOUT(137),IDEXOUT(138),IDEXOUT(140),IDEXOUT(139),ccrOld,ccrfromJmp,jumpsig);
CCRSet: CCRLU port map(CCRfromAlu,CCRfromJmp,clk,reset,jumpsig,ccr);

temp <= EXMEMOUT(206 downto 175) when EXMEMOUT(174) ='1'
else EXMEMOUT(69 downto 38);
arithmeticLogicUnit: ALU port map(clk,IDEXOUT(209), IDEXOUT(138),IDEXOUT(139),IDEXOUT(140),IDEXOUT(96 downto 65),IDEXOUT(64 downto 33),IDEXOUT(26 downto 11),IDEXOUT(10 downto 6), CCR, IDEXOUT(143),IDEXOUT(141), CCRfromALU, R,temp,WBdata,EXMEMOUT(69 downto 38 ),WBDATA,SV1,SV2);
CCROld <= CCR;
EA <= IDEXOUT(260 downto 245) & IDEXOUT(26 downto 11);
destfromdecode <=  IDEXOUT(142);
EXMEMIN <= IDEXOUT(262 downto 261) & EA & IDEXOUT(244)& IDEXOUT(2 DOWNTO 0) & IDEXOUT(142) & IDEXOUT (243) & IDEXOUT (242 downto 211) & IDEXOUT (210) & IDEXOUT(208 downto 145) & IDEXOUT(136 downto 129) & IDEXOUT(128 downto 97) & R & IDEXOUT(64 downto 33) & IDEXOUT(32 downto 27);
EXMEMflushVal <= (others => '0');
EXMEMBuff: GenericBuffer generic map (247) port map (clk,IDEXOUT(244), reset, EXMEMflushVal, EXMEMIN, EXMEMOUT);

--Memory Stage:
spCheck <= EXMEMOUT(141 DOWNTO 110);
memWriteCheck <= EXMEMOUT(109);
memAddCheck <= EXMEMOUT(106 downto 105);
spCheck <= EXMEMOUT(141 DOWNTO 110);
V2Check <= EXMEMOUT(69 downto 38);
dataMemPart: dataMemory port map(clk, reset, EXMEMOUT(69 downto 38), EXMEMOUT(141 downto 110),EXMEMOUT(173 downto 142),EXMEMOUT(106 downto 105),EXMEMOUT(101 downto 70),EXMEMOUT(69 downto 38),EXMEMOUT(107),EXMEMOUT(108),EXMEMOUT(109),  DataInfromdataMem, EXMEMOUT(244 downto 213), EXMEMOUT(245), EXMEMOUT(246));

ayah2<= EXMEMOUT (113 downto 112);
destfromEx <= EXMEMOUT(208);
MEMWBIN <= EXMEMOUT(211 downto 209) & EXMEMOUT(208) & EXMEMOUT(207)& EXMEMOUT (206 downto 174) & EXMEMOUT(104 downto 102)& DataInfromdataMem & EXMEMOUT(69 downto 38)& EXMEMOUT(37 downto 6) & EXMEMOUT(5 downto 3)& EXMEMOUT(2 downto 0);

MEMWBflushVal <= (others => '0');

MEMWBBuff: GenericBuffer generic map (143) port map (clk, EXMEMOUT(212), reset, MEMWBflushVal, MEMWBIN, MEMWBOUT);

--Write Back Stage:

outPort <= WBData WHEN MEMWBOUT(138) = '1'
ELSE (others => 'Z');

WBselfrombuff <= MEMWBOUT(102);
WBData <= MEMWBOUT(69 downto 38) WHEN (MEMWBOUT(102) = '1' and MEMWBOUT(105) = '0')
ELSE MEMWBOUT(137 DOWNTO 106) WHEN (MEMWBOUT(102) = '1' and MEMWBOUT(105) = '1') --INPORT
ELSE MEMWBOUT(101 downto 70);
	
ForwordingUnit :FU port map(clk,IDEXOUT(5 downto 3),IDEXOUT(2 DOWNTO 0),MEMWBOUT(5 downto 3),MEMWBOUT(2 downto 0),EXMEMOUT(5 downto 3),EXMEMOUT(2 downto 0),MEMWBOUT(104 downto 103),EXMEMOUT(104 downto 103),SV1,SV2);

end ProcessorModel;