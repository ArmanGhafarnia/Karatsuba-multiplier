LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY booth2 IS
    GENERIC (
        size : INTEGER := 16
    );
    PORT (
        -- clk : IN STD_LOGIC,
        clk : IN STD_LOGIC;
        a : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
        -- 
        o_result : OUT STD_LOGIC_VECTOR(2 * size - 1 DOWNTO 0) := (others => '0');
        done : out std_logic := '0'
    );
END booth2;

ARCHITECTURE arch OF booth2 IS

    SIGNAL a0, q : STD_LOGIC_VECTOR(size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL q1 : STD_LOGIC := '0';

    SIGNAL counter : STD_LOGIC_VECTOR(6 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(size, 7));

    ----------   DEBUG MODE ----------
    SIGNAL t1, t2, t3, t4, t5 : STD_LOGIC_VECTOR(size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL t : STD_LOGIC := '0';
    SIGNAL r : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');

    SIGNAL flag : STD_LOGIC := '0';
    ----------   DEBUG MODE ----------
BEGIN
    proc_name : PROCESS (clk)
        VARIABLE temp : STD_LOGIC;
        VARIABLE temp1, temp2, temp3, temp4, temp5 : STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
        VARIABLE ac, not_a : STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
        VARIABLE result : STD_LOGIC_VECTOR(1 DOWNTO 0);
        VARIABLE c : STD_LOGIC_VECTOR(counter'length - 1 DOWNTO 0);
    BEGIN

        IF rising_edge(clk) THEN
            c := counter;
            IF c = size THEN -- initial values
                temp1 := b;
                report "output=" & to_bstring(temp1);
                o_result <= (OTHERS => '0');
                result := temp1(0) & q1;
                temp2 := (others => '0');
                -- report "output=" & to_bstring(result);
                -- t <= temp1(0);
            else 
                temp := q1;
                temp1 := q;
                temp2 := a0;
                result := temp1(0) & q1;
                report "output=" & to_bstring(result);
            END IF;

            IF result = "00" AND c /= 0 THEN
                temp := temp1(0);

                temp1 := temp2(0) & temp1(size - 1 DOWNTO 1);

                temp2 := STD_LOGIC_VECTOR(shift_right(signed(temp2), 1));

            END IF;

            IF result = "11" AND c /= 0 THEN
                temp := temp1(0);

                temp1 := temp2(0) & temp1(size - 1 DOWNTO 1);

                temp2 := STD_LOGIC_VECTOR(shift_right(signed(temp2), 1));

            END IF;

            IF result = "10" AND c /= 0 THEN

                not_a := NOT(a);

                ac := temp2 + not_a + 1;
                -- t1 <= ac;
                temp2 := ac;

                temp := temp1(0);

                temp1 := temp2(0) & temp1(size - 1 DOWNTO 1);

                temp2 := STD_LOGIC_VECTOR(shift_right(signed(temp2), 1));

                

            END IF;

            IF result = "01" AND c /= 0 THEN

                ac := temp2 + a;

                temp2 := ac;

                temp := temp1(0);

                temp1 := temp2(0) & temp1(size - 1 DOWNTO 1);

                temp2 := STD_LOGIC_VECTOR(shift_right(signed(temp2), 1));
            END IF;

            IF counter = 0 AND flag = '0' THEN

                -- t1 <= temp1;
                -- t2 <= temp2;
                -- temp1 := temp2(0) & temp1(size - 1 DOWNTO 1);

                -- temp2 := STD_LOGIC_VECTOR(shift_right(unsigned(temp2), 1));

                -- t3 <= temp1;
                -- t4 <= temp2;
                o_result <= temp2 & temp1;
                flag <= '1';
                done <= '1';
            END IF;

            q1 <= temp;
            q <= temp1;
            a0 <= temp2;
            IF c > 0 THEN
                counter <= counter - 1;
            END IF;

        END IF;
    END PROCESS proc_name;

END arch; -- arch