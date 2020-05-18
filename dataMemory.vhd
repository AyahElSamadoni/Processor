LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

Entity dataMemory is 
Generic ( n : integer := 16 ; m : integer := 16);
PORT(
clk,reset : in std_logic;
DataIn: in std_logic_vector(31 DOWNTO 0);
MemAdd: in std_logic_vector(1 DOWNTO 0);
MemRead, MemWrite: in std_logic;
resetPc:out std_logic_vector(11 downto 0);
MemData: out std_logic_vector(31 DOWNTO 0)
);
End dataMemory;

Architecture dataMemoryModel of dataMemory is
type ram_type is array (0 to 2**m-1) of std_logic_vector(n-1 downto 0);
SIGNAL Ram: ram_type;
begin 
process(clk, reset) is
	begin
		if reset='1' then 	
			resetPc <= Ram(1) & Ram(0);
		else	
			--To Avoid Write conflict we added write within Process with synthesis list (clk)
			if rising_edge(clk) then 
				if MemWrite = '1' then 
					Ram(to_integer(unsigned(MemAdd))) <= DataIn;
				end if;
			end if;
		end if;
end process;
MemData <= Ram(to_integer(unsigned(MemAdd)));
end dataMemoryModel;