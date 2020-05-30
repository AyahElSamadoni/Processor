LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity AdderModule is 
PORT(
OpCode : in std_logic_vector(4 DOWNTO 0);
V1,V2 : in std_logic_vector(31 DOWNTO 0);
CCROLD: in std_logic_vector(2 DOWNTO 0);
CCR : out std_logic_vector(2 DOWNTO 0);
R: out std_logic_vector(31 DOWNTO 0));
End AdderModule;

Architecture AdderModuleModel of AdderModule is
COMPONENT ALUCCR is 
PORT(
Input : in std_logic_vector(31 DOWNTO 0);
CCROLD: in std_logic_vector(2 DOWNTO 0);
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

SIGNAL tempR,tempV2: std_logic_vector(31 DOWNTO 0);
SIGNAL tempCCR: std_logic_vector(2 DOWNTO 0);
SIGNAL Cout,Cin: std_logic;

begin 

     tempV2<= "00000000000000000000000000000001" when opCode="00011" --INC
	else  "11111111111111111111111111111111" when opCode="00100" --DEC
        else not V2 when opCode="01011"--SUB
	else V2;--ADD

	Cin <= '1' when opCode = "01011" --SUB
	else '0';

	ADD: nAdder generic map (32) port map(V1,tempV2,Cin,tempR,cout);
	CCRtemp: ALUCCR port map(tempR,CCROLD ,tempCCR);

	CCR<= tempCCR;
	R<= tempR;

End AdderModuleModel;
