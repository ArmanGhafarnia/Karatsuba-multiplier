LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY shift_add IS
    PORT (
        clk : IN STD_LOGIC;
        -- rst : IN STD_LOGIC;
        a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        --
        o_result : OUT STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
        done : OUT STD_LOGIC := '0'

    );
END shift_add;

ARCHITECTURE arch OF shift_add IS

    SIGNAL a_temp, b_temp, sum_temp : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');

    SIGNAL flag : STD_LOGIC := '0';

    SIGNAL counter : STD_LOGIC_VECTOR(6 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(32, 7));
BEGIN
    proc_name : PROCESS (clk)
        VARIABLE a1, b1, sum : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
        VARIABLE f : STD_LOGIC;
        VARIABLE c : STD_LOGIC_VECTOR(counter'length - 1 DOWNTO 0);
    BEGIN
        IF rising_edge(clk) THEN

            c := counter;
            IF c = 32 THEN -- initial values
                a1(31 DOWNTO 0) := a;
                -- report "output=" & to_bstring(temp1);
                o_result <= (OTHERS => '0');
                b1(31 DOWNTO 0) := b;
                sum := (OTHERS => '0');
                -- report "output=" & to_bstring(result);
                -- t <= temp1(0);
            ELSE
                a1 := a_temp;
                b1 := b_temp;
                sum := sum_temp;
--                report "output=" & to_bstring(sum);
            END IF;
            
            IF c /= 0 THEN
                IF a1(0) = '1' THEN
                    sum := sum + b1;
                END IF;
                a1 := STD_LOGIC_VECTOR(shift_right(signed(a1), 1));
                b1 := STD_LOGIC_VECTOR(shift_left(signed(b1), 1));
            END IF;

            IF counter = 0 AND flag = '0' THEN
                o_result <= sum;
                flag <= '1';
                done <= '1';
            END IF;

            IF c > 0 THEN
                counter <= counter - 1;
            END IF;

            a_temp <= a1;
            b_temp <= b1;
            sum_temp <= sum;
        END IF;
    END PROCESS proc_name;
END ARCHITECTURE; -- arch