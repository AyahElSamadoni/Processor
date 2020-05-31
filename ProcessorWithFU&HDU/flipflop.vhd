Library ieee;
use ieee.std_logic_1164.all;

entity myn_dff is
generic (n:integer :=32);
port(clk,rst:in std_logic;
d: in std_logic_vector (n-1 DOWNTO 0);
enable: in std_logic;
q: out std_logic_vector (n-1 DOWNTO 0));
end entity;

Architecture a_myn_dff of myn_dff is
begin 
process(clk,rst)
begin 
if rst='1' then q<=(others=>'0');
elsif rising_edge (clk) then 
	if enable='1' then
		q<= d;
	end if;
end if;
end process;
end architecture;