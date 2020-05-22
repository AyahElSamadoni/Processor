LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity AdderModule is 
PORT(
OpCode : in std_logic_vector(4 DOWNTO 0);
V1 : in std_logic_vector(31 DOWNTO 0);
CCR : out std_logic_vector(2 DOWNTO 0);
R: out std_logic_vector(31 DOWNTO 0));
End AdderModule;

Architecture AdderModuleModel of AdderModule is
COMPONENT CCRLU is 
PORT(
Input : in std_logic_vector(31 DOWNTO 0);
output : out std_logic_vector(2 DOWNTO 0));
end COMPONENT;

COMPONENT nAdder IS 
GENERIC (n: integer :=32);
PORT( A: IN std_logic_vector(n-1 DOWNTO 0);
B: IN std_logic_vector(n-1 DOWNTO 0);
Cin: IN std_logic;
F: OUT std_logic_vector(n-1 DOWNTO 0);
Cout: OUT std_logic);
END COMPONENT;

SIGNAL tempNOT, tempINC, tempDEC, tempR: std_logic_vector(31 DOWNTO 0);
SIGNAL tempCCR: std_logic_vector(2 DOWNTO 0);
SIGNAL Cout: std_logic;

begin 


tempNOT <= not V1;
INC: nAdder generic map (32) port map(V1, "00000000000000000000000000000001", '0', tempINC, Cout);
DEC: nAdder generic map (32) port map(V1, "11111111111111111111111111111111", '0', tempDEC, Cout);

tempR <= tempNOT WHEN OpCode = "00010"
ELSE tempINC WHEN OpCode = "00011"
ELSE tempDEC WHEN OpCode = "00100"
ELSE (others => '0');
CCRtemp: CCRLU port map(tempR, tempCCR);

CCR<= tempCCR;
R<= tempR;

End AdderModuleModel;
