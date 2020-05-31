Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity pcCu is 
port( pcSig: in std_logic_vector(1 downto 0);
      pcOld : out std_logic_vector(31 downto 0);	
      pcPlusTwo : in std_logic_vector(31 downto 0);
      pcPlusOne : in std_logic_vector(31 downto 0);
      regIn: in std_logic_vector(31 downto 0);
      memIn: in std_logic_vector(31 downto 0);
      stall: in std_logic;
      int: in std_logic;
      reset: in std_logic;
      clk: in std_logic);
end pcCu;

Architecture pcCuModel of pcCu is

COMPONENT nAdder is 
generic (n :integer :=32);
PORT
( A: IN std_logic_vector(n-1 DOWNTO 0);
B: IN std_logic_vector(n-1 DOWNTO 0);
Cin: IN std_logic;
F: OUT std_logic_vector(n-1 DOWNTO 0);
Cout: OUT std_logic);
END COMPONENT;

signal addMuxControl,cout,tempCin:std_logic;
signal tempPcPlusOne,tempPcPlusTwo,temp,tempAdd:std_logic_vector(31 downto 0);
begin

addMuxControl<= stall or int or reset;
tempAdd <= "00000000000000000000000000000000" when addMuxControl = '1'
else "00000000000000000000000000000001";

tempCin <= '0' when addMuxControl = '1'
else '1';
	adder : nAdder generic map (n => 32) port map(pcPlusOne,tempAdd,'0',tempPcPlusOne,cout); 
	adder2: nAdder generic map (n => 32) port map(pcPlusOne,tempAdd,tempCin,tempPcPlusTwo,cout); 	
process(clk,pcSig,pcPlusTwo,pcPlusOne,reset)
begin	
	

	--Chooses PCPLUSONE
	if (rising_edge(clk))then 

	
	--Chooses PCOUT
	case (pcSig) is 
	when "00" => pcOld <= tempPcPlusOne;
	when "01" => pcOld <= temppcPlusTwo; 
	when "10" =>  pcOld<= regIn ;
	when "11" =>  pcOld<= memIn ;
	when others => pcOld <= tempPcPlusOne ;
	end case;
end if;
end process;
end pcCuModel;