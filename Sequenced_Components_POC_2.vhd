library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sequenced_Components_POC_2 is
    Port (
        oscena : in std_logic := '1';
		  reset	: in std_logic;
        leds   : out std_logic_vector(7 downto 0)
    );
end Sequenced_Components_POC_2;

architecture Behavioral of Sequenced_Components_POC_2 is

    signal clk_int   : std_logic;
    signal slow_clock_out : std_logic;
    signal count     : std_logic_vector(7 downto 0) := (others => '0');
    signal adder_out : std_logic_vector(7 downto 0);
    signal carry_out : std_logic;
	 signal register_in: std_logic_vector(7 downto 0);

    component Internal_Oscillator
        port (
            oscena : in  std_logic;
            clkout : out std_logic
        );
    end component;

    component Slow_Clock
        port (
            clk      : in  std_logic;
            slow_clock  : out std_logic
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
	 
	 component Register_with_enable
			port (
				clk   		: in  std_logic;
				enable    : in  std_logic;
				data_in   : in  std_logic_vector(7 downto 0);
				data_out  : out std_logic_vector(7 downto 0)
			);
	 end component;
	 
	 component Two_To_One_Byte_Mux
			port (
				input_1		: in std_logic_vector(7 downto 0);
				input_2		: in std_logic_vector(7 downto 0);
				selector		: in std_logic;
				output		: out std_logic_vector(7 downto 0)
			);
	 end component;

begin

    -- Internal oscillator
    u_osc: Internal_Oscillator
        port map (
            oscena => oscena,
            clkout => clk_int
        );

    -- Clock divider
    u_slow_clock: Slow_Clock
        port map (
            clk     => clk_int,
            slow_clock => slow_clock_out
        );

    -- Adder
    u_adder: ADD_Component
        port map (
            input_1   => count,
            input_2   => (7 downto 1 => '0') & '1',  -- add 1
            carry_in  => '0',
            output    => adder_out,
            carry_out => carry_out
        );
		  
	  -- Mux (reset / adder out)
	  u_mux: Two_To_One_Byte_Mux
		  port map (
				input_1	=> adder_out,
				input_2  => (7 downto 0 => '0'),
				selector => reset,
				output	=> register_in
		  );
		  
	  -- Register
	  u_register: Register_with_enable
		  port map (
				clk		=> clk_int,
				enable 	=> slow_clock_out,
				data_in	=>	register_in,
				data_out => count
		  );
	  

    leds <= not count;

end Behavioral;