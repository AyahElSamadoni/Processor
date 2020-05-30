LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY FU IS
PORT(
clk: in std_logic;
Rsrc1: in std_logic_vector(2 DOWNTO 0);
Rsrc2: in std_logic_vector(2 DOWNTO 0);
WA1MEMWB: in std_logic_vector(2 DOWNTO 0);
WA2MEMWB: in std_logic_vector(2 DOWNTO 0);
WA1EXMEM: in std_logic_vector(2 DOWNTO 0);
WA2EXMEM: in std_logic_vector(2 DOWNTO 0);
RegWriteMEMWB, RegWriteEXMEM: in std_logic_vector(1 DOWNTO 0);
SV1: out std_logic_vector(1 DOWNTO 0);
SV2: out std_logic_vector(1 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE FUModel OF FU IS
BEGIN

SV1 <= "01" when ((Rsrc1 = WA1EXMEM and RegWriteEXMEM = "10") or (Rsrc1 = WA2EXMEM and RegWriteEXMEM = "01"))
else "10"   when ((Rsrc1 = WA1MEMWB and RegWriteMEMWB = "10") or  (Rsrc1 = WA2MEMWB and RegWriteMEMWB = "01"))
else "00";

SV2 <= "01" when ((Rsrc2 = WA1EXMEM and RegWriteEXMEM = "10") or (Rsrc2 = WA2EXMEM and RegWriteEXMEM = "01"))
else "10"  when  ((Rsrc2 = WA1MEMWB and RegWriteMEMWB = "10") or  (Rsrc2 = WA2MEMWB and RegWriteMEMWB = "01"))
else "00";
--process(clk)
--begin

	--if (falling_edge(clk)) then
		--RSRC #1
		--ALU to ALU
		--if(Rsrc1 = WA1EXMEM and RegWriteEXMEM = "10") then
	--		SV1 <= "01";
	--	elsif (Rsrc1 = WA2EXMEM and RegWriteEXMEM = "01") then
	--		SV1 <= "01";
		--MEM to ALU
	--	elsif (Rsrc1 = WA1MEMWB and RegWriteMEMWB = "10") then
	--		SV1 <= "10";
	--	elsif (Rsrc1 = WA2MEMWB and RegWriteMEMWB = "01") then
	--		SV1 <= "10";
	--	else 
	--		SV1 <= "00";
	--	end if;
	--	--RSRC #2
	--	--ALU to ALU
	--	if (Rsrc2 = WA2EXMEM and RegWriteEXMEM = "01") then
	---		SV2 <= "01";
	--	elsif (Rsrc2 = WA2EXMEM and RegWriteEXMEM = "01") then
	--		SV2 <= "01";
	--	--MEM to ALU
	--	elsif (Rsrc2 = WA1MEMWB and RegWriteMEMWB = "10") then
	--		SV2 <= "10";
	--	elsif (Rsrc2 = WA2MEMWB and RegWriteMEMWB = "01") then
	--		SV2 <= "10";
	--	else 
	--		SV2 <= "00";
	--	end if;
	--end if;
--end process;
END ARCHITECTURE;
