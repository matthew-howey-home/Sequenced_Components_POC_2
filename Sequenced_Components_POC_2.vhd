library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sequenced_Components_POC_2 is
    Port (
        oscena : in std_logic := '1';
        leds   : out std_logic_vector(7 downto 0)
	);
end Sequenced_Components_POC_2;

architecture Behavioral of Sequenced_Components_POC_2 is

    signal clk_int   : std_logic;
    signal prescaler : unsigned(26 downto 0) := (others => '0');
    signal count     : std_logic_vector(7 downto 0) := (others => '0');  -- 8-bit count as std_logic_vector
    signal adder_out : std_logic_vector(7 downto 0);
    signal carry_out : std_logic;
    signal prev_prescaler_bit : std_logic := '0';

    component Internal_Oscillator
        port (
            oscena : in  std_logic;
            clkout : out std_logic
        );
    end component;

    component ADD_Component
        port (
            input_1   : in std_logic_vector(7 downto 0);
            input_2   : in std_logic_vector(7 downto 0);
            carry_in  : in std_logic;
            output    : out std_logic_vector(7 downto 0);
            carry_out : out std_logic
        );
    end component;

begin

    -- instantiate oscillator
    u0: Internal_Oscillator
        port map (
            oscena => oscena,
            clkout => clk_int
        );

    -- instantiate adder
    u_adder: ADD_Component
        port map (
            input_1   => count,
            input_2   => (7 downto 1 => '0') & '1',  -- adding 1 (00000001)
            carry_in  => '0',
            output    => adder_out,
            carry_out => carry_out
        );

    process(clk_int)
    begin
        if rising_edge(clk_int) then
            prescaler <= prescaler + 1;

            -- Rising edge detect on prescaler(26)
            if (prev_prescaler_bit = '0') and (prescaler(26) = '1') then
                count <= adder_out;  -- update count with adder result
            end if;

            prev_prescaler_bit <= prescaler(26);
        end if;
    end process;

    leds <= not count;  -- drive LEDs

end Behavioral;