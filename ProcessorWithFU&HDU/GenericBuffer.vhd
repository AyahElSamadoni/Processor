LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity GenericBuffer is
generic (n :integer :=32);
PORT(
     clk,stall: in std_logic;
     flush: in std_logic;
     flushVal: in std_logic_vector(n-1 downto 0);
     BuffIn : in std_logic_vector(n-1 downto 0);
     BuffOut : out std_logic_vector(n-1 downto 0));
end GenericBuffer;

Architecture GenericBufferModel of GenericBuffer is
begin
	Process(clk,flush,BuffIn)
	begin
		--Stall helps us stall the pipe whe it is equal to 1
		--Stall acts as a enabler to the buffer
		if(falling_edge(clk) and stall = '0') then
			BuffOut <= BuffIn;
		end if;
		--flush for HDU
		if(flush = '1') then
			BuffOut <= flushVal;
		end if;
	end process;
end GenericBufferModel;
