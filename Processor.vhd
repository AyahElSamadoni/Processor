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
      reset: in std_logic);
end component;


component instMem is
port( 
resetPc: out std_logic_vector(31 downto 0);
address: in std_logic_vector(11 downto 0);
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
--WriteAd2 : IN std_logic_vector(2 DOWNTO 0);
--WriteData2: IN std_logic_vector(31 DOWNTO 0);
WBData: IN std_logic_vector(31 DOWNTO 0);
INData: IN std_logic_vector(31 DOWNTO 0);
InSig: IN std_logic;
V1: OUT std_logic_vector(31 DOWNTO 0);
V2: OUT std_logic_vector(31 DOWNTO 0)
);

END component;

component ALU is 
PORT(
clk: in std_logic;
V1 : in  std_logic_vector(31 DOWNTO 0);
OpCode: in std_logic_vector(4 DOWNTO 0);
CCROld: in std_logic_vector(2 DOWNTO 0);
aluEn:in std_logic;
CCR: out std_logic_vector(2 DOWNTO 0);
R: out std_logic_vector(31 DOWNTO 0)
);
End component;

component dataMemory is 
Generic ( n : integer := 16 ; m : integer := 16);
PORT(
clk,reset : in std_logic;
DataIn: in std_logic_vector(31 DOWNTO 0);
MemAdd: in std_logic_vector(31 DOWNTO 0);
MemRead, MemWrite: in std_logic;
MemData: out std_logic_vector(31 DOWNTO 0)
);
End component;

component CU is
PORT(   clk,int,reset: in std_logic;
	opCode: in std_logic_vector(4 downto 0);
	func:in std_logic_vector(1 downto 0);
	regWrite,mAdd, PC:out std_logic_vector(1 downto 0);
	spSel:out std_logic_vector(2 downto 0);
	immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC,memRead,memWrite,SC,regRead,shift,bufferEn,wbSel,CallorInt,beforeDM:out std_logic);
end component;





--signals 
SIGNAL pcSig, regWrite, MemAdd,func: std_logic_vector(1 DOWNTO 0);

SIGNAL pcPlusTwo,pcPlusOne,regIn,instruction,WBData,INDatafromregFile,V1,V2,V1toALU, R,DataInfromdataMem,MemData,pcOut: std_logic_vector(31 DOWNTO 0);

SIGNAL stall,regRead,InSig,memRead, memWrite, flush,immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC ,SC,shift,wbSel,CallorInt,beforeDM: std_logic;

SIGNAL resetPc:  std_logic_vector(31 downto 0);

SIGNAL ReadAd1, ReadAd2, WriteAd1, CCROld, CCR,spSel: std_logic_vector(2 DOWNTO 0);

SIGNAL opCode: std_logic_vector(4 DOWNTO 0);

--IFD Buffer
SIGNAL IFIDflushVal, IFIDOUT,IFIDIN:std_logic_vector(63 downto 0);

--DEX Buffer
SIGNAL IDEXflushVal, IDEXOUT,IDEXIN:std_logic_vector(162 downto 0);

--EXMEM Buffer
SIGNAL EXMEMflushVal, EXMEMOUT,EXMEMIN:std_logic_vector(111 downto 0);

--MEMWB Buffer
SIGNAL MEMWBflushVal, MEMWBOUT,MEMWBIN:std_logic_vector(102 downto 0);

--to be deleted later
SIGNAL Imm: std_logic_vector(31 downto 0);

--Registers 
--register pcOut:std_logic_vector(31 downto 0);


begin 


--Fetch Stage:
PcController: pcCu port map (pcSig,pcOut,pcPlusTwo,pcPlusOne,regIn,resetPc,stall,int,reset);

instructionMemory:instMem port map(resetPc, pcOut(11 downto 0),instruction);

--Concatenating Buffer Value 
IFIDIN <= pcPlusOne & instruction;
IFIDflushVal <= (others => '0');

--Flush and flushvalue is hard coded to be changed later 
IFIDBuff:GenericBuffer generic map (64) port map(  clk,stall,'0',IFIDflushVal,IFIDIN,IFIDOUT);

--Decode Stage:

--Instantiating the control unit
opCode <= instruction(4 downto 0);
ControlUnit : CU port map (clk,int,reset,opCode,func,regWrite,MemAdd,pcSig,spSel,immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC,memRead,memWrite,SC,regRead,shift,stall,wbSel,CallorInt,beforeDM);

registerFile: RegFile port map ( clk,reset,regRead,regWrite,instruction(7 downto 5),instruction(10 downto 8),MEMWBOUT(5 downto 3),WBData,inPort,InSig,V1,V2);

--to be changed later
Imm <= (others => '0');

IDEXIN <= IFIDOUT(10 downto 8) & IFIDOUT(7 downto 5) & IFIDOUT(4 downto 0) & Imm & IFIDOUT(7 downto 5) & IFIDOUT(13 downto 11) & V2  & V1 & IFIDOUT(63 downto 32) & wbSel & spSel & CallorInt & MemAdd & beforeDM & memWrite & memRead & dest & immSel & SC & JC & JZ & JN & jmp &aluEn;
IDEXflushVal <= (others => '0');

IDEXBuff: GenericBuffer generic map (163) port map (clk, stall, '0', IDEXflushVal, IDEXIN, IDEXOUT);

--Execute Stage:

arithmeticLogicUnit: ALU port map(clk,IDEXOUT (111 downto 80), IDEXOUT(10 downto 6), CCROld, IDEXOUT(0), CCR, R);

EXMEMIN <= IDEXOUT(45 downto 43) & IDEXOUT(48 downto 46) & IDEXOUT(80 downto 49) & R & IDEXOUT(144 downto 113) & IDEXOUT(145) & IDEXOUT(154 downto 146);
EXMEMflushVal <= (others => '0');

EXMEMBuff: GenericBuffer generic map (112) port map (clk, stall, '0', EXMEMflushVal, EXMEMIN, EXMEMOUT);

--Memory Stage:

dataMemPart: dataMemory port map(clk, reset, EXMEMOUT(37 downto 6), EXMEMOUT(69 downto 38) , memRead, memWrite, DataInfromdataMem);

MEMWBIN <= EXMEMOUT(2 downto 0) & EXMEMOUT(5 downto 3) & EXMEMOUT(37 downto 6) & EXMEMOUT(69 downto 38) & DataInfromdataMem & EXMEMOUT(102);
MEMWBflushVal <= (others => '0');

MEMWBBuff: GenericBuffer generic map (103) port map (clk, stall, '0', MEMWBflushVal, MEMWBIN, MEMWBOUT);

--Write Back Stage:

WBData <= MEMWBOUT(69 downto 38) when MEMWBOUT(102) = '1'
else  MEMWBOUT(101 downto 70);

end ProcessorModel;