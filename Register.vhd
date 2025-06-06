library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_with_enable is
    Port (
        clk   		: in  std_logic;
        enable    : in  std_logic;
        data_in   : in  std_logic_vector(7 downto 0);
        data_out  : out std_logic_vector(7 downto 0)
    );
end Register_with_enable;

architecture Behavioral of Register_with_enable is
    signal register_internal : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                register_internal <= data_in;
            end if;
        end if;
    end process;

    data_out <= register_internal;
end Behavioral;