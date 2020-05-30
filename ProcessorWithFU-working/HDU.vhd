Library ieee;
Use ieee.std_logic_1164.all;

Entity HDU is
port( 	clk,memRead : in std_logic;
	writeAdd1,source1,source2 : in std_logic_vector(2 downto 0);
	opCode : in std_logic_vector(4 downto 0);
	fetchBufferEnable : out std_logic);
end HDU;


Architecture HDUModel of HDU is
begin
Process (clk)
begin
	if(rising_edge(clk)) then --check this with the team
		if memRead = '1' then
			--Instructions that have 2 sources [SWAP Add IADD SUB AND OR] 
			if(opCode(4 downto 3) = "01") then 
				--not Shift and one of the sources is load dest
				if((not (opCode="01110") or not(opCode ="01111")) and (source1 = WriteAdd1 or source2 = WriteAdd1 ) ) then	
					fetchBufferEnable <= '1';
				else 
					fetchBufferEnable <= '0';			 
				end if;
			--Instructions that do not have a Source [NOP SETC CLRC IN POP LDM LDD RET RTI]	
			elsif (opCode = "00000" or opCode = "00001" or opCode = "00110" or opCode = "10001" or opCode = "10010" or opCode = "10011" or opCode = "11010" or opCode = "11011") then 
				fetchBufferEnable <= '0';
			--Instructions that have only one source  [INC DEC OUT NOT SHL SHR PUSH STD JZ JN JC JMP CALL] 
			else
				if(source1 = WriteAdd1) then 
					fetchBufferEnable <= '1';
				else 
					fetchBufferEnable <= '0';
				end if;		
		   	end if;
		else
			fetchBufferEnable <= '0';
		end if;
	end if;
end process;
end HDUModel;