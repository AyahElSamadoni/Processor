LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY sp IS
PORT(
clk, reset, en: IN std_logic;
dataIN: IN std_logic_vector(31 DOWNTO 0);
dataOUT: OUT std_logic_vector(31 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE spModel OF sp IS
BEGIN

process(clk, reset)
begin
	if reset = '1' then
		dataOut <= "00000000000000000000011111111111";
	elsif en = '1' and rising_edge(clk) then
		dataOut <= dataIN;
	end if;
end process;

END ARCHITECTURE;
