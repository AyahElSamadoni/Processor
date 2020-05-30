LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY RegFile IS
GENERIC ( n : integer := 32);
PORT( 
Clk,Rst : IN std_logic;
ReadEn : IN std_logic;
WriteEn : IN std_logic_vector(1 DOWNTO 0);
ReadAd1 : IN std_logic_vector(2 DOWNTO 0);
ReadAd2 : IN std_logic_vector(2 DOWNTO 0);
WriteAd1 : IN std_logic_vector(2 DOWNTO 0);
WBData: IN std_logic_vector(31 DOWNTO 0);
WriteAd2 : IN std_logic_vector(2 DOWNTO 0);
WBData2: IN std_logic_vector(31 DOWNTO 0);
INData: IN std_logic_vector(31 DOWNTO 0);
InSig: IN std_logic;
V1: OUT std_logic_vector(31 DOWNTO 0);
V2: OUT std_logic_vector(31 DOWNTO 0);

spSig: in std_logic_vector(2 DOWNTO 0);
opCode : in std_logic_vector(4 DOWNTO 0);
spOut: out std_logic_vector(31 DOWNTO 0);

shiftAdd: in std_logic_vector (2 downto 0);
dest: in std_logic
 
);

END ENTITY;


ARCHITECTURE reg_architecture OF RegFile IS

COMPONENT spCU IS
PORT(
clk, reset: in std_logic;
opCode: in std_logic_vector(4 DOWNTO 0);
spSig: in std_logic_vector(2 DOWNTO 0);
spOut: out std_logic_vector(31 DOWNTO 0) 
);
END COMPONENT;


TYPE N_reg IS ARRAY(0 TO 7) of std_logic_vector(31 DOWNTO 0);
SIGNAL reg : N_reg := (others => (others => '0'));
SIGNAL tempWBData , tempWBdata1, tempWBData2 : std_logic_vector(31 DOWNTO 0) ;
signal tempAdd : std_logic_vector(2 DOWNTO 0) ;
BEGIN

SPUNIT: spCU PORT MAP (clk,Rst,opCode,spSig,spOut);

tempWbData <= INData when Insig = '1'
else WBData;

tempWbData1 <= WBData ;
tempWbData2 <= WBData2 ; 
	PROCESS(clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			IF WriteEn = "10" THEN
				if(dest = '0') then
					reg(to_integer(unsigned(WriteAd1))) <= tempWBData; 
				else
					reg(to_integer(unsigned(shiftAdd))) <= tempWBData; 
				end if;
			elsif WriteEn = "11" then --SWAP 
				reg(to_integer(unsigned(WriteAd1))) <= tempWBData1;
				reg(to_integer(unsigned(WriteAd2))) <= tempWBData2;
			END IF;
		END IF;


END PROCESS;
V1 <= reg(to_integer(unsigned((ReadAd1))));
V2 <= reg(to_integer(unsigned((ReadAd2))));
END ARCHITECTURE ;

