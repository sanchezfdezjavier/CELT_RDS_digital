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

constant SYNC : STD_LOGIC_VECTOR (8 downto 0) := "100000001"; -- carácter SYNC

type STATE_TYPE is (ESP_SYNC,ESP_CHAR,VALID_CHAR);
signal ST : STATE_TYPE:=ESP_SYNC;
signal cont : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";

begin
  process (CLK_1ms)
    begin
      if (CLK_1ms'event and CLK_1ms='1') then
        case ST is
		  
          when ESP_SYNC =>
			 --VALID_DISP <= '0';
            if ASCII=SYNC then   -- Esperar por el SYNC
					ST <= ESP_CHAR;
				else
					ST<= ESP_SYNC;
				end if;
				
			 when ESP_CHAR =>
				--VALID_DISP <= '0';
				if cont < 898 then
					ST <= ESP_CHAR;
				else
					ST <= VALID_CHAR;
				end if;
				cont <= cont +1;
				
			when VALID_CHAR =>
				--VALID_DISP <= '1';
				cont <= "0000000000000000";
				ST <= ESP_CHAR;
				
		 end case;
		end if;
    end process;
	 
  VALID_DISP<='1' when (ST = VALID_CHAR) else '0';
end a_aut_control;

