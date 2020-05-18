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
      reset: in std_logic);
end pcCu;

Architecture pcCuModel of pcCu is

COMPONENT nAdder is 
generic (n :integer :=32);
PORT
(a, b:IN std_logic_vector (n-1 DOWNTO 0) ;
cin: IN std_logic;
s : OUT std_logic_vector (n-1 DOWNTO 0);
cout: OUT std_logic);
END COMPONENT;

signal addMuxControl,cout:std_logic;
signal tempPcPlusOne,temp:std_logic_vector(31 downto 0);
begin
	
	
	addMuxControl<= stall or int or reset;

	--Chooses PCPLUSONE
	adder : nAdder generic map (n => 32) port map(pcPlusOne,"00000000000000000000000000000001",'0',tempPcPlusOne,cout); 
	temp <= tempPcPlusOne when addMuxControl ='1'
        else pcPlusOne;

	--Chooses PCOUT
	pcOld <= temp when pcSig ="00"
	else pcPlusTwo when pcSig="01"
	else regIn when pcSig="10"
	else memIn when pcSig="11";

end pcCuModel;