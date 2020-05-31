Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SU is
  port(
       V1:in std_logic_vector(31 downto 0);
       ShiftVal: in std_logic_vector(4 downto 0);
       CCROLD: in std_logic_vector(2 downto 0);
       LorR: in std_logic;
       CCR: out std_logic_vector(2 downto 0);
       R:out std_logic_vector(31 downto 0));
end entity;

Architecture SUModel of SU is

COMPONENT ALUCCR is 
PORT(
Input : in std_logic_vector(31 DOWNTO 0);
CCROLD: in std_logic_vector(2 DOWNTO 0);
output : out std_logic_vector(2 DOWNTO 0));
end COMPONENT;

signal tempR:std_logic_vector(31 downto 0);
signal tempCCR:std_logic_vector(2 downto 0);
begin
    tempR<= std_logic_vector(shift_left(unsigned(V1), to_integer(unsigned(ShiftVal)))) when LorR = '0'
              else std_logic_vector(shift_right(unsigned(V1), to_integer(unsigned(ShiftVal))));

    CCRtemp: ALUCCR port map(tempR,CCROLD ,tempCCR);
   
    CCR <= V1(0) & tempCCR(1 downto 0) when LorR = '1'
    else V1(31) & tempCCR(1 downto 0);

    R<=tempR; 
end Architecture;