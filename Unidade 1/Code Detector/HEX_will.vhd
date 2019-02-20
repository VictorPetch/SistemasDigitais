library ieee;
use ieee.std_logic_1164.all;


entity seg7 is
	port(A: in std_logic_vector(3 downto 0);
		SD: out std_logic_vector(6 downto 0));
end seg7;


architecture ckt of seg7 is

begin 

		
	SD(0) <= NOT(((not A(0)) and (not A(2))) or A(1) or A(3) or (A(2) and A(0)));
	SD(1) <= NOT((not A(2)) or A(3) or ((not A(1)) and (not A(0))) or (A(1) and A(0)));
	SD(2) <= NOT((not A(1)) or A(0) or ((not A(3)) and A(2)));
	SD(3) <= NOT(((not A(2)) and (not A(0))) or ((not A(2)) and A(1)) or (A(1) and (not A(0))) or (A(2) and (not A(1)) and A(0)));
	SD(4) <= NOT((A(1) and (not A(0))) or ((not A(2)) and (not A(0))));
	SD(5) <= NOT(A(3) or ((not A(1)) and (not A(0))) or (A(2) and (not A(1))) or (A(2) and (not A(0))));
	SD(6) <= NOT((A(2) and (not A(1))) or (A(1) and (not A(0))) or A(3) or ((not A(2)) and A(1)));
end ckt;