LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY nAdder IS 
GENERIC (n: integer :=16);
PORT( A: IN std_logic_vector(n-1 DOWNTO 0);
B: IN std_logic_vector(n-1 DOWNTO 0);
Cin: IN std_logic;
F: OUT std_logic_vector(n-1 DOWNTO 0);
Cout: OUT std_logic);
END ENTITY;

ARCHITECTURE Model OF nAdder IS 

COMPONENT Adder IS
PORT 
(A,B,Cin : IN  std_logic;
F, Cout : OUT std_logic );
END COMPONENT;

SIGNAL temp: std_logic_vector(n-1 DOWNTO 0);

BEGIN

f0: Adder PORT MAP(A(0), B(0), Cin, F(0), temp(0));

Loop1: FOR i IN 1 TO n-1 GENERATE
fx: Adder PORT MAP(A(i), B(i), temp(i-1), F(i), temp(i));
END GENERATE;
Cout <= temp(n-1);
END ARCHITECTURE;
