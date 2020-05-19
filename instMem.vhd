Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity instMem is
port( address: in std_logic_vector(11 downto 0);
     dataout : out std_logic_vector(31 downto 0));
end instMem;

Architecture instMemModel of instMem is

--ramtype is 4kB of 16 bits
type ram_type is array (0 to 2047) of std_logic_vector(15 downto 0);
signal ram:ram_type;

begin
	dataout <=ram(to_integer(unsigned(address)+1)) &ram(to_integer(unsigned(address)));
	--we need to reset and interupt here 
end instMemModel;