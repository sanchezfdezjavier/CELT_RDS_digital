----------------------------------------------------------------------------------
--
-- Aut�mata de captura de bits
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity aut_captura is
    Port ( CLK_1ms : in  STD_LOGIC;  -- Reloj del sistema
           BITS : in  STD_LOGIC;     -- Bits de entrada
           CAP : out  STD_LOGIC);    -- Se�al para el registro de captura
end aut_captura;

architecture a_aut_captura of aut_captura is
type STATE_TYPE is (ESP0,ESP1,DESP25,CAPT,DESP100); -- Definición de todos los estados del autómata

signal ST : STATE_TYPE := ESP0;                     -- Definición e inicialización de la variable auxiliar que define el estado inicial del autómata.
signal s_CAP : STD_LOGIC := '0';                    -- Definición e inicialización de la señal que activa la captura de bits
signal cont : STD_LOGIC_VECTOR (7 downto 0):="00000000";  -- Definición e inicialización del contador



begin
  process (CLK_1ms)                           -- Proceso sensible a la señal de reloj
    begin
      if CLK_1ms'event and CLK_1ms='1' then   -- Condición cada flanco de subida del reloj
        case ST is

          when ESP0 =>      -- Estado inicial. Espera por un '0' y pasa al siguiente estado.
            if BITS='1' then
              ST<=ESP0;
            else
              ST<=ESP1;
            end if;

          when ESP1 =>      --  Cuando llegue un flanco de subida(un '1' después de un '0'), pasa al siguiente estado.
            if BITS='0' then
              ST<= ESP1;
            else
              ST<= DESP25;
            end if;
				
          when DESP25 =>    -- Espera 25 ms. y pasa el estado CAPT.
				    cont<=cont+1;
            if cont>=25 then
					    ST<= CAPT;
				    else
					    ST<= DESP25;
				    end if;
          
        when CAPT =>       -- Activa CAP, reinicia el contador y pasa a DESP100.
          cont<="00000000";
          ST <= DESP100;
        
        when DESP100 =>    -- Espera 98 ms. y vuelve a CAPT.
                           -- Este estado y el anterior constituyen un bloque en el que se activa
                           -- la señal CAPT cada 100 ms. El 98 en el contador se pone debido a que los desplazamientos entre
                           -- CAPT y DESP100 tardan un 1ms.
				  cont <= cont +1;
          if cont < 98 then
            ST <= DESP100;
          else
            ST <= CAPT;
          end if;
 
         end case;		
       end if;
    end process;
	 
  CAP<='1' when (ST = CAPT) else '0';   -- Activa la señal capura cuando el autómata esté en el estado cap
end a_aut_captura;



