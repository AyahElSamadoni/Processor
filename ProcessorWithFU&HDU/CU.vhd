LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

entity CU is
PORT(   clk,int,reset: in std_logic;
	opCode: in std_logic_vector(4 downto 0);
	func:in std_logic_vector(1 downto 0);
	regWrite,mAdd, PC:out std_logic_vector(1 downto 0);
	spSel:out std_logic_vector(2 downto 0);
	--CCR : out std_logic_vector (2 downto 0 );
	--CCROld : in std_logic_vector(2 downto 0 );
	immSel,aluEn,jmp,dest,inP,outP,JN,JZ,JC,memRead,memWrite,SC,regRead,shift,bufferEn,wbSel,CallorInt,push, pop:out std_logic);
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
			push <='0';
			pop <= '0';
			--spOut <= "00000000000000000000011111111111";
			--CCR <= "000";
------------------NOP-------------------------------------------------------------------------------------------------------------------------
		
	else 
		--spOut <= spIn; 
		--CCR <= CCROld;
		if (falling_edge(clk)) then
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
			push <='0';
			pop <= '0';
	-------------------------------------------------------------------------------------------------
	--SETC	
	--CHECK BUFFEREn
			elsif (opCode = "00001" and func = "10") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="00";
			spSel <="100";
			regWrite <="00";
			regRead <='0';
			memWrite <='0';
			memRead <='0';
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
			push <='0';
			pop <= '0';
			Sc<='1';
		
		-------------------------------------------------------------------------------------------------
	--CLEAR C
	
			elsif (opCode = "00001" and func = "00") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="00";
			spSel <="100";
			regWrite <="00";
			regRead <='0';
			memWrite <='0';
			memRead <='0';
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
			push <='0';
			pop <= '0';
			Sc<='0';
					
				
			
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
			bufferEn<='0';
			wbSel <='1';
			immSel <='0';
			CallorInt<='0';
			push <='0';
			pop <= '0';
	-------------------------------------------------------------------------------------------------
	--bufferenable is zero for mostafa el3'alta eli 2al 3aleha fy eldisscussion
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
			bufferEn<='0';
			wbSel <='1';
			immSel <='0';
			CallorInt<='0';
			push <='0';
			pop <= '0';

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
			bufferEn<='0';
			wbSel <='1';
			immSel <='0';
			CallorInt<='0';
			push <='0';
			pop <= '0';
-------------------------------------------------------------------------------------------------
	--SWAP

			elsif (opCode = "01000") then
			aluEn <= '1' ;
			dest <='0';
			mAdd <="00";
			PC <="00";
			spSel <="100";
			regWrite <="11";
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
			bufferEn<='0';
			wbSel <='1';
			immSel <='0';
			CallorInt<='0';
			push <='0';
			pop <= '0';
-------------------------------------------------------------------------------------------------
	--ADD SUB AND OR

			elsif (opCode = "01001" or opCode = "01011" or opCode = "01100" or opCode ="01101") then
			aluEn <= '1' ;
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
			inP<='0';
			outP<='0';
			shift <='0';
			bufferEn<='0';
			wbSel <='1';
			immSel <='0';
			CallorInt<='0';
			push <='0';
			pop <= '0';
-------------------------------------------------------------------------------------------------
	--IADD

			elsif (opCode = "01010") then
			aluEn <= '1' ;
			dest <='0';
			mAdd <="00";
			PC <="01";
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
			bufferEn<='0';
			wbSel <='1';
			immSel <='1';
			CallorInt<='0';
			push <='0';
			pop <= '0';

-------------------------------------------------------------------------------------------------
	--SHL SHR

			elsif (opCode = "01111" or opCode = "01110") then
			aluEn <= '1' ;
			dest <='1';
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
			shift <='1';
			bufferEn<='0';
			wbSel <='1';
			immSel <='1';
			CallorInt<='0';
			push <='0';
			pop <= '0';

--START OF MEMORY OPERATIONS
-------------------------------------------------------------------------------------------------
	--PUSH

			elsif (opCode = "10000") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="01";
			PC <="00";
			spSel <="000";
			regWrite <="00";
			regRead <='1';
			memWrite <='1';
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
			push <='1';
			pop <= '0';
-------------------------------------------------------------------------------------------------
	--POP

			elsif (opCode = "10001") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="10";
			PC <="00";
			spSel <="001";
			regWrite <="10";
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
			bufferEn<='0';
			wbSel <='0';
			immSel <='0';
			CallorInt<='0';
			push <='0';
			pop <= '1';
-------------------------------------------------------------------------------------------------
	--LDM
		elsif (opCode = "10010") then
			aluEn <= '1' ;
			dest <='0';
			mAdd <="00";
			PC <="01";
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
			inP<='0';
			outP<='0';
			shift <='0';
			bufferEn<='0';
			wbSel <='1';
			immSel <='1';
			CallorInt<='0';
			push <='0';
			pop <= '0';
-------------------------------------------------------------------------------------------------
	--LDD
			elsif(opCode = "10011") then
			aluEn <= '1' ;
			dest <='1';
			mAdd <="11";
			PC <="01";
			spSel <="100";
			regWrite <="10";
			regRead <='1';
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
			bufferEn<='0';
			wbSel <='0';
			immSel <='1';
			CallorInt<='0';
			push <='0';
			pop <= '0';
-------------------------------------------------------------------------------------------------
	--STD
			elsif (opCode = "10100") then
			aluEn <= '1' ;
			dest <='0';
			mAdd <="11";
			PC <="01";
			spSel <="100";
			regWrite <="00";
			regRead <='1';
			memWrite <='1';
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
			immSel <='1';
			CallorInt<='0';
			push <='0';
			pop <= '0';
-------------------------------------------------------------------------------------------------
	--END OF MEMORY OPERATIONS

-------------------------------------------- JUMPS ----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-----jump zero

		elsif (opCode = "10101") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="10";
			spSel <="100";
			regWrite <="00";
			regRead <='1';
			memWrite <='0';
			memRead <='0';
			SC<='0';
			JC<='0';
			JN<='0';
			JZ<='1';
			jmp<='0';
			inP<='0';
			outP<='0';
			shift <='0';
			bufferEn<='0';
			wbSel <='0';
			immSel <='0';
			CallorInt<='0';
			push <='0';
			pop <= '0';

---------------------------------------------------------------------------------
--- Jump negative

		elsif (opCode = "10110") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="10";
			spSel <="100";
			regWrite <="00";
			regRead <='1';
			memWrite <='0';
			memRead <='0';
			SC<='0';
			JC<='0';
			JN<='1';
			JZ<='0';
			jmp<='0';
			inP<='0';
			outP<='0';
			shift <='0';
			bufferEn<='0';
			wbSel <='0';
			immSel <='0';
			CallorInt<='0';
			push <='0';
			pop <= '0';

-------------------------------------------------------------------------------------------
----- jump carry


		elsif (opCode = "10111") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="10";
			spSel <="100";
			regWrite <="00";
			regRead <='1';
			memWrite <='0';
			memRead <='0';
			SC<='0';
			JC<='1';
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
			push <='0';
			pop <= '0';


-----------------------------------------------------------------------------------------
---- jmp 
		elsif (opCode = "11000") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="10";
			spSel <="100";
			regWrite <="00";
			regRead <='1';
			memWrite <='0';
			memRead <='0';
			SC<='0';
			JC<='0';
			JN<='0';
			JZ<='0';
			jmp<='1';
			inP<='0';
			outP<='0';
			shift <='0';
			bufferEn<='0';
			wbSel <='0';
			immSel <='0';
			CallorInt<='0';
			push <='0';
			pop <= '0';



-------------------------------------------------------------------------------------------
----- CALL


		elsif (opCode = "11001") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="00";
			PC <="10";
			spSel <="010";
			regWrite <="00";
			regRead <='1';
			memWrite <='1';
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
			CallorInt<='1';
			push <='0';
			pop <= '0';

-------------------------------------------------------------------------------------------
----- RET


		elsif (opCode = "11010") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="11";
			PC <="11";
			spSel <="011";
			regWrite <="00";
			regRead <='0';
			memWrite <='0';
			memRead <='1';
			SC<='0';
			JC<='1';
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
			push <='0';
			pop <= '0';

-------------------------------------------------------------------------------------------
----- RTI


		elsif (opCode = "11011") then
			aluEn <= '0' ;
			dest <='0';
			mAdd <="11";
			PC <="11";
			spSel <="011";
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
			bufferEn<='0';
			wbSel <='0';
			immSel <='0';
			CallorInt<='0';
			push <='0';
			pop <= '0';

----------------------------------END JUMPS-----------------------------------------------




		end if;
	end if;
end if;


	end process;
end CUModel;
