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
	 signal prescaler23	: std_logic;
    signal count     : std_logic_vector(7 downto 0) := (others => '0');
    signal adder_out : std_logic_vector(7 downto 0);
    signal carry_out : std_logic;
	 signal register_in: std_logic_vector(7 downto 0);
	 signal memory_out	: std_logic_vector(7 downto 0);
 

    component Internal_Oscillator
        port (
            oscena : in  std_logic;
            clkout : out std_logic
        );
    end component;

    component Slow_Clock
        port (
            clk      : in  std_logic;
            slow_clock  : out std_logic;
				-- visible bit for debugging
				prescaler23	: out std_logic
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
				clk   			: in  std_logic;
				write_enable   : in  std_logic;
				output_enable	: in 	std_logic;
				data_in   		: in  std_logic_vector(7 downto 0);
				data_out  		: out std_logic_vector(7 downto 0)
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
	 
	 component RAM
			generic (
				DATA_WIDTH : integer := 8;
				ADDR_WIDTH : integer := 8
			);
			port (
				clk      		: in  std_logic;
				write_enable   : in  std_logic;
				read_enable   	: in  std_logic;
				address     	: in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
				data_in  		: in  std_logic_vector(DATA_WIDTH - 1 downto 0);
				data_out 		: out std_logic_vector(DATA_WIDTH - 1 downto 0)
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
            slow_clock => slow_clock_out,
				prescaler23 => prescaler23
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
				clk				=> clk_int,
				write_enable 	=> slow_clock_out,
				output_enable	=> '1',
				data_in			=>	register_in,
				data_out 		=> count
		  );
		
		-- RAM:
		u_ram: RAM
		  port map (
				clk				=> clk_int,
				read_enable 	=> '0', -- active low, 0 means enable
				write_enable 	=> '1', -- active low, 1 means don't enable
				address			=> count,
				data_in 			=> (7 downto 0 => '0'),
				data_out			=> memory_out
		  );
	  

    -- leds <= not count;
	 -- leds <= not memory_out;
	 leds(7 downto 1) <= (others => '1');
	 leds(0) <= not prescaler23;

end Behavioral;