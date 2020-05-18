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
port( address: in std_logic_vector(11 downto 0);
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
MemAdd: in std_logic_vector(1 DOWNTO 0);
MemRead, MemWrite: in std_logic;
resetPc:out std_logic_vector(11 downto 0);
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
SIGNAL pcSig, WriteEn,MemAdd,func: std_logic_vector(1 DOWNTO 0);

SIGNAL pcPlusTwo,pcPlusOne,regIn,memIn,instruction,WBData,INDatafromregFile,V1,V2,V1toALU, R,DataInfromdataMem,MemData,pcOut: std_logic_vector(31 DOWNTO 0);

SIGNAL stall,regRead,InSig,memRead, memWrite, flush,immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC ,SC,shift,wbSel,CallorInt,beforeDM: std_logic;

SIGNAL resetPc:  std_logic_vector(11 downto 0);

SIGNAL ReadAd1, ReadAd2, WriteAd1, CCROld, CCR,spSel: std_logic_vector(2 DOWNTO 0);

SIGNAL opCode: std_logic_vector(4 DOWNTO 0);

--IFD Buffer
SIGNAL IFIDflushVal, IFIDOUT,IFIDIN:std_logic_vector(63 downto 0);

--DEX Buffer
SIGNAL IDEXflushVal, IDEXOUT,IDEXIN:std_logic_vector(165 downto 0);

--EXMEM Buffer
SIGNAL EXMEMflushVal, EXMEMOUT,EXMEMIN:std_logic_vector(111 downto 0);

--MEMWB Buffer
SIGNAL MEMWBflushVal, MEMWBOUT,MEMWBIN:std_logic_vector(102 downto 0);

--Registers 
--register pcOut:std_logic_vector(31 downto 0);


begin 


--Fetch Stage:
PcController: pcCu port map (pcSig,pcOut,pcPlusTwo,pcPlusOne,regIn,memIn,stall,int,reset);

instructionMemory:instMem port map(pcOut(11 downto 0),instruction);

--Concatenating Buffer Value 
IFIDIN <= pcPlusOne & instruction;
IFIDflushVal <= "0000000000000000000000000000000000000000000000000000000000000000";

--Flush and flushvalue is hard coded to be changed later 
IFIDBuff:GenericBuffer generic map (64) port map(  clk,stall,'0',IFIDflushVal,IFIDIN,IFIDOUT);

--Decode Stage:

--Instantiating the control unit
opCode <= instruction(4 downto 0);
ControlUnit : CU port map (clk,int,reset,opCode,func,WriteEn,MemAdd,pcSig,spSel,immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC,memRead,memWrite,SC,regRead,shift,stall,wbSel,CallorInt,beforeDM);

registerFile: RegFile port map ( clk,reset,regRead,regWrite,instruction(7 downto 5),instruction(10 downto 8),MEMWBOUT,WBData,INData,InSig,V1,V2);







end ProcessorModel;