library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder_8bit_Testbench is
end Adder_8bit_Testbench;

architecture behavior of Adder_8bit_Testbench is
  component Adder_8bit
    Port ( A, B : in STD_LOGIC_VECTOR (7 downto 0);
           Cin  : in STD_LOGIC;
           Sum  : out STD_LOGIC_VECTOR (7 downto 0);
           Cout : out STD_LOGIC);
  end component;
  signal A, B : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
  signal Cin  : STD_LOGIC := '0';
  signal Sum  : STD_LOGIC_VECTOR (7 downto 0);
  signal Cout : STD_LOGIC;
  
 begin
  uut: Adder_8bit port map (A, B, Cin, Sum, Cout);

  stim_proc: process
    variable tests, errors : integer := 0;
    procedure check (a_val, b_val, c_val : in integer; hold : in time) is
      variable actual : integer;
	
    begin
      A <= std_logic_vector(to_unsigned(a_val, 8));
      B <= std_logic_vector(to_unsigned(b_val, 8));
      if c_val = 1 then Cin <= '1'; else Cin <= '0'; end if;
      wait for hold;
      actual := to_integer(unsigned(Cout & Sum));
      tests := tests + 1;
      if actual /= a_val + b_val + c_val then
        errors := errors + 1;
		 end if;
      assert actual = a_val + b_val + c_val
        report "Mismatch at A=" & integer'image(a_val) & " B=" & integer'image(b_val)
        severity error;
    end procedure;

  begin
    check(16#00#, 16#00#, 0, 100 ns);
    check(16#01#, 16#01#, 0, 100 ns);
    check(16#64#, 16#32#, 0, 100 ns);
    check(16#7F#, 16#01#, 0, 100 ns);
    check(16#AA#, 16#55#, 0, 100 ns);
    check(16#AA#, 16#55#, 1, 100 ns);
    check(16#FF#, 16#01#, 0, 100 ns);
    check(16#00#, 16#FF#, 1, 100 ns);
    check(16#FF#, 16#FF#, 1, 100 ns);
	 
    for c in 0 to 1 loop
      for i in 0 to 255 loop
        for j in 0 to 255 loop
          check(i, j, c, 10 ns);
        end loop;
      end loop;
    end loop;	
	 
report "Done: " & integer'image(tests) & " vectors, " & integer'image(errors) & " errors";
    wait;
  end process;
end;	 