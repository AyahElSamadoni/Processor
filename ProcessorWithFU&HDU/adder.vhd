LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY adder IS
PORT 
(A,B,Cin : IN  std_logic;
F, Cout : OUT std_logic );
END ENTITY;

ARCHITECTURE adderModel OF adder IS
BEGIN
	F <= A XOR B XOR Cin;
	Cout <= (A AND B) OR (Cin AND (A XOR B));	
END ARCHITECTURE;
