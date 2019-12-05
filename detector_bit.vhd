----------------------------------------------------------------------------------
-- 
--  Detector de bits
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity detector_bit is
    Port ( CLK_1ms : in  STD_LOGIC;    -- reloj
           LIN     : in  STD_LOGIC;    -- Línea de datos
           BITS   : out  STD_LOGIC);   -- Bits detectados
end detector_bit;

architecture a_detector_bit of detector_bit is

constant UMBRAL0 : STD_LOGIC_VECTOR (7 downto 0) := "00000101"; --  5 umbral para el 0
constant UMBRAL1 : STD_LOGIC_VECTOR (7 downto 0) := "00101101"; -- 45 umbral para el 1


signal reg_desp : STD_LOGIC_VECTOR (49 downto 0):=(others=>'0');
signal energia  : STD_LOGIC_VECTOR (7 downto 0) :="00000000";
signal s_bits   : STD_LOGIC:='0';

begin

  process (CLK_1ms)
    begin
      if (CLK_1ms'event and CLK_1ms='1') then
         energia <= energia + LIN - reg_desp(49);
			reg_desp(49 downto 1) <= reg_desp(48 downto 0);
			reg_desp(0) <= LIN;
			if (energia > UMBRAL1) then
				s_bits <= '1';
			end if;
			if(energia < UMBRAL0) then
				s_bits <='0';
			end if;
 
      end if;
    end process;
	 
  BITS<=s_bits;   -- Asignación de la salida en función del estado (Moore)
  
end a_detector_bit;

