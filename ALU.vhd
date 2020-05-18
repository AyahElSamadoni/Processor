LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity ALU is 
PORT(
clk: in std_logic;
V1 : in  std_logic_vector(31 DOWNTO 0);
OpCode: in std_logic_vector(4 DOWNTO 0);
CCROld: in std_logic_vector(2 DOWNTO 0);
aluEn:in std_logic;
CCR: out std_logic_vector(2 DOWNTO 0);
R: out std_logic_vector(31 DOWNTO 0)
);
End ALU;

Architecture ALUModel of ALU is

COMPONENT AdderModule is 
PORT(
OpCode : in std_logic_vector(4 DOWNTO 0);
V1 : in std_logic_vector(31 DOWNTO 0);
CCR : out std_logic_vector(2 DOWNTO 0);
R: out std_logic_vector(31 DOWNTO 0));
End COMPONENT;

SIGNAL CCRAdder: std_logic_vector(2 DOWNTO 0);
SIGNAL tempR, tempAdder: std_logic_vector(31 DOWNTO 0);

begin

Adder: AdderModule port map(OpCode, V1, CCRAdder, tempAdder);

process(clk)
begin
	if (clk = '1') then
		--Remove first check
		if((OpCode = "00010" or OpCode = "00011" or OpCode = "00100"  or OpCode = "01001" or OpCode = "01010" or OpCode = "01011" or OpCode = "10011" or OpCode = "10100")and aluEn='1') then 
			R <= tempAdder; CCR <= CCRAdder;
		else
			R <= (others => '1'); CCR <= (others => '1');
		end if;
	end if;
end process;
end ALUModel;