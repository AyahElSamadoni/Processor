LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ram IS
generic ( n : integer := 16 ; m : integer := 11);
PORT (clk : IN std_logic;
re, we, push, pop : IN std_logic;
address : IN std_logic_vector(10 DOWNTO 0);
datain : IN std_logic_vector(31 DOWNTO 0);
dataout : OUT std_logic_vector(31 DOWNTO 0) );
END ENTITY;

ARCHITECTURE sync_ram_a OF ram IS
type ram_type is array (0 to 2**m-1) of std_logic_vector(n-1 downto 0);
SIGNAL Ram: ram_type:= (others => (others => '0'));
Signal datain1, datain2 : std_logic_vector(15 DOWNTO 0);

BEGIN
datain1 <= datain(31 downto 16);
datain2 <= datain(15 downto 0);
PROCESS(clk) IS
BEGIN  
	IF rising_edge(clk) THEN
		IF we = '1' THEN
			if push = '0' then
				Ram(to_integer(unsigned(address))+1) <= datain1;
				Ram(to_integer(unsigned(address))) <= datain2;
			else
				Ram(to_integer(unsigned(address))+2) <= datain1;
				Ram(to_integer(unsigned(address))+1) <= datain2;
			end if;
		END IF;
		if re = '1' then 
			if pop = '1' then
				dataout <= Ram(to_integer(unsigned(address))) & Ram(to_integer(unsigned(address))-1);
			else
				dataout <= Ram(to_integer(unsigned(address))+1) & Ram(to_integer(unsigned(address)));
			end if;
		end if;
	END IF;
END PROCESS;
--dataout <= Ram(to_integer(unsigned(address))) & Ram(to_integer(unsigned(address))-1) when re = '1'
--else (others => '0');
END sync_ram_a; 

