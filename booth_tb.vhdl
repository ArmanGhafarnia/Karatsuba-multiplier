LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY booth_tb IS
END booth_tb;

ARCHITECTURE arch OF booth_tb IS
    CONSTANT t_size : INTEGER := 32;
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL a, b : STD_LOGIC_VECTOR(t_size - 1 DOWNTO 0);
    SIGNAL result : STD_LOGIC_VECTOR(2 * t_size - 1 DOWNTO 0);
    SIGNAL done : STD_LOGIC;

    COMPONENT booth2 IS
        GENERIC (
            size : NATURAL
        );
        PORT (
            clk : IN STD_LOGIC;
            a : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            -- 
            o_result : OUT STD_LOGIC_VECTOR(2 * size - 1 DOWNTO 0);
            done : OUT STD_LOGIC := '0'
        );
    END COMPONENT booth2;
BEGIN

    clk <= NOT clk AFTER 5 ns;
    UUT : booth2
    GENERIC MAP(
        size => t_size
    )
    PORT MAP(
        clk => clk,
        a => a,
        b => b,
        o_result => result,
        done => done
    );

    PROCESS IS
    BEGIN
        -- a <= "0000000000000010";
        -- b <= "0000000000000010";
        -- WAIT FOR 100 ns;
        -- a <= "0000000000000010";
        -- b <= "0000000000000011";
        -- WAIT FOR 100 ns;
        -- a <= "0000000000000110";
        -- b <= "0000000000000010";
        a <= 32D"3";
        b <= 32D"14";
        WAIT FOR 100 ns;
        WAIT;
    END PROCESS;

END ARCHITECTURE;