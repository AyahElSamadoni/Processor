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
--WriteAd2 : IN std_logic_vector(2 DOWNTO 0);
--WriteData2: IN std_logic_vector(31 DOWNTO 0);
WBData: IN std_logic_vector(31 DOWNTO 0);
INData: IN std_logic_vector(31 DOWNTO 0);
InSig: IN std_logic;
V1: OUT std_logic_vector(31 DOWNTO 0);
V2: OUT std_logic_vector(31 DOWNTO 0)
);

END ENTITY;

--ARCHITECTURE ModelReg OF RegFile IS

--COMPONENT NDFF IS
--GENERIC ( n : integer := 32);
--PORT( 
--Clk,Rst : IN std_logic;
--d : IN std_logic_vector(n-1 DOWNTO 0);
--q : OUT std_logic_vector(n-1 DOWNTO 0);
--en : IN std_logic);
--END COMPONENT;

--COMPONENT Decoder IS
--PORT(
-- A : IN std_logic_vector(2 downto 0);
-- B : OUT std_logic_vector(7 downto 0);
-- en: IN std_logic);
--END COMPONENT;

--SIGNAL RDec1, RDec2, WDec, WDec2 : std_logic_vector(7 DOWNTO 0);
--SIGNAL Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7 : std_logic_vector(n-1 DOWNTO 0);
--SIGNAL WriteData1: std_logic_vector(31 DOWNTO 0);

--BEGIN

--Write Decoder
--WD1: Decoder PORT MAP(WriteAd1, WDec, WriteEn(1));
-----WD2: Decoder PORT MAP(WriteAd2, WDec2, WriteEn(0));

-----WriteData 1 Assignment
-----WriteData1 <= WBData; --WHEN InSig = '0'
--ELSE INData;

--8 n-bit D - Flipflops
--D0: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q0, WDec(0));
--D1: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q1, WDec(1));
--D2: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q2, WDec(2));
--D3: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q3, WDec(3));
--D4: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q4, WDec(4));
--D5: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q5, WDec(5));
--D6: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q6, WDec(6));
--D7: NDFF GENERIC MAP(n) PORT MAP(Clk, Rst, WriteData1, Q7, WDec(7));

----Read Decoder for V1 and V2
--RD1: Decoder PORT MAP(ReadAd1, RDec1, ReadEn);
--RD2: Decoder PORT MAP(ReadAd2, RDec2, ReadEn);

--process (clk,  WriteAd1)
--begin
--	if falling_edge(clk) then
--		--TRI-State Buffer for V1
--		case (RDec1) is 
--		when "00000001" => V1 <= Q0;
--		when "00000010" => V1 <= Q1;
--		when "00000100" => V1 <= Q2;
--		when "00001000" => V1 <= Q3;
--		when "00010000" => V1 <= Q4;
--		when "00100000" => V1 <= Q5;
--		when "01000000" => V1 <= Q6;
--		when "10000000" => V1 <= Q7;
--		when others => V1 <= (OTHERS => '0');
--		end case;

		--TRI-State Buffer for V2
--		case (RDec2) is 
--		when "00000001" => V2 <= Q0;
--		when "00000010" => V2 <= Q1;
--		when "00000100" => V2 <= Q2;
--		when "00001000" => V2 <= Q3;
--		when "00010000" => V2 <= Q4;
--		when "00100000" => V2 <= Q5;
--		when "01000000" => V2 <= Q6;
--		when "10000000" => V2 <= Q7;
--		when others => V2 <= (OTHERS => '0');
--		end case;
--	else
--		if rising_edge(clk) then
--			WriteData1 <= WBData;
--		end if;
--end if;
--end process;
--END ARCHITECTURE;

ARCHITECTURE reg_architecture OF RegFile IS
TYPE N_reg IS ARRAY(0 TO 7) of std_logic_vector(31 DOWNTO 0);
SIGNAL reg : N_reg := (others => (others => '0'));
BEGIN
PROCESS(clk) IS
BEGIN
IF rising_edge(clk) THEN
IF WriteEn(1) = '1' THEN
reg(to_integer(unsigned(WriteAd1))) <= WBData;    
END IF;
END IF;



END PROCESS;
V1 <= reg(to_integer(unsigned((ReadAd1))));
V2 <= reg(to_integer(unsigned((ReadAd2))));
END ARCHITECTURE ;

