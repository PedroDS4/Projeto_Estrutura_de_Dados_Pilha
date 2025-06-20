library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk         : in std_logic;
        clr_life    : in std_logic;
        rd          : in std_logic;
        wr          : in std_logic;
        cont        : out std_logic;     -- Controla o contador
        enable_nw   : out std_logic;     -- Habilita escrita no registrador (new write)
        enable_nr   : out std_logic;     -- Habilita leitura do registrador (new read)
        up_dw       : out std_logic      -- Dire��o do contador (up/down)
    );
end controller;

architecture mindset of controller is

    type st is (s, w, push, pop);
    signal estado  : st := s; -- Estado inicial da m�quina de estados

begin
    process (clk, clr_life)
    begin

        if clr_life = '1' then -- Reset Ass�ncrono (limpa a pilha, entrando no estado 's')
            estado <= s;
	    cont      <= '0';
    	    enable_nw <= '0';
            enable_nr <= '0';
            up_dw     <= '0';

             --No reset, as sa�das tamb�m devem estar em um estado conhecido
             --(J� definidas pelas atribui��es padr�o acima, mas pode refor�ar se necess�rio)
        elsif rising_edge(clk) then -- Transi��es s�ncronas na borda de subida do clock
	    cont      <= '0';
    	    enable_nw <= '0';
            enable_nr <= '0';
            up_dw     <= '0';
            case estado is
                when s =>
                    -- Quando no estado 's' (limpeza/inicializa��o), as sa�das j� est�o em '0' (padr�o)
                    -- Pr�ximo estado, sai do 's' para o estado de espera 'w'
	            estado <= w;

                when w =>
                    -- Sa�das j� est�o em '0' (padr�o)
                    if rd = '1' then
                        estado <= pop;
                    elsif wr = '1' then
                        estado <= push;
                    else -- rd = '0' and wr = '0'
                        estado <= w; -- Permanece em 'w'
                    end if;

                when pop =>
                    cont        <= '1'; -- Habilita o contador
                    up_dw       <= '0'; -- Conta para baixo
                    enable_nr   <= '1'; -- Habilita leitura do registrador
                    -- enable_nw permanece '0' (do padr�o)

                    if rd = '0' then
                        estado <= w; -- Volta para espera
                    else
                        estado <= pop; -- Continua a ler enquanto rd for '1' (se for o comportamento desejado)
                    end if;

                when push =>
                    cont        <= '1'; -- Habilita o contador
                    up_dw       <= '1'; -- Conta para cima
                    enable_nw   <= '1'; -- Habilita escrita no registrador
                    -- enable_nr permanece '0' (do padr�o)

                    if wr = '0' then
                        estado <= w; -- Volta para espera
                    else
                        estado <= push; -- Continua a escrever enquanto wr for '1' (se for o comportamento desejado)
                    end if;

                -- when others � uma boa pr�tica para robustez, mas agora as sa�das j� s�o definidas.
                -- Se chegar aqui por um valor 'U' ou 'X' em estado, ele ir� para s.
                when others =>
                    estado <= s;
            end case;
        end if;
    end process;

end architecture mindset;
