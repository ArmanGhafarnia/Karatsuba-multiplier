LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY full_adder IS
    PORT (
        a : IN std_logic;
        b : IN STD_LOGIC;
        cin : IN STD_LOGIC;
        --
        sum : OUT STD_LOGIC;
        cout : OUT STD_LOGIC
    );
END ENTITY full_adder;



architecture test of full_adder is

    signal temp1, temp2, temp3 : std_logic; 

begin

    temp1 <= a xor b;
    temp2 <= temp1 and cin;
    temp3 <= a and b;

    sum <= temp1 xor cin;
    cout <= temp2 or temp3;


end test ; -- test