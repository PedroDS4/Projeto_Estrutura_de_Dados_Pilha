
library ieee;
use ieee.std_logic_1164.all;


entity somador_n_bits is
	port(
	A,B : in std_logic_vector(12 downto 0);
	C_0 : out std_logic;
	S :   out std_logic_vector(12 downto 0)
	);
end somador_n_bits;



architecture CKT of somador_n_bits is 
	
	
	component somador_1_bit
		port(
			A: in std_logic;
			B: in std_logic;
			C_i: in std_logic;

			C_0: out std_logic;
			S: out std_logic
			);
	end component;

	
	signal c : std_logic_vector(12 downto 0);
		
	

begin 
	
	S0: somador_1_bit port map(
  	A => A(0),
  	B => B(0),
  	C_i => '0',       -- carry-in inicial
  	C_0 => c(0),      -- carry-out vai pro próximo estágio
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
	S3: somador_1_bit port map(
  	A => A(3),
  	B => B(3),
  	C_i => c(2),
  	C_0 => c(3),
  	S => S(3)
);
	S4: somador_1_bit port map(
  	A => A(4),
  	B => B(4),
  	C_i => c(3),
  	C_0 => c(4),
  	S => S(4)
);
	S5: somador_1_bit port map(
  	A => A(5),
  	B => B(5),
  	C_i => c(4),
  	C_0 => c(5),
  	S => S(5)
);
	S6: somador_1_bit port map(
  	A => A(6),
  	B => B(6),
  	C_i => c(5),
  	C_0 => c(6),
  	S => S(6)
);
	S7: somador_1_bit port map(
  	A => A(7),
  	B => B(7),
  	C_i => c(6),
  	C_0 => c(7),
  	S => S(7)
);
	S8: somador_1_bit port map(
  	A => A(8),
  	B => B(8),
  	C_i => c(7),
  	C_0 => c(8),
  	S => S(8)
);
	S9: somador_1_bit port map(
  	A => A(9),
  	B => B(9),
  	C_i => c(8),
  	C_0 => c(9),
  	S => S(9)
);
	S10: somador_1_bit port map(
  	A => A(10),
  	B => B(10),
  	C_i => c(9),
  	C_0 => c(10),
  	S => S(10)
);
	S11: somador_1_bit port map(
  	A => A(11),
  	B => B(11),
  	C_i => c(10),
  	C_0 => c(11),
  	S => S(11)
);
	S12: somador_1_bit port map(
  	A => A(12),
  	B => B(12),
  	C_i => c(11),
  	C_0 => c(12),
  	S => S(12)
);
	C_0 <= c(12);

end CKT;