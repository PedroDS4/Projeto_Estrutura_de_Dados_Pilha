library ieee;
use ieee.std_logic_1164.all;


entity datapath is
   port (
        w_data : in std_logic_vector(12 downto 0);
        en_rd, en_wr, count, up_dw: in std_logic;
        clk, clr : in std_logic;
	    em, fu: out std_logic;
        r_data: out std_logic_vector(12 downto 0)
);
end datapath;

architecture CKT of datapath is


    signal addr_r, addr_w : std_logic_vector(2 downto 0) := "000";
      signal addr_r_expanded, addr_w_expanded: std_logic_vector(12 downto 0) := (others => '0');


      component B_reg
	port (
        w_data : in std_logic_vector(12 downto 0);
        addr_r, addr_w : in std_logic_vector(2 downto 0);
        en_rd, en_wr: in std_logic;
        clk, clr : in std_logic;
        r_data: out std_logic_vector(12 downto 0)
	);
	end component;


   component comparador_13
     port (
        A      : in  std_logic_vector(12 downto 0);
        B      : in  std_logic_vector(12 downto 0);
        maior  : out std_logic;
        igual  : out std_logic;
        menor  : out std_logic
    );
     end component;


	component contador
	port (
   		clk, count, up_dw, clr: in std_logic;
   		V_count : out std_logic_vector(2 downto 0) 
	);
	end component;
 

	component somador_3_bits
	port(
	A,B : in std_logic_vector(2 downto 0);
	C_i: in std_logic;
	C_0 : out std_logic;
	S :   out std_logic_vector(2 downto 0)
	);
	end component;



begin

    

	CONTADOR_PONTEIRO: contador port map(
	    clk => clk,
	    count => count,
	    up_dw => up_dw, 
	    clr => clr,
   	    V_count => addr_r
	);
        


	SOMADOR: somador_3_bits port map(
          A => addr_r,
          B => "001",
	       C_i => '0',
          C_0 => open,
          S => addr_w
         );


     B_REGISTER: B_reg port map(
        w_data => w_data,
	    addr_r => addr_r,
	    addr_w => addr_w,
            en_rd => en_rd,
            en_wr => en_wr,
            clk => clk,
	    clr => clr,
	    r_data => r_data
        );
      
 
	   addr_r_expanded <= "0000000000" & addr_r;
	   addr_w_expanded <= "0000000000" & addr_w;

       COMPARADOR1_13_bits: comparador_13 port map(
          A => addr_r_expanded,
          B => "0000000000111",
          maior => open,
          igual => fu,
          menor => open
         );

	   COMPARADOR2_13_bits: comparador_13 port map(
          A => addr_w_expanded,
          B => "0000000000000",
          maior => open,
          igual => em,
          menor => open
         );



end CKT;
