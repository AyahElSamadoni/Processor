
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY RegFile IS
GENERIC ( n : integer := 32);
PORT( 
Clk,Rst : IN std_logic;
ReadEn : IN std_logic;
WriteEn : IN std_logic_vector(1 DOWNTO 0);
ReadAd1 : IN std_logic_vector(2 DOWNTO 0);
ReadAd2 : IN std_logic_vector(2 DOWNTO 0);
WriteAd1 : IN std_logic_vector(2 DOWNTO 0);
--WriteAd2 : IN std_logic_vector(2 DOWNTO 0);
--WriteData2: IN std_logic_vector(31 DOWNTO 0);
WBData: IN std_logic_vector(31 DOWNTO 0);
INData: IN std_logic_vector(31 DOWNTO 0);
InSig: IN std_logic;
V1: OUT std_logic_vector(31 DOWNTO 0);
V2: OUT std_logic_vector(31 DOWNTO 0)
);

END ENTITY;

ARCHITECTURE ModelReg OF RegFile IS

COMPONENT NDFF IS
GENERIC ( n : integer := 32);
PORT( 
Clk,Rst : IN std_logic;
d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0);
en : IN std_logic);
END COMPONENT;

COMPONENT Decoder IS
PORT(
 A : IN std_logic_vector(2 downto 0);
 B : OUT std_logic_vector(7 downto 0);
 en: IN std_logic);
END COMPONENT;

SIGNAL RDec1, RDec2, WDec, WDec2 : std_logic_vector(7 DOWNTO 0);
SIGNAL Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL WriteData1: std_logic_vector(31 DOWNTO 0);

BEGIN

--Write Decoder
WD1: Decoder PORT MAP(WriteAd1, WDec, WriteEn(1));
--WD2: Decoder PORT MAP(WriteAd2, WDec2, WriteEn(0));

--WriteData 1 Assignment
WriteData1 <= WBData WHEN InSig = '0'
ELSE INData;

--8 n-bit D - Flipflops
D0: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q0, WDec(0));
D1: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q1, WDec(1));
D2: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q2, WDec(2));
D3: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q3, WDec(3));
D4: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q4, WDec(4));
D5: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q5, WDec(5));
D6: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q6, WDec(6));
D7: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q7, WDec(7));

--Read Decoder for V1 and V2
RD1: Decoder PORT MAP(ReadAd1, RDec1, ReadEn);
RD2: Decoder PORT MAP(ReadAd2, RDec2, ReadEn);

--TRI-State Buffer for V1
V1 <= Q0 WHEN RDec1 = "00000001"
ELSE Q1 WHEN RDec1 = "00000010"
ELSE Q2 WHEN RDec1 = "00000100"
ELSE Q3 WHEN RDec1 = "00001000"
ELSE Q4 WHEN RDec1 = "00010000"
ELSE Q5 WHEN RDec1 = "00100000"
ELSE Q6 WHEN RDec1 = "01000000"
ELSE Q7 WHEN RDec1 = "10000000";

--TRI-State Buffer for V2
V2 <= Q0 WHEN RDec2 = "00000001"
ELSE Q1 WHEN RDec2 = "00000010"
ELSE Q2 WHEN RDec2 = "00000100"
ELSE Q3 WHEN RDec2 = "00001000"
ELSE Q4 WHEN RDec2 = "00010000"
ELSE Q5 WHEN RDec2 = "00100000"
ELSE Q6 WHEN RDec2 = "01000000"
ELSE Q7 WHEN RDec2 = "10000000";

END ARCHITECTURE;
