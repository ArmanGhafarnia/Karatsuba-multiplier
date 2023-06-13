LIBRARY ieee;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY karasuba64bit IS
    PORT (
        clk : IN STD_LOGIC;
        rest : IN STD_LOGIC;
        start : IN STD_LOGIC;
        a : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(63 DOWNTO 0);

        p : OUT STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
        done : OUT STD_LOGIC := '0'

    );
END karasuba64bit;

ARCHITECTURE arch OF karasuba64bit IS
    CONSTANT t_size : INTEGER := 32;
    SIGNAL half_one_1, half_one_2, half_two_1, half_two_2, sum_1, sum_2, sum_3 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL result_1, result_2, result_3 : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL flag : STD_LOGIC := '0';

    SIGNAL done_1, done_2, done_3, final : STD_LOGIC := '0';

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
            done : OUT STD_LOGIC
        );
    END COMPONENT booth2;
BEGIN
    half_one_1 <= a(63 DOWNTO 32);
    half_one_2 <= a(31 DOWNTO 0);
    half_two_1 <= b(63 DOWNTO 32);
    half_two_2 <= b(31 DOWNTO 0);
    sum_1 <= half_one_1 + half_one_2;
    sum_2 <= half_two_1 + half_two_2;

    x : booth2
    GENERIC MAP(
        size => t_size
    )
    PORT MAP(
        clk => clk,
        a => half_one_1,
        b => half_two_1,
        o_result => result_1,
        done => done_1
    );

    y : booth2
    GENERIC MAP(
        size => t_size
    )
    PORT MAP(
        clk => clk,
        a => half_one_2,
        b => half_two_2,
        o_result => result_2,
        done => done_2
    );
    z : booth2
    GENERIC MAP(
        size => t_size
    )
    PORT MAP(
        clk => clk,
        a => sum_1,
        b => sum_2,
        o_result => result_3,
        done => done_3
    );

    final <= done_1 AND done_2 AND done_3;
    main : PROCESS
        VARIABLE sum_temp : STD_LOGIC_VECTOR(64 DOWNTO 0);

        VARIABLE z1 : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
        VARIABLE z2 : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
        VARIABLE z3 : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        flag <= '1';
        WAIT UNTIL final = '1';
        z1(127 DOWNTO 64) := result_1;
        z2(95 DOWNTO 32) := result_3 - result_2 - result_1;
        z3(63 DOWNTO 0) := result_2;

        p <= z1 + z2 + z3;
        done <= '1';
        WAIT UNTIL flag = '0';

    END PROCESS main;
END ARCHITECTURE;