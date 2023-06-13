LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY cla_tb IS
END cla_tb;

ARCHITECTURE arch OF cla_tb IS

    CONSTANT t_size : INTEGER := 3;

    SIGNAL a, b : STD_LOGIC_VECTOR(t_size - 1 DOWNTO 0);
    SIGNAL result : STD_LOGIC_VECTOR(t_size DOWNTO 0);

    COMPONENT cla IS
        GENERIC (
            size : NATURAL
        );
        PORT (
            a : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            --
            result : OUT STD_LOGIC_VECTOR(size DOWNTO 0)
        );
    END COMPONENT cla;

BEGIN

    UUT : cla
    GENERIC MAP(
        size => t_size
    )
    PORT MAP(
        a => a,
        b => b,
        result => result
    );

    PROCESS IS
    BEGIN
        a <= "000";
        b <= "001";
        WAIT FOR 10 ns;
        a <= "100";
        b <= "010";
        WAIT FOR 10 ns;
        a <= "010";
        b <= "110";
        WAIT FOR 10 ns;
        a <= "111";
        b <= "111";
        WAIT FOR 10 ns;
    END PROCESS;

END ARCHITECTURE; -- arch