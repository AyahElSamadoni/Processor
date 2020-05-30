LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--or OpCode = "00011" or OpCode = "00100"  or OpCode = "01001" or OpCode = "01010" or OpCode = "01011" or OpCode = "10011" or OpCode = "10100")and aluEn='1'
Entity ALU is 
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
End ALU;

Architecture ALUModel of ALU is

COMPONENT AdderModule is 
PORT(
OpCode : in std_logic_vector(4 DOWNTO 0);
V1,V2 : in std_logic_vector(31 DOWNTO 0);
CCROLD: in std_logic_vector(2 DOWNTO 0);
CCR : out std_logic_vector(2 DOWNTO 0);
R: out std_logic_vector(31 DOWNTO 0));
End COMPONENT;

component LU is
  port(opCode:in std_logic_vector(4 downto 0);
       A,B:in std_logic_vector(31 downto 0);
       CCROLD: in std_logic_vector(2 DOWNTO 0);
       CCR: out std_logic_vector(2 DOWNTO 0);
       F:out std_logic_vector(31 downto 0)
);
end component;


component SU is
  port(
       V1:in std_logic_vector(31 downto 0);
       ShiftVal: in std_logic_vector(4 downto 0);
       CCROLD: in std_logic_vector(2 downto 0);
       LorR: in std_logic;
       CCR: out std_logic_vector(2 downto 0);
       R:out std_logic_vector(31 downto 0));
end component;

component memUnit IS
PORT(
opCode: in std_logic_vector(4 downto 0);
V1: in std_logic_vector(31 DOWNTO 0);
Imm: in std_logic_vector(31 DOWNTO 0);
R: out std_logic_vector(31 DOWNTO 0)
);
END component;

component JU is 
PORT(
clk : in std_logic;
output : out std_logic_vector(2 DOWNTO 0);
jc,jn,jz : in std_logic;
ccrOld : in std_logic_vector (2 downto 0 )
);
end component;

SIGNAL CCRAdder,CCRLU,CCRSU,CCRJU: std_logic_vector(2 DOWNTO 0);
SIGNAL tempAdder,tempLU,tempSU,tempV2,tempMU, V1toALU, V2toALU: std_logic_vector(31 DOWNTO 0);

begin
--for FU
V1toALU <= MEMWBV1  when SV1 = "10"
else EXMEMV1 when SV1 = "01"
else V1; --V1

V2toALU <= MEMWBV2 when SV2 = "10"
else EXMEMV2 when SV2 = "01"
else V2; --V2

tempv2 <= std_logic_vector(resize(signed(immVal), tempV2'length)) when immSel = '1'
else V2toALU;

Adder: AdderModule port map(OpCode, V1toALU,tempV2,CCROLD ,CCRAdder, tempAdder);
LogicUnit:LU port map(opCode,V1toALU,V2toALU,CCROLD,CCRLU,tempLU);
ShiftUnit: SU port map(V1toALU,immVal(4 downto 0),CCROLD,opCode(0),CCRSU,tempSU);
MemoryUnit:memUnit port map(Opcode,V1toALU,V2toALU,tempMU);


process(clk)
begin
	if (rising_edge(clk)) then
			--INC DEC ADD IADD SUB 
			if(OpCode = "00011" or OpCode = "00100"  or OpCode = "01001" or OpCode = "01010" or OpCode = "01011") then 
				R <= tempAdder; 
				CCR <= CCRAdder;
			--And OR NOT	
			elsif (opCode ="01100" or opCode ="01101" or opCode ="00010") then 

				R <= tempLU;
				CCR <= CCRLU;
			--SHL SHR	
			elsif (opCode = "01111" or opCode = "01110") then 

				R <= tempSU;
				CCR <= CCRSU;
			--SETC CLRC	
			elsif (opCode = "00001") then
				R <= V1;
				if (sc = '1') then
					CCR <= '1' & CCROLD(1 downto 0);
				else 
					CCR <= '0' & CCROLD(1 downto 0);
				end if;
			--LDD STD
			elsif (opCode = "10011" or opCode = "10100") then 

				R <= tempMU;
				CCR <= CCROLD; 
			--push std
			elsif(opCode="10000" or opCode ="10100") then 

				R <=V2toALU;
				CCR <= CCROLD;
			--LDM
			elsif(opCode = "10010") then
				R<= tempV2;
				CCR <= CCROLD;
			
			else
				R <= V1toALU; 
				CCR <= CCROLD;
			end if;
	end if;
end process;
end ALUModel;