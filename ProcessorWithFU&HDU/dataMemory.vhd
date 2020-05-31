LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

Entity dataMemory is 
Generic ( n : integer := 16 ; m : integer := 16);
PORT(
clk,reset : in std_logic;
aluRes: in std_logic_vector(31 DOWNTO 0);
spOld: in std_logic_vector(31 DOWNTO 0);
spNew: in std_logic_vector(31 DOWNTO 0);
MemAdd: in std_logic_vector(1 DOWNTO 0);
pcPlusOne: in std_logic_vector(31 DOWNTO 0);
V2: in std_logic_vector(31 DOWNTO 0);
CallorInt: in std_logic;
MemRead, MemWrite: in std_logic;
MemData: out std_logic_vector(31 DOWNTO 0);
EA : in std_logic_vector(31 downto 0);
push, pop: in std_logic
);
End dataMemory;

Architecture dataMemoryModel of dataMemory is

COMPONENT ram IS
generic ( n : integer := 16 ; m : integer := 11);
PORT (clk : IN std_logic;
re, we, push, pop : IN std_logic;
address : IN std_logic_vector(10 DOWNTO 0);
datain : IN std_logic_vector(31 DOWNTO 0);
dataout : OUT std_logic_vector(31 DOWNTO 0) );
END COMPONENT;

SIGNAL address: std_logic_vector(10 downto 0);
SIGNAL dataIn: std_logic_vector(31 downto 0);

begin 

address <= aluRes(10 DOWNTO 0) when MemAdd = "00"
else spOld(10 DOWNTO 0) when MemAdd = "01"
else spNew(10 DOWNTO 0) when MemAdd = "10"
else EA(10 DOWNTO 0) when MemAdd = "11";

dataIn <= V2 when CallorInt = '0'
else pcPlusOne when CallorInt = '1';

dataMem: ram generic map(16, 11) port map(clk, MemRead, MemWrite, push, pop, address, dataIn, MemData);

end dataMemoryModel;