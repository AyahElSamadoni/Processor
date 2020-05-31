LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY memUnit IS
PORT(
opCode: in std_logic_vector(4 downto 0);
V1: in std_logic_vector(31 DOWNTO 0);
Imm: in std_logic_vector(31 DOWNTO 0);
R: out std_logic_vector(31 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE memUnitModel OF memUnit IS

COMPONENT nAdder IS 
GENERIC (n: integer :=32);
PORT( A: IN std_logic_vector(n-1 DOWNTO 0);
B: IN std_logic_vector(n-1 DOWNTO 0);
Cin: IN std_logic;
F: OUT std_logic_vector(n-1 DOWNTO 0);
Cout: OUT std_logic);
END COMPONENT;

SIGNAL Cout: std_logic;
SIGNAL tempV1: std_logic_vector(31 downto 0);
BEGIN
tempV1 <= V1 when opCode = "10011" or opCode = "10100"
ELSE (others => '0');
EAadder: nAdder generic map (32) port map(tempV1,Imm, '0', R, Cout);
END ARCHITECTURE;
