LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

Entity JumpUnit is 
port (
clk : in std_logic;
jmp,jz,jn,jc : in std_logic;
ccrold : in std_logic_vector(2 downto 0);
ccrOut : out std_logic_vector(2 downto 0);
jump : out std_logic
);

END ENTITY;

ARCHITECTURE  JumpUnitModel OF JumpUnit IS 
BEGIN
PROCESS (clk)
begin

if (rising_edge(clk)) then 

	if (jc = '1' and ccrOld(2) = '1') then 
		jump <= '1';
		ccrOut <= '0' & ccrOld (1 downto 0);
 
	elsif (jn = '1' and ccrOld(1) = '1') then
		jump <= '1';
		ccrOut <= ccrOld(2) & '0' & ccrOld(0);

	elsif (jz = '1' and ccrOld(0) = '1')then
		jump <= '1';
	 	ccrOut <=  ccrOld(2 downto 1) & '1';

	elsif (jmp = '1')then
		jump <= '1';
	 	ccrOut <=  ccrOld;
	else
		jump <= '0';
		ccrOut <=  ccrOld;
	end if;
end if ;


end PROCESS;


end ARCHITECTURE ;