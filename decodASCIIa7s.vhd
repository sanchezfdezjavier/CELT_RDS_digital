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
           SEGMENTOS : out  STD_LOGIC_VECTOR (0 to 7));     -- Salidas al display (abcdefg)
end decodASCIIa7s;

architecture a_decodASCIIa7s of decodASCIIa7s is

begin
  with CODIGO select SEGMENTOS<=
	--abcdefg          ASCII
	---------------------------
	 "11111111"  when "00100000", -- ESPACIO
	 "00010001"  when "01000001", -- A 
	 "11000001"  when "01000010", -- B            
	 "01100011"  when "01000011", -- C
	 "10000101"  when "01000100", -- D          --a--
	 "01100001"  when "01000101", -- E         |     |  
	 "01110001"  when "01000110", -- F         f     b
	 "00001001"  when "01000111", -- G         |     |
	 "10010001"  when "01001000", -- H          --g--
	 "11011111"  when "01001001", -- I         |     |
	 "10000111"  when "01001010", -- J         e     c
	 "11111111"  when "01001011", -- K         |     |
	 "11100011"  when "01001100", -- L          --d--
	 "11111111"  when "01001101", -- M
	 "11010101"  when "01001110", -- N
	 "11000101"  when "01001111", -- O  Segmentos encendidos con '0'
	 "00110001"  when "01010000", -- P  Segmentos apagados con '1'
	 "00011001"  when "01010001", -- Q
	 "11110101"  when "01010010", -- R
	 "01001001"  when "01010011", -- S
	 "11100001"  when "01010100", -- T
	 "11000111"  when "01010101", -- U
	 "11111111"  when "01010110", -- V
	 "11111111"  when "01010111", -- W
	 "11111111"  when "01011000", -- X
	 "10001001"  when "01011001", -- Y
	 "11111111"  when "01011010", -- Z
	 "10011110"  when "00110001", -- 1
	 "00100100"  when "00110010", -- 2
	 "00001100"  when "00110011", -- 3
	 "10011000"  when "00110100", -- 4
	 "01001000"  when "00110101", -- 5
	 "11000000"  when "00110110", -- 6
	 "00011110"  when "00110111", -- 7
	 "00000000"  when "00111000", -- 8
	 "00001000"  when "00111001", -- 9
	 "00000010"  when "00110000", -- 0
	 "11111111" when others;      -- apagado

end a_decodASCIIa7s;

