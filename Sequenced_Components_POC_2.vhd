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

    signal clk_int  : std_logic;
    signal slow_en  : std_logic := '0';
    signal prescaler : unsigned(27 downto 0) := (others => '0');
    signal count     : unsigned(7 downto 0) := (others => '0');

    component Internal_Oscillator
        port (
            oscena : in  std_logic;
            clkout : out std_logic
        );
    end component;

begin

    u0 : Internal_Oscillator
        port map (
            oscena => oscena,
            clkout => clk_int
        );

    process(clk_int)
    begin
        if rising_edge(clk_int) then
            prescaler <= prescaler + 1;

            -- Use a high-order bit as a slow enable
            if prescaler(27) = '1' then
                prescaler <= (others => '0');  -- Reset prescaler
                count <= count + 1;            -- Increment slow counter
            end if;
        end if;
    end process;

    leds <= not std_logic_vector(count);

end Behavioral;
