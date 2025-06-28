library ieee;
use ieee.std_logic_1164.all;

entity LIFO is
   port (
		w_data : in std_logic_vector(12 downto 0);
	    rd, wr: in std_logic;
		clk : in std_logic;
	    clr: in std_logic;
	    em, fu: out std_logic;
		HEX0: out std_logic_vector(6 downto 0);
	    HEX1: out std_logic_vector(6 downto 0);
            HEX2: out std_logic_vector(6 downto 0);
	    HEX3: out std_logic_vector(6 downto 0)
);
end LIFO;





architecture CKT of LIFO is


   signal BCD: std_logic_vector(15 downto 0);
   signal r_data: std_logic_vector(12 downto 0);
	signal not_wr, not_rd: std_logic;
   signal ck: std_logic;
   signal clr_life: std_logic;
   signal en_rd, en_wr, count, up_dw: std_logic;




   component BCD4
	port (
        BIN    : in  std_logic_vector(12 downto 0);
        BCD_M  : out std_logic_vector(3 downto 0); -- Milhar
        BCD_C  : out std_logic_vector(3 downto 0); -- Centenas
        BCD_D  : out std_logic_vector(3 downto 0); -- Dezenas
        BCD_U  : out std_logic_vector(3 downto 0)  -- Unidades
    );
  end component;


    component display7
    port (
        A, B, C, D : in std_logic;
        l: out std_logic_vector(6 downto 0)
    );
    end component;


    component datapath
	port (
	w_data : in std_logic_vector(12 downto 0);
	en_rd, en_wr, count, up_dw: in std_logic;
	clk : in std_logic;
        clr : in std_logic;
	em, fu: out std_logic;
	r_data: out std_logic_vector(12 downto 0)
);
	end component; 


	component controller
	port(
        clk 	    : in std_logic;
        clr_life    : in std_logic;
	rd	    : in std_logic;
	wr	    : in std_logic;
	cont	    : out std_logic;
	enable_nw   : out std_logic;
        enable_nr   : out std_logic;
        up_dw       : out std_logic
    );
	end component;


	component ck_div
	port(
	ck_in  : in  std_logic;
	ck_out : out  std_logic
	);
    	end component;


begin


   
     	FREQ_DIV: ck_div 
	       port map(
		  ck_in => clk,
		  ck_out => ck
	 );

   clr_life <= not(clr);
	not_rd <= not(rd);
	not_wr <= not(wr);
	
	
	CONTROLLER_CIRCUIT: controller
	port map(
	clk => ck,
	clr_life => clr_life,
	rd => not_rd,
   wr => not_wr,
	cont => count,
	enable_nw => en_wr,
	enable_nr => en_rd,
	up_dw => up_dw
	);

	DATAPATH_CIRCUIT: datapath 
	   port map(
     	   w_data => w_data,
	   en_rd => en_rd,
	   en_wr => en_wr,
	   count => count,
	   up_dw => up_dw,
	   clk => ck,
	   clr => clr_life,
	   em => em,
	   fu => fu,
	   r_data => r_data
	    );

	


     BCD_1: BCD4 port map(
     	BIN => r_data,
     	BCD_M => BCD(15 downto 12),
     	BCD_C => BCD(11 downto 8),
     	BCD_D => BCD(7 downto 4),
     	BCD_U => BCD(3 downto 0)
	);
	   

     --- A: bit mais significativo ---
	 LED0: display7 port map(
	   A => BCD(3),
	   B => BCD(2),
	   C => BCD(1),
	   D => BCD(0),
	   l => HEX0
	   );
	   
	   
	   LED1: display7 port map(
	   A => BCD(7),
	   B => BCD(6),
	   C => BCD(5),
	   D => BCD(4),
	   l => HEX1
	   );
	   
	   LED2: display7 port map(
	   A => BCD(11),
	   B => BCD(10),
	   C => BCD(9),
	   D => BCD(8),
	   l => HEX2
	   );

	   LED3: display7 port map(
	   A => BCD(15),
	   B => BCD(14),
	   C => BCD(13),
	   D => BCD(12),
	   l => HEX3
	   );

end CKT;