----------------------------------------------------------------------------------
--
-- Decodificador de ASCII a 7 segmentos 
-- Departamento de Ingeniería Electrónica (2019)
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decodASCIIa7s is
    Port ( CODIGO    : in  STD_LOGIC_VECTOR (7 downto 0);   -- Entrada del código ASCII
           SEGMENTOS : out  STD_LOGIC_VECTOR (0 to 6));     -- Salidas al display (abcdefg)
end decodASCIIa7s;

architecture a_decodASCIIa7s of decodASCIIa7s is

begin
  with CODIGO select SEGMENTOS<=
	--abcdefg          ASCII
	---------------------------
	 "1111111"  when "00100000", -- ESPACIO
	 "0001000"  when "01000001", -- A 
	 "1100000"  when "01000010", -- B            
	 "0110001"  when "01000011", -- C
	 "1000010"  when "01000100", -- D          --a--
	 "0110000"  when "01000101", -- E         |     |  
	 "0111000"  when "01000110", -- F         f     b
	 "0000100"  when "01000111", -- G         |     |
	 "1001000"  when "01001000", -- H          --g--
	 "1101111"  when "01001001", -- I         |     |
	 "1000011"  when "01001010", -- J         e     c
	 "1111111"  when "01001011", -- K         |     |
	 "1110001"  when "01001100", -- L          --d--
	 "1111111"  when "01001101", -- M
	 "1101010"  when "01001110", -- N
	 "1100010"  when "01001111", -- O  Segmentos encendidos con '0'
	 "0011000"  when "01010000", -- P  Segmentos apagados con '1'
	 "0001100"  when "01010001", -- Q
	 "1111010"  when "01010010", -- R
	 "0100100"  when "01010011", -- S
	 "1110000"  when "01010100", -- T
	 "1100011"  when "01010101", -- U
	 "1111111"  when "01010110", -- V
	 "1111111"  when "01010111", -- W
	 "1111111"  when "01011000", -- X
	 "1000100"  when "01011001", -- Y
	 "1111111"  when "01011010", -- Z
	 "1001111"  when "00110001", -- 1
	 "0010010"  when "00110010", -- 2
	 "0000110"  when "00110011", -- 3
	 "1001100"  when "00110100", -- 4
	 "0100100"  when "00110101", -- 5
	 "1100000"  when "00110110", -- 6
	 "0001111"  when "00110111", -- 7
	 "0000000"  when "00111000", -- 8
	 "0000100"  when "00111001", -- 9
	 "0000001"  when "00110000", -- 0
	 "1111111" when others;      -- apagado

end a_decodASCIIa7s;

