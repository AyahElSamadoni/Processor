LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity CCRLU is 
PORT(
Input : in std_logic_vector(31 DOWNTO 0);
output : out std_logic_vector(2 DOWNTO 0));
end CCRLU;

Architecture CCRLUModel of CCRLU is
signal zero : integer;
begin
--Carry Negative Zero
zero <= 0;
output(0) <= '1' WHEN input = "00000000000000000000000000000000"
ELSE '0';
output(1) <= '1' WHEN signed(input) < 0
ELSE '0';

end CCRLUModel;