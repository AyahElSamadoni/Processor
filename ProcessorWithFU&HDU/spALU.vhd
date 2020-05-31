LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY spALU IS
PORT(
spSig: IN std_logic_vector(2 DOWNTO 0);
spIn: IN std_logic_vector(31 DOWNTO 0);
spOut: OUT std_logic_vector(31 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE spALUModel OF spALU IS
BEGIN

spOut <= std_logic_vector(unsigned(spIn)-2) WHEN spSig = "000"
ELSE std_logic_vector(unsigned(spIn)+2) WHEN spSig = "001"
ELSE std_logic_vector(unsigned(spIn)-4) WHEN spSig = "010"
ELSE std_logic_vector(unsigned(spIn)+4) WHEN spSig = "011"
ELSE spIn;

END ARCHITECTURE;
