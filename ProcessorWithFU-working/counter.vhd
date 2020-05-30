LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity counter is
port(
clk,rst: in std_logic;
output: out std_logic_vector(5 downto 0));
end entity;

architecture my_counter of counter is 
signal temp : integer;
signal temp2,temp3 : std_logic_vector (5 DOWNTO 0);
begin 
process(clk)
begin
if rst='1' then temp<=10;
elsif rising_edge (clk) then 
		temp<= temp-1;
		temp2<= std_logic_vector(to_unsigned(temp,6));
end if;
end process;
output<=temp2;

end architecture; 
