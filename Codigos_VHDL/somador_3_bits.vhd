library ieee;
use ieee.std_logic_1164.all;


entity somador_3_bits is
	port(
	A,B : in std_logic_vector(2 downto 0);
	C_i : in std_logic;
	C_0 : out std_logic;
	S :   out std_logic_vector(2 downto 0)
	);
end somador_3_bits;



architecture CKT of somador_3_bits is 
	
	
	component somador_1_bit
		port(
			A: in std_logic;
			B: in std_logic;
			C_i: in std_logic;
			C_0: out std_logic;
			S: out std_logic
			);
	end component;

	
	signal c : std_logic_vector(2 downto 0);
		
	

begin 
	
	S0: somador_1_bit port map(
  	A => A(0),
  	B => B(0),
  	C_i => C_i,       -- carry-in inicial
  	C_0 => c(0),      -- carry-out vai pro pr�ximo est�gio
  	S => S(0)
);
	S1: somador_1_bit port map(
  	A => A(1),
  	B => B(1),
  	C_i => c(0),
  	C_0 => c(1),
  	S => S(1)
);
	S2: somador_1_bit port map(
  	A => A(2),
  	B => B(2),
  	C_i => c(1),
  	C_0 => c(2),
  	S => S(2)
);
	
	C_0 <= c(2);

end CKT;
