LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

Entity ALUCCR is 
PORT(
Input : in std_logic_vector(31 DOWNTO 0);
CCROLD: in std_logic_vector(2 DOWNTO 0);
output : out std_logic_vector(2 DOWNTO 0));
end ALUCCR;

Architecture ALUCCRModel of ALUCCR is
signal zero : integer;
begin
--Carry Negative Zero

output(2) <= CCROLD(2);
output(0) <= '1' WHEN input = "00000000000000000000000000000000"
ELSE '0';
output(1) <= '1' WHEN signed(input) < 0
ELSE '0';

end ALUCCRModel;