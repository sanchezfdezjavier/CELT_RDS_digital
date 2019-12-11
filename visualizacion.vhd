----------------------------------------------------------------------------------
-- 
-- Módulo de visualización, descripción estructural: cableado.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity visualizacion is
    
  Port ( E0   : in  STD_LOGIC_VECTOR (7 downto 0);   -- Entrada siguiente carácter
         EN   : in  STD_LOGIC;                       -- Activación para desplazamiento
         CLK_1ms  : in  STD_LOGIC;                   -- Entrada de reloj de refresco       
         SEG7 : out  STD_LOGIC_VECTOR (0 to 6);      -- Salida para los displays 
         AN   : out  STD_LOGIC_VECTOR (3 downto 0)); -- Activación individual
end visualizacion;


architecture a_visualizacion of visualizacion is

--SEÑALES NECESARIAS PARA LAS INTERCONEXIONES
	signal ref_a_mux: STD_LOGIC_VECTOR(1 downto 0);
	signal mux_a_deco: STD_LOGIC_VECTOR(7 downto 0);
	signal reg_a_mux0: STD_LOGIC_VECTOR(7 downto 0);
	signal reg_a_mux1: STD_LOGIC_VECTOR(7 downto 0);
	signal reg_a_mux2: STD_LOGIC_VECTOR(7 downto 0);
	signal reg_a_mux3: STD_LOGIC_VECTOR(7 downto 0);


-- COMPONENTES
--------------

-- Multiplexor
component MUX4x8
  Port (   E0 : in  STD_LOGIC_VECTOR (7 downto 0); -- Entrada de datos 0
           E1 : in  STD_LOGIC_VECTOR (7 downto 0); -- Entrada de datos 1
           E2 : in  STD_LOGIC_VECTOR (7 downto 0); -- Entrada de datos 2
           E3 : in  STD_LOGIC_VECTOR (7 downto 0); -- Entrada de datos 3
           S : in  STD_LOGIC_VECTOR (1 downto 0);  -- Señal de control
           Y : out  STD_LOGIC_VECTOR (7 downto 0)); -- Salida
end component;

--DECODIFICADOR
component decodASCIIa7s
	Port ( CODIGO    : in  STD_LOGIC_VECTOR (7 downto 0);   -- Entrada del código ASCII
           SEGMENTOS : out  STD_LOGIC_VECTOR (0 to 6));     -- Salidas al display (abcdefg)
end component;

--REFRESCO
component refresco

	Port ( CLK_1ms : in  STD_LOGIC;                  -- reloj de refresco
				  S : out  STD_LOGIC_VECTOR (1 downto 0);   -- Control para el mux
				  AN : out  STD_LOGIC_VECTOR (3 downto 0)); -- Control displays individuales
end component;

--REGISTRO DE DESPLAZAMIENTO
component rdesp_disp
	Port ( CLK_1ms : in   STD_LOGIC;                       -- entrada de reloj
				EN      : in   STD_LOGIC;                       -- enable         
				E       : in   STD_LOGIC_VECTOR (7 downto 0);   -- entrada de datos    
				Q0      : out  STD_LOGIC_VECTOR (7 downto 0);   -- salida Q0           
				Q1      : out  STD_LOGIC_VECTOR (7 downto 0);   -- salida Q1           
				Q2      : out  STD_LOGIC_VECTOR (7 downto 0);   -- salida Q2          
				Q3      : out  STD_LOGIC_VECTOR (7 downto 0));  -- salida Q3
end component;




begin

	--INTERCONEXIÓN DE MÓDULOS
	--------------------------

	U1: MUX4x8	port map(reg_a_mux0,
								reg_a_mux1,
								reg_a_mux2,
								reg_a_mux3,
								ref_a_mux,
								mux_a_deco);

	U2: rdesp_disp port map(CLK_1ms,
									EN,
									E0,
									reg_a_mux3,
									reg_a_mux2,
									reg_a_mux1,
									reg_a_mux0);

	U3: refresco port map(CLK_1ms, ref_a_mux, AN);

	U4: decodASCIIa7s port map(mux_a_deco, SEG7);
									
end a_visualizacion;


