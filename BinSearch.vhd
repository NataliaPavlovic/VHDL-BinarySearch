-- Natalia P.
-- 11 bit binary search

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_Std.ALL;

entity BinSearch is
Generic(width: integer := 11);
Port (reset: in std_logic;
      
      clk: in std_logic;
      
      compareReturn: in std_logic;                              -- input from the comparator circuit
      
      dutyCycle: out std_logic_vector (width-1 downto 0);       -- the 11 bit binary vector dudtyCycle sent to a 
                                                                -- DAC VHDL module
      
      result: out std_logic_vector (width-1 downto 0)           -- 11 bit binary vector result of binary search
);

end BinSearch;

architecture Behavioral of BinSearch is

-- signals
signal i_dutyCycle: std_logic_vector(width-1 downto 0);

signal i_result: std_logic_vector(width-1 downto 0);

signal index: integer;                                          -- counts down from width-2 to 0 to access vector elements

signal finalValue: std_logic;                                   -- finalValue ='0' when doing binary search. 
                                                                -- finalValue ='1' when final value is reached.

signal numEdges: std_logic_vector (14 downto 0);                -- number of rising edges before a change in dutyCycle


begin

binary: process (clk, reset)
begin

if(reset = '1')then
    index <= width-2;                                           -- width-2 is used for index starting value because dutyCycle
                                                                -- starts at 10000000000, so start at 2nd element from left
    finalValue <='0';
    numEdges <= (others=>'0');
    i_dutyCycle<="10000000000";
elsif(rising_edge(clk)) then
      if(numEdges = "111111111111111") then                     -- The value chosen for number of edges before a change in 
                                                                -- dutyCycle occurs
              
            if (finalValue = '0') then                          -- if finalValue is 0, the final value was not reached yet 
                                                                -- and the binary search is still happening                                             
                    if(index = -1) then
                        index <= width-2;
                        finalValue <= '1';
                    else                                        -- if index is not -1 (not reached end of vector), decrement                                     
                        index <= index-1;                       -- index and set element in this index to '1'.  
                        i_dutyCycle(index)<='1';
                    end if;
                    if(compareReturn = '0') then                -- if compareReturn is '0', save '0' into previous index element
                       i_dutyCycle(index+1)<='0';
                    end if;      
             elsif (finalValue = '1') then                      -- if finalValue is 1, copy the binary vector into i_result 
                        index <= width-2;
                        finalValue <= '0';
                        i_result <= i_dutyCycle;
                        i_dutyCycle <= "10000000000";
             end if;
             numEdges <= (others=>'0');                                   
     else 
     numEdges<=std_logic_vector(unsigned (numEdges)+1);
     end if;
end if;

end process binary;

dutyCycle<=i_dutyCycle;   
result <= i_result;

end Behavioral;
