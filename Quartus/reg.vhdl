------------------------------
-- 0: REGISTER
-- 1: LOGICAL RIGHT SHIFT
-- 2: ARITHMETIC RIGHT SHIFT
-- 3: CIRCULAR RIGHT SHIFT
------------------------------
LIBRARY ieee;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY reg IS
    PORT (
        clk : IN STD_LOGIC;
        rest : IN STD_LOGIC;
        start : IN STD_LOGIC;
        a : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(255 DOWNTO 0);

        p : OUT STD_LOGIC_VECTOR(511 DOWNTO 0) := (OTHERS => '0');
        done : OUT STD_LOGIC := '0'
    );
END reg;
ARCHITECTURE behavioral OF reg IS

    SIGNAL half_one_1, half_one_2, half_two_1, half_two_2, sum_1, sum_2, sum_3 : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL result_1, result_2, result_3 : STD_LOGIC_VECTOR(255 DOWNTO 0);
    SIGNAL flag : STD_LOGIC := '0';

    SIGNAL done_1, done_2, done_3, final : STD_LOGIC := '0';

    COMPONENT karasuba128bit IS
        PORT (
            clk : IN STD_LOGIC;
            rest : IN STD_LOGIC;
            start : IN STD_LOGIC;
            a : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
            b : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
				
				p : out STD_LOGIC_VECTOR(255 DOWNTO 0);
            done : OUT STD_LOGIC
        );
    END COMPONENT karasuba128bit;
	 
	 
BEGIN
    half_one_1 <= a(255 DOWNTO 128);
    half_one_2 <= a(127 DOWNTO 0);
    half_two_1 <= b(255 DOWNTO 128);
    half_two_2 <= b(127 DOWNTO 0);
    sum_1 <= half_one_1 + half_one_2;
    sum_2 <= half_two_1 + half_two_2;

    x : karasuba128bit
    PORT MAP(
        clk => clk,
        rest => rest,
        start => start,
        a => half_one_1,
        b => half_two_1,
        p => result_1,
        done => done_1
    );

    y : karasuba128bit
    PORT MAP(
        clk => clk,
        rest => rest,
        start => start,
        a => half_one_2,
        b => half_two_2,
        p => result_2,
        done => done_2
    );
    z : karasuba128bit
    PORT MAP(
        clk => clk,
        rest => rest,
        start => start,
        a => sum_1,
        b => sum_2,
        p => result_3,
        done => done_3
    );

    final <= done_1 AND done_2 AND done_3;
    main : PROCESS
        VARIABLE sum_temp : STD_LOGIC_VECTOR(63 DOWNTO 0);

        VARIABLE z1 : STD_LOGIC_VECTOR(511 DOWNTO 0) := (OTHERS => '0');
        VARIABLE z2 : STD_LOGIC_VECTOR(511 DOWNTO 0) := (OTHERS => '0');
        VARIABLE z3 : STD_LOGIC_VECTOR(511 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        flag <= '1';
        WAIT UNTIL final = '1';
        z1(511 DOWNTO 256) := result_1;
        z2(383 DOWNTO 128) := result_3 - result_2 - result_1;
        z3(255 DOWNTO 0) := result_2;

        p <= z1 + z2 + z3;
        done <= '1';
        

    END PROCESS main;
END behavioral;