----------------------------------------------------------------------------------
--
-- Módulo principal, descripción estructural: cableado.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity main is
    Port ( CLK : in  STD_LOGIC;                      -- Entrada del reloj principal de 50 MHz
           LIN : in  STD_LOGIC;                      -- Entrada de datos del circuito analógico
           SEG7 : out  STD_LOGIC_VECTOR (0 to 6);    -- Salidas para los segmentos del display
			  CONTROL1: out STD_LOGIC;						  -- BORRAR
           CONTROL2: out STD_LOGIC;	
			  AN : out  STD_LOGIC_VECTOR (3 downto 0)); -- Salidas de activación de los displays 
end main;

architecture a_main of main is

-- COMPONENTES
--------------

component div_reloj 
    Port ( CLK : in  STD_LOGIC;           -- Entrada reloj de la FPGA 50 MHz
           CLK_1ms : out  STD_LOGIC);     -- Salida reloj a 1 KHz
end component;

component aut_captura
    Port ( CLK_1ms : in  STD_LOGIC;  -- Reloj del sistema
           BITS : in  STD_LOGIC;     -- Bits de entrada
           CAP : out  STD_LOGIC);    -- Señal para el registro de captura
end component;

component aut_control
    Port ( CLK_1ms : in  STD_LOGIC;                     -- Reloj del sistema
           ASCII : in  STD_LOGIC_VECTOR (8 downto 0);   -- Datos de entrada del registro
           VALID_DISP : out  STD_LOGIC);                -- Salida para validar el display
	
end component;

component detector_bit
    Port ( CLK_1ms : in  STD_LOGIC;    -- Reloj
           LIN     : in  STD_LOGIC;    -- Línea de datos
           BITS   : out  STD_LOGIC);   -- Bits detectados
end component;

component reg_desp_9b
    Port ( CLK_1ms : in  STD_LOGIC;  -- Reloj del sistema
           DAT : in  STD_LOGIC;      -- Entrada de datos
           EN : in  STD_LOGIC;       -- Entrada de ENABLE     
           Q : out  STD_LOGIC_VECTOR (8 downto 0)); --Salida paralelo
end component;

component visualizacion
    
  Port ( E0   : in  STD_LOGIC_VECTOR (7 downto 0);   -- Entrada siguiente carácter
         EN   : in  STD_LOGIC;                       -- Activación para desplazamiento
         CLK_1ms  : in  STD_LOGIC;                   -- Entrada de reloj de refresco       
         SEG7 : out  STD_LOGIC_VECTOR (0 to 6);      -- Salida para los displays 
         AN   : out  STD_LOGIC_VECTOR (3 downto 0)); -- Activación individual
end component;

-- SEÑALES AUXILIARES PARA INTERCONEXIONES

signal dec_bits_out: STD_LOGIC;
signal aut_cap_out: STD_LOGIC;
signal reg_desp9_out: STD_LOGIC_VECTOR (8 downto 0);
signal aut_con_out: STD_LOGIC;
signal div_rej_out: STD_LOGIC;


begin

-- INTERCONEXIÓN DE MÓDULOS
---------------------------

U1 : div_reloj     port map(CLK, div_rej_out);

U2: detector_bit port map(div_rej_out, LIN, dec_bits_out);

U3: aut_captura port map(div_rej_out, dec_bits_out, aut_cap_out);

U4: reg_desp_9b port map(div_rej_out, 
								dec_bits_out, 
								aut_cap_out, 
								reg_desp9_out);
								
U5: aut_control port map(div_rej_out, reg_desp9_out, aut_con_out);

U6: visualizacion port map(reg_desp9_out(7 downto 0), aut_con_out, div_rej_out, SEG7, AN);

end a_main;

