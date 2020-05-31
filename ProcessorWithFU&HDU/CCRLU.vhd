LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity CCRLU is 
PORT(
CCRfromALU,CCRfromJMP :in std_logic_vector(2 DOWNTO 0);
clk,reset,jump:in std_logic;
output : out std_logic_vector(2 DOWNTO 0));
end CCRLU;
Architecture CCRLUModel of CCRLU is
begin
process(Jump,reset,clk)
begin
if(reset ='1') then
	output <= "000";
else
	if(falling_edge(clk)) then
	if(Jump ='1') then 

		output <= CCRfromJMP;
	else 
		output <= CCRfromALU; 
	end if;
end if;
end if;
end process;

end Architecture;