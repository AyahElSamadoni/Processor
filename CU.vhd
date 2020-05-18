LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

entity CU is
PORT(   clk,int,reset: in std_logic;
	opCode: in std_logic_vector(4 downto 0);
	func:in std_logic_vector(1 downto 0);
	regWrite,mAdd, PC:out std_logic_vector(1 downto 0);
	spSel:out std_logic_vector(2 downto 0);
	immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC,memRead,memWrite,SC,regRead,shift,bufferEn,wbSel,CallorInt,beforeDM:out std_logic);
end CU;

Architecture CUModel of CU is 
begin
	process(clk,opCode,reset,int,func)
	begin
   	if (reset = '1') then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="01";
			PC <="11";
			spSel <="000";
			regWrite <="00";
			regRead <='0';
			memWrite <='0';
			memRead <='1';
			SC<='0';
			JC<='0';
			JN<='0';
			JZ<='0';
			jmp<='0';
			inP<='0';
			outP<='0';
			shift <='0';
			bufferEn<='1';
			wbSel <='0';
			immSel <='0';
			CallorInt<='0';
			beforeDM <='0';

------------------NOP-------------------------------------------------------------------------------------------------------------------------
		
	else 
		if (clk = '1') then
			if (opCode = "00000") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="00";
			spSel <="100";
			regWrite <="00";
			regRead <='0';
			memWrite <='0';
			memRead <='0';
			SC<='0';
			JC<='0';
			JN<='0';
			JZ<='0';
			jmp<='0';
			inP<='0';
			outP<='0';
			shift <='0';
			bufferEn<='0';
			wbSel <='0';
			immSel <='0';
			CallorInt<='0';
			beforeDM <='0';
	-------------------------------------------------------------------------------------------------
	--SETC	
			elsif (opCode = "00001" and func= "10") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="00";
			spSel <="100";
			regWrite <="00";
			regRead <='0';
			memWrite <='0';
			memRead <='0';
			SC<='1';
			JC<='0';
			JN<='0';
			JZ<='0';
			jmp<='0';
			inP<='0';
			outP<='0';
			shift <='0';
			bufferEn<='1';
			wbSel <='0';
			immSel <='0';
			CallorInt<='0';
			beforeDM <='0';
		-------------------------------------------------------------------------------------------------
	--CLEAR C
	
			elsif (opCode = "00001" and func= "00") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="00";
			spSel <="100";
			regWrite <="00";
			regRead <='0';
			memWrite <='0';
			memRead <='0';
			SC<='0';
			JC<='0';
			JN<='0';
			JZ<='0';
			jmp<='0';
			inP<='0';
			outP<='0';
			shift <='0';
			bufferEn<='1';
			wbSel <='0';
			immSel <='0';
			CallorInt<='0';
			beforeDM <='0';
			
	-------------------------------------------------------------------------------------------------
	--NOT OR INC OR DEC

			elsif (opCode = "00010" or opCode ="00011" or opCode="00100") then
			aluEn <= '1' ;
			dest <='0';
			mAdd <="00";
			PC <="00";
			spSel <="100";
			regWrite <="10";
			regRead <='1';
			memWrite <='0';
			memRead <='0';
			SC<='0';
			JC<='0';
			JN<='0';
			JZ<='0';
			jmp<='0';
			inP<='0';
			outP<='0';
			shift <='0';
			bufferEn<='1';
			wbSel <='1';
			immSel <='0';
			CallorInt<='0';
			beforeDM <='0';
	-------------------------------------------------------------------------------------------------
	--OUT

			elsif (opCode = "00101") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="00";
			spSel <="100";
			regWrite <="00";
			regRead <='1';
			memWrite <='0';
			memRead <='0';
			SC<='0';
			JC<='0';
			JN<='0';
			JZ<='0';
			jmp<='0';
			inP<='0';
			outP<='1';
			shift <='0';
			bufferEn<='1';
			wbSel <='1';
			immSel <='0';
			CallorInt<='0';
			beforeDM <='0';

	-------------------------------------------------------------------------------------------------
	--IN

			elsif (opCode = "00110") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="00";
			spSel <="100";
			regWrite <="10";
			regRead <='0';
			memWrite <='0';
			memRead <='0';
			SC<='0';
			JC<='0';
			JN<='0';
			JZ<='0';
			jmp<='0';
			inP<='1';
			outP<='0';
			shift <='0';
			bufferEn<='1';
			wbSel <='1';
			immSel <='0';
			CallorInt<='0';
			beforeDM <='0';

		end if;
	end if;
end if;


	end process;
end CUModel;
