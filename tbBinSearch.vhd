library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tbBinSearch is
--  Port ( );
end tbBinSearch;

architecture Behavioral of tbBinSearch is

component BinSearch
 Generic( width: integer := 11);
 Port (  reset: in std_logic;
        clk: in std_logic;
        compareReturn: in std_logic;
        dutyCycle: out std_logic_vector (width-1 downto 0);
        result: out std_logic_vector (width-1 downto 0)
);
end component;

-- signals
signal reset: std_logic:='0';
signal clk: std_logic:='0';
signal compareReturn: std_logic:='0';
signal dutyCycle: std_logic_vector (11-1 downto 0);
signal result: std_logic_vector (11-1 downto 0);

constant clk_period : time := 10 ns;

begin
    uut: BinSearch
    GENERIC MAP (width=> 11)
    PORT MAP (reset => reset,
               clk => clk,
               compareReturn => compareReturn,
               dutyCycle => dutyCycle,
               result => result
    );
    clk_process :process
     begin
       clk <= '0';
       wait for clk_period/2;
       clk <= '1';
       wait for clk_period/2;
     end process;
    
   -- Stimulus process
    stim_proc: process
    begin        
       -- hold reset state for 100 ns.
       wait for clk_period;    
         reset <= '1';
       wait for 3*clk_period;
         reset <= '0';
       -- insert stimulus here 
       wait;
    end process;
 
 compareProc: process
 begin
   wait for 100*clk_period;
        compareReturn <= '0';
   wait for 100*clk_period;
        compareReturn <= '1';
   end process;

end Behavioral;
