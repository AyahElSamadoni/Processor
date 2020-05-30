Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LU is
  port(opCode:in std_logic_vector(4 downto 0);
       A,B:in std_logic_vector(31 downto 0);
       CCROLD: in std_logic_vector(2 DOWNTO 0);
       CCR: out std_logic_vector(2 DOWNTO 0);
       F:out std_logic_vector(31 downto 0)
);
end entity LU;

Architecture LUModel of LU is

COMPONENT ALUCCR is 
PORT(
Input : in std_logic_vector(31 DOWNTO 0);
CCROLD: in std_logic_vector(2 DOWNTO 0);
output : out std_logic_vector(2 DOWNTO 0));
end COMPONENT;

SIGNAL tempR: std_logic_vector(31 DOWNTO 0);
SIGNAL tempCCR: std_logic_vector(2 DOWNTO 0);

begin
    with opCode select
     tempR<=A and B when"01100",
        A or B when"01101",
        not A when"00010",
        std_logic_vector(unsigned(not A)+1) when others;
	
	CCRtemp: ALUCCR port map(tempR,CCROLD ,tempCCR);

F <= tempR;
CCR <= tempCCR;

 
 
end Architecture;