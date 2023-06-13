LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY cla IS
    GENERIC (
        size : INTEGER := 16
    );
    PORT (
        a : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
        --
        result : OUT STD_LOGIC_VECTOR(size DOWNTO 0)
    );
END cla;

ARCHITECTURE arch OF cla IS

    COMPONENT full_adder IS
        PORT (
            a : IN STD_LOGIC;
            b : IN STD_LOGIC;
            cin : IN STD_LOGIC;
            sum : OUT STD_LOGIC;
            cout : OUT STD_LOGIC
        );
    END COMPONENT full_adder;
    SIGNAL G, P, sum : STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
    SIGNAL carry : STD_LOGIC_VECTOR(size DOWNTO 0);

begin 

    carry(0) <= '0';

    result <= carry(size) & sum;


    main_loop: for i in 0 to size - 1 generate
        adder : full_adder
        port map (
            a => a(i),
            b => b(i),
            cin => carry(i),
            sum => sum(i),
            cout => open
        );
    end generate main_loop;




    cla: for ii in 0 to size-1 generate
        G(ii) <= a(ii) and b(ii);
        P(ii) <= a(ii) or b(ii);
        carry(ii+1) <= G(ii) or (P(ii) and carry(ii));
    end generate cla;



END ARCHITECTURE; -- arch