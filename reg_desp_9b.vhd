----------------------------------------------------------------------------------
--
-- Registro de desplazamiento de 9 bits SERIE/PARALELO con enable
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_desp_9b is
    Port ( CLK_1ms : in  STD_LOGIC;  -- Reloj del sistema
           DAT : in  STD_LOGIC;      -- Entrada de datos
           EN : in  STD_LOGIC;       -- Entrada de ENABLE     
           Q : out  STD_LOGIC_VECTOR (8 downto 0)); -- Salida paralelo de 9 bits.
end reg_desp_9b;

architecture a_reg_desp_9b of reg_desp_9b is

signal s_Q : STD_LOGIC_VECTOR (8 downto 0):="000000000"; -- Declaración e inicialización del contenido del registro.

begin

  process (CLK_1ms)
    begin
		if(CLK_1ms'event and CLK_1ms ='0') then -- Sensibilidad al flanco de subida.
			if EN = '1' then
				s_Q(8 downto 1) <= s_Q(7 downto 0);	-- Desplazamiento hacia la izquierda. Sacamos último bit(posición 8) y dejamos 'libre' la posición 0.
				S_Q(0) <= DAT;						-- Se introduce en la primera posición del registro el bit de entrada.					
			end if;
		end if;

	end process;
	 
Q<=s_Q;   -- La señal s_Q se cablea con la salida

end a_reg_desp_9b;

