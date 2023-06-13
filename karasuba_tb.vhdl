LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY kara_tb IS
END kara_tb;

ARCHITECTURE arch OF kara_tb IS
    SIGNAL clk, start, rest : STD_LOGIC := '0';
    SIGNAL a, b : STD_LOGIC_VECTOR(255 DOWNTO 0);
    SIGNAL result : STD_LOGIC_VECTOR(511 DOWNTO 0);
    SIGNAL done : STD_LOGIC;

    COMPONENT karasuba255bit IS
        PORT (
            clk : IN STD_LOGIC;
            rest : IN STD_LOGIC;
            start : IN STD_LOGIC;
            a : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(255 DOWNTO 0);

            p : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
            done : OUT STD_LOGIC
        );
    END COMPONENT karasuba255bit;
BEGIN

    clk <= NOT clk AFTER 5 ns;
    UUT : karasuba255bit
    PORT MAP(
        clk => clk,
        rest => rest,
        start => start,
        a => a,
        b => b,
        p => result,
        done => done
    );

    PROCESS IS
    BEGIN
        a <= 256D"11302753";
        b <= 256D"16715902";
        WAIT FOR 100 ns;
        WAIT;
    END PROCESS;

END ARCHITECTURE;