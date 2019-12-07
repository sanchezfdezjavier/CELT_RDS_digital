----------------------------------------------------------------------------------
--
-- Autómata de control
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity aut_control is
    Port ( CLK_1ms : in  STD_LOGIC;                     -- Reloj del sistema
           ASCII : in  STD_LOGIC_VECTOR (8 downto 0);   -- Datos de entrada del registro
           VALID_DISP : out  STD_LOGIC);                -- Salida para validar el display
	
end aut_control;

architecture a_aut_control of aut_control is

constant SYNC : STD_LOGIC_VECTOR (8 downto 0) := "100000001"; -- Carácter SYNC

type STATE_TYPE is (ESP_SYNC,ESP_CHAR,VALID_CHAR);	-- Declaración de estados del autómata de Moore.
signal ST : STATE_TYPE:=ESP_SYNC;					-- Declaración e inicializaciónd el estado inicial.
signal cont : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000"; -- Declaración e inicialización del contador.

begin
  process (CLK_1ms) -- Proceso sensible al reloj de 1 ms.
    begin
      if (CLK_1ms'event and CLK_1ms='1') then	-- El código dentro del 'if' se ejecutará cada flanco de subida.
        case ST is
		  
          when ESP_SYNC =>		
            if ASCII=SYNC then   -- Espera hasta tener el carácter SYNC en la entrada ASCII.
					ST <= ESP_CHAR; -- Pasa al estado siguiente ESP_CHAR.
				else
					ST<= ESP_SYNC;  -- En caso de no tener a la entrada la secuencia SYNC, nos quedamo en el mismo estado.
				end if;
				
			 when ESP_CHAR =>	-- Estado encargado de la espera de 900 ms.
				if cont < 898 then	-- 898 en lugar de 900 ms, debido al tiempo de transición entre estados.
					ST <= ESP_CHAR;	-- Pasamos al siguiente estado en caso de haber pasado el tiempo deseado.
				else
					ST <= VALID_CHAR; -- El autómata se queda en el estado actual al no haber discurrido el tiempo suficiente.
				end if;
				cont <= cont +1;	-- Incrementamos el valor del contador. Cada incremento de una unidad será equivalente a sumar 1 ms. de tiempo de espera.
				
			when VALID_CHAR =>
				
				cont <= "0000000000000000";  -- Reinicio del contador.
				ST <= ESP_CHAR;				-- Volvemos al estado de espera para volver a activar la señal VALID_DISP 900 ms. más tarde.
				
		 end case;
		end if;
    end process;
	 
  VALID_DISP<='1' when (ST = VALID_CHAR) else '0'; -- Activación de la señal VALID_DISP cuando el autómata se encuentre en el estado VALID_CHAR. Dicha activación durará un ciclo de reloj(1 ms.)
end a_aut_control;

