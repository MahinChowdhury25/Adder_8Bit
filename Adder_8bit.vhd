library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder_8bit is
  Port ( A, B : in STD_LOGIC_VECTOR (7 downto 0);
         Cin  : in STD_LOGIC;
         Sum  : out STD_LOGIC_VECTOR (7 downto 0);
         Cout : out STD_LOGIC);
end Adder_8bit;

architecture Structural of Adder_8bit is
  component Full_Adder
    Port ( A, B, C, Cin : in STD_LOGIC;
           Sum, Cout    : out STD_LOGIC);
  end component;
  signal carry : STD_LOGIC_VECTOR (8 downto 0);
begin
  carry(0) <= Cin;
  gen_fa : for i in 0 to 7 generate
    FA_i : Full_Adder port map (A(i), B(i), '0', carry(i), Sum(i), carry(i+1));
  end generate;
  Cout <= carry(8);
end Structural;