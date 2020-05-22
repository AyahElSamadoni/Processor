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
SIGNAL pcSig, regWrite, MemAdd,func,ayah1,ayah2, ayah3: std_logic_vector(1 DOWNTO 0);

SIGNAL pcPlusTwo,pcPlusOne,regIn,instruction,WBData,INDatafromregFile,V1,V2 ,R,DataInfromdataMem,MemData,pcOut: std_logic_vector(31 DOWNTO 0);

SIGNAL stall,regRead,InSig,memRead, memWrite, flush,immSel,aluEn,reem,jmp,dest,inP,outP,JN,JZ,JC ,SC,shift,wbSel,CallorInt,beforeDM: std_logic;

SIGNAL resetPc:  std_logic_vector(31 downto 0);

SIGNAL ReadAd1, ReadAd2, WriteAd1, CCROld, CCR,spSel: std_logic_vector(2 DOWNTO 0);

SIGNAL opCode, opcheck: std_logic_vector(4 DOWNTO 0);

--IFD Buffer
SIGNAL IFIDflushVal, IFIDOUT,IFIDIN:std_logic_vector(63 downto 0);

--DEX Buffer
SIGNAL IDEXflushVal, IDEXOUT,IDEXIN:std_logic_vector(165 downto 0);

--EXMEM Buffer
SIGNAL EXMEMflushVal, EXMEMOUT,EXMEMIN:std_logic_vector(114 downto 0);

--MEMWB Buffer
SIGNAL MEMWBflushVal, MEMWBOUT,MEMWBIN:std_logic_vector(105 downto 0);

--to be deleted later
SIGNAL Imm: std_logic_vector(31 downto 0);

--Registers 
--register pcOut:std_logic_vector(31 downto 0);


begin 


--Fetch Stage:
PcController: pcCu port map (pcSig,pcOut,pcPlusTwo,pcPlusOne,regIn,resetPc,stall,int,reset, clk);

instructionMemory:instMem port map(resetPc, pcOut,instruction);

--Concatenating Buffer Value 
IFIDIN <= pcPlusOne & instruction;
pcPlusOne <= pcOut;
IFIDflushVal <= (others => '0');

--Flush and flushvalue is hard coded to be changed later 
--STALL MOZAYAFA RUBAAA HDU STALL 
IFIDBuff:GenericBuffer generic map (64) port map( clk,'0',reset,IFIDflushVal,IFIDIN,IFIDOUT);

--Decode Stage:

--Instantiating the control unit
opCode <= instruction(15 downto 11);
opcheck <= IFIDOUT(15 downto 11);
func <= IFIDOUT(1 downto 0);
readAd1<=IFIDOUT(10 downto 8);
readAd2<=IFIDOUT(7 downto 5);
ControlUnit : CU port map (clk,int,reset,opCode,func,regWrite,MemAdd,pcSig,spSel,immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC,memRead,memWrite,SC,regRead,shift,stall,wbSel,CallorInt,beforeDM);
WriteAd1 <= MEMWBOUT(5 downto 3);
ayah3 <= MEMWBOUT(104 downto 103);
registerFile: RegFile port map ( clk,reset,regRead,MEMWBOUT(104 downto 103),IFIDOUT(10 downto 8),IFIDOUT(7 downto 5),MEMWBOUT(5 downto 3),WBData,inPort,InSig,V1,V2);

--to be changed later
Imm <= (others => '0');

--IDEXIN <= IFIDOUT(10 downto 8) & IFIDOUT(7 downto 5) & IFIDOUT(4 downto 0) & Imm & IFIDOUT(7 downto 5) & IFIDOUT(13 downto 11) & V2  & V1 & IFIDOUT(63 downto 32) & wbSel & spSel & CallorInt & MemAdd & beforeDM & memWrite & memRead & dest & immSel & SC & JC & JZ & JN & jmp &aluEn;
--IDEXIN <= IFIDOUT(7 downto 5) & IFIDOUT(10 downto 8) & IFIDOUT(15 downto 11) & Imm & IFIDOUT(10 downto 8) & IFIDOUT(4 downto 2) & V2  & V1 & IFIDOUT(63 downto 32) & wbSel & spSel & CallorInt & MemAdd & beforeDM & memWrite & memRead & dest & immSel & SC & JC & JZ & JN & jmp &aluEn;
IDEXIN <= stall & regWrite & aluEn & jmp & JN & JZ & JC & SC & immSel & dest & memRead & memWrite & beforeDM & MemAdd & CallorInt & spSel & wbSel & IFIDOUT(63 downto 32 ) & V1 & V2 & IFIDOUT(4 downto 2) & IFIDOUT(10 downto 8)& Imm & IFIDOUT(15 downto 11) & IFIDOUT( 10 downto 8) & IFIDOUT(7 downto 5);




IDEXflushVal <= (others => '0');

IDEXBuff: GenericBuffer generic map (166) port map (clk,stall, reset, IDEXflushVal, IDEXIN, IDEXOUT);

--Execute Stage:
reem<=IDEXOUT(162);
arithmeticLogicUnit: ALU port map(clk,IDEXOUT (112 downto 81), IDEXOUT(10 downto 6), CCROld, IDEXOUT(162), CCR, R);

--EXMEMIN <= IDEXOUT(45 downto 43) & IDEXOUT(48 downto 46) & IDEXOUT(80 downto 49) & R & IDEXOUT(144 downto 113) & IDEXOUT(145) & IDEXOUT(154 downto 146);
ayah1<=IDEXOUT(164 downto 163);
EXMEMIN <= IDEXOUT(165) & IDEXOUT(164 downto 163) & IDEXOUT(154 downto 146) & IDEXOUT(145) & IDEXOUT(144 downto 113)& R & IDEXOUT(80 downto 49)& IDEXOUT(48 downto 46) & IDEXOUT(45 downto 43);
EXMEMflushVal <= (others => '0');

EXMEMBuff: GenericBuffer generic map (115) port map (clk,IDEXOUT(165), reset, EXMEMflushVal, EXMEMIN, EXMEMOUT);

--Memory Stage:

dataMemPart: dataMemory port map(clk, reset, EXMEMOUT(37 downto 6), EXMEMOUT(37 downto 6) , memRead, memWrite, DataInfromdataMem);

--MEMWBIN <= EXMEMOUT(2 downto 0) & EXMEMOUT(5 downto 3) & EXMEMOUT(37 downto 6) & EXMEMOUT(69 downto 38) & DataInfromdataMem & EXMEMOUT(102);
ayah2<= EXMEMOUT (113 downto 112);
MEMWBIN <= EXMEMOUT(114) & EXMEMOUT (113 downto 112) & EXMEMOUT(102) & DataInfromdataMem & EXMEMOUT(69 downto 38)& EXMEMOUT(37 downto 6) & EXMEMOUT(5 downto 3)&EXMEMOUT(2 downto 0);
MEMWBflushVal <= (others => '0');

MEMWBBuff: GenericBuffer generic map (106) port map (clk, EXMEMOUT(114), reset, MEMWBflushVal, MEMWBIN, MEMWBOUT);

--Write Back Stage:
--WriteAd1<=MEMWBOUT(4 downto 2);
process(clk)
begin
	if clk = '1' then
		if(MEMWBOUT(102) = '1') then
			WBData <= MEMWBOUT(69 downto 38);
		else
			WBData <= MEMWBOUT(101 downto 70);
		end if;
	end if;
end process;

end ProcessorModel;