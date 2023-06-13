LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY test IS
END test;

ARCHITECTURE arch OF test IS
    SIGNAL clk, rest : STD_LOGIC := '0';
    SIGNAL a, b : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL result : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL done : STD_LOGIC;

    COMPONENT shift_add IS
        PORT (
            clk : IN STD_LOGIC;
            -- rst : IN STD_LOGIC;
            a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

            --
            o_result : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
            done : OUT STD_LOGIC
        );
    END COMPONENT shift_add;

BEGIN
    -- rest <= '1', '0' AFTER 30 ns;
    clk <= NOT clk AFTER 5 ns;
    UUT : shift_add
    PORT MAP(
        clk => clk,
        -- rst => rest,
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