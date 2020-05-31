LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY spCU IS
PORT(
clk, reset: in std_logic;
opCode: in std_logic_vector(4 DOWNTO 0);
spSig: in std_logic_vector(2 DOWNTO 0);
spOut: out std_logic_vector(31 DOWNTO 0) 
);
END ENTITY;

ARCHITECTURE spCUModel OF spCU IS

COMPONENT sp IS
PORT(
clk, reset, en: IN std_logic;
dataIN: IN std_logic_vector(31 DOWNTO 0);
dataOUT: OUT std_logic_vector(31 DOWNTO 0)
);
END COMPONENT;

COMPONENT spALU IS
PORT(
spSig: IN std_logic_vector(2 DOWNTO 0);
spIn: IN std_logic_vector(31 DOWNTO 0);
spOut: OUT std_logic_vector(31 DOWNTO 0)
);
END COMPONENT;

SIGNAL spRegOut, spALUOut: std_logic_vector (31 DOWNTO 0);
SIGNAL en: std_logic;

BEGIN 

en <= '1' WHEN opCode = "10000" or opCode = "10001" or reset = '1'
ELSE '0';

spRegister: sp port map(clk, reset, en, spALUOut, spRegOut);
spArithmeticUnit: spALU port map(spSig, spRegOut, spALUOut);

spOut <= spRegOut;

END ARCHITECTURE;
