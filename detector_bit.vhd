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


signal reg_desp : STD_LOGIC_VECTOR (49 downto 0):=(others=>'0');  -- Declaración e inicialización  a ceros del contenido del registro.
signal energia  : STD_LOGIC_VECTOR (7 downto 0) :="00000000";     -- Declaración e inicialización de la variable que almacena el valor de la energía contenida en el registro.
signal s_bits   : STD_LOGIC:='0';                                 -- Señal auxiliar de salida.

begin

  process (CLK_1ms) -- Proceso sensible a la señal de reloj.
    begin
      if (CLK_1ms'event and CLK_1ms='1') then -- El código dentro del 'if' se ejecutará cada flanco de subida.
        energia <= energia + LIN - reg_desp(49);  -- Actualización del valor de energía. Sumamos el valor entrante y eliminamos el saliente.
			  reg_desp(49 downto 1) <= reg_desp(48 downto 0); -- Desplazamos un bit a la izquierada, eliminado el bit 50 y dejando un 'espacio' en el bit de entrada.
			  reg_desp(0) <= LIN;                             -- Asiganmos el valor entrante al primer bit del registro(posición 0).
			  if (energia > UMBRAL1) then -- Si la energía es mayor que el umbral definido, se activará la señal que indica la presencia de un '1'.
				  s_bits <= '1';
			  end if;
			  if(energia < UMBRAL0) then  -- Si la energía es menor, se considera que hay un '0'.
				  s_bits <='0';
			  end if;
    end if;
  end process;
	 
  BITS<=s_bits;   -- Asignación de la salida en función del estado (Moore)
  
end a_detector_bit;

