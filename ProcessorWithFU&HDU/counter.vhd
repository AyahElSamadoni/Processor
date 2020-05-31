LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity counter is
port(
clk,rst: in std_logic;
output: out std_logic_vector (1 downto 0));
end entity;

architecture my_counter of counter is 
signal temp : integer;
signal temp2 : std_logic_vector(1 downto 0);
begin 
process(clk)
begin
if rst='1' then 
temp<=2;
output<="10";
elsif falling_edge (clk) then 
		temp<= temp-1;
		output<= std_logic_vector(to_unsigned(temp,2));
end if;
end process;


end architecture; 
