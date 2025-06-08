library ieee;
use ieee.std_logic_1164.all;

-- Two to One byte Multiplexer (Mux)
-- selects input_1 if selector is 0
-- selects input_2 if selector is 1

entity Two_To_One_Byte_Mux is
    port (
			input_1		: in std_logic_vector(7 downto 0);
			input_2		: in std_logic_vector(7 downto 0);
			selector		: in std_logic;

			output		: out std_logic_vector(7 downto 0)
    );
end entity Two_To_One_Byte_Mux;

architecture Behavioral of Two_To_One_Byte_Mux is
begin
	output(0) <= (input_1(0) and not selector) or (input_2(0) and selector);
	output(1) <= (input_1(1) and not selector) or (input_2(1) and selector);
	output(2) <= (input_1(2) and not selector) or (input_2(2) and selector);
	output(3) <= (input_1(3) and not selector) or (input_2(3) and selector);
	output(4) <= (input_1(4) and not selector) or (input_2(4) and selector);
	output(5) <= (input_1(5) and not selector) or (input_2(5) and selector);
	output(6) <= (input_1(6) and not selector) or (input_2(6) and selector);
	output(7) <= (input_1(7) and not selector) or (input_2(7) and selector);

end architecture Behavioral;
