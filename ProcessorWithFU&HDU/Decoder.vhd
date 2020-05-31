LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Decoder IS
PORT(
 A : IN std_logic_vector(2 DOWNTO 0);
 B : OUT std_logic_vector(7 DOWNTO 0);
 en: IN std_logic);
END ENTITY;
 
ARCHITECTURE ModelDec OF Decoder IS

SIGNAL OUTPUT: std_logic_vector(7 DOWNTO 0);

BEGIN

OUTPUT(0) <= not A(0) and not A(1) and not A(2);
OUTPUT(1) <= A(0) and not A(1) and not A(2);
OUTPUT(2) <= not A(0) and A(1) and not A(2);
OUTPUT(3) <= A(0) and A(1) and not A(2);
OUTPUT(4) <= not A(0) and not A(1) and A(2);
OUTPUT(5) <= A(0) and not A(1) and A(2);
OUTPUT(6) <= not A(0) and A(1) and A(2);
OUTPUT(7) <= A(0) and A(1) and A(2);


B <= OUTPUT WHEN en = '1'
ELSE (others => '0');

END ARCHITECTURE;
