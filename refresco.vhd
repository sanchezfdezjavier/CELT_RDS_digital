----------------------------------------------------------------------------------
--
-- refresco
--
-- Circuito que refresca los displays periódicamente
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity refresco is
    Port ( CLK_1ms : in  STD_LOGIC;                  -- reloj de refresco
           S : out  STD_LOGIC_VECTOR (1 downto 0);   -- Control para el mux
           AN : out  STD_LOGIC_VECTOR (3 downto 0)); -- Control displays individuales
end refresco;

architecture a_refresco of refresco is
	
	signal SS: STD_LOGIC_VECTOR (1 downto 0) := "00";

begin
	
	process(CLK_1ms)
		begin
		if(CLK_1ms' event and CLK_1ms='1') then
			SS <= SS + 1;		-- Se incremente el valor de la señal de control del MUX, para activar los displays de forma consecutiva.
		end if;
	end process;
	
	S <= SS;	-- Cableado de la señal de control del mux.
			
	AN <= 	"0111" when SS="00" else
			"1011" when SS="01" else
			"1101" when SS="10" else
			"1110" when SS="11";
end a_refresco;