library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sequenced_Components_POC_2 is
    Port (
        oscena : in std_logic := '1';  -- Enable signal for the oscillator
        led    : out std_logic         -- Output LED to blink
    );
end Sequenced_Components_POC_2;

architecture Behavioral of Sequenced_Components_POC_2 is

    signal clk_int : std_logic;                      -- internal oscillator clock
    signal counter : unsigned(25 downto 0) := (others => '0');

    component Internal_Oscillator
        port (
            oscena : in  std_logic;
            clkout : out std_logic
        );
    end component;

begin

    -- Instantiate internal oscillator
    u0 : Internal_Oscillator
        port map (
            oscena => oscena,
            clkout => clk_int
        );

    -- Blink LED using internal oscillator
    process(clk_int)
    begin
        if rising_edge(clk_int) then
            counter <= counter + 1;
        end if;
    end process;

    led <= counter(25);  -- Blink at visible rate

end Behavioral;