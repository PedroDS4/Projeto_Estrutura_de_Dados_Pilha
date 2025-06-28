library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Necessário para 'unsigned' e 'sll'

entity BCD4 is
    port (
        BIN    : in  std_logic_vector(12 downto 0); 
        BCD_M  : out std_logic_vector(3 downto 0);  
        BCD_C  : out std_logic_vector(3 downto 0);
        BCD_D  : out std_logic_vector(3 downto 0);
        BCD_U  : out std_logic_vector(3 downto 0) 
    );
end entity BCD4;

architecture Behavioral_Generate of BCD4 is

    component add3_if_over4 is
        port (
            bcd_in  : in  std_logic_vector(3 downto 0);
            bcd_out : out std_logic_vector(3 downto 0)
        );
    end component add3_if_over4;

    constant N_BITS    : integer := 13;
    constant REG_WIDTH : integer := 16 + N_BITS; -- 29 bits

    type t_stage_vector is array (0 to N_BITS) of std_logic_vector(REG_WIDTH - 1 downto 0);
    signal stages : t_stage_vector;

begin

    stages(0) <= std_logic_vector(resize(unsigned(BIN), REG_WIDTH));

    -- Gera as 13 etapas do algoritmo "Double Dabble"
    gen_stages : for i in 0 to N_BITS - 1 generate
        -- Sinais internos para cada etapa gerada
        signal m_corrected, c_corrected, d_corrected, u_corrected : std_logic_vector(3 downto 0);
        signal corrected_stage : std_logic_vector(REG_WIDTH - 1 downto 0);

    begin
        -- BIN: 12..0 | U: 16..13 | D: 20..17 | C: 24..21 | M: 28..25
        corr_M: add3_if_over4 port map ( bcd_in => stages(i)(N_BITS + 15 downto N_BITS + 12), bcd_out => m_corrected );
        corr_C: add3_if_over4 port map ( bcd_in => stages(i)(N_BITS + 11 downto N_BITS + 8),  bcd_out => c_corrected );
        corr_D: add3_if_over4 port map ( bcd_in => stages(i)(N_BITS + 7 downto N_BITS + 4),   bcd_out => d_corrected );
        corr_U: add3_if_over4 port map ( bcd_in => stages(i)(N_BITS + 3 downto N_BITS),      bcd_out => u_corrected );

        -- Remonta o registrador com os dígitos corrigidos antes do deslocamento
        corrected_stage <= m_corrected & c_corrected & d_corrected & u_corrected & stages(i)(N_BITS - 1 downto 0);

        -- Etapa B: DESLOCAMENTO (Shift Left)
        -- *** CORREÇÃO 1: Adicionado type casting para a operação sll ***
        stages(i+1) <= std_logic_vector( unsigned(corrected_stage) sll 1 );

    end generate gen_stages;

    -- Atribuição final das saídas a partir do estado final do registrador (stages(13))
    BCD_M <= stages(N_BITS)(N_BITS + 15 downto N_BITS + 12);
    BCD_C <= stages(N_BITS)(N_BITS + 11 downto N_BITS + 8);
    BCD_D <= stages(N_BITS)(N_BITS + 7 downto N_BITS + 4);
    BCD_U <= stages(N_BITS)(N_BITS + 3 downto N_BITS);

end architecture Behavioral_Generate;
