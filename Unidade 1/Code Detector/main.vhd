library ieee;
use ieee.std_logic_1164.all;

entity main is
    port(   clk,Sw: in std_logic;
            Key : in std_logic_vector(3 downto 0);
            HEX: out std_logic_vector(6 downto 0);
            LEDR: out std_logic_vector(1 downto 0);
            Key_out: out std_logic_vector(3 downto 0);
            merda,s_out: out std_logic

    );
end main;

architecture ckt of main is 
type state_type is (W, F1,F2,F3,F4,F5,F6,G);
signal BS_temp: std_logic_vector(3 downto 0);
signal y : state_type:= W ; 
signal clkD,s_in,s_in_temp: std_logic;
signal Key_Sync: std_logic_vector(3 downto 0);
signal HEX_temp: std_logic_vector(3 downto 0);


    component CLK_Div is
    port (  clk_in : in std_logic ;
            clk_out : out std_logic );
    end component ;
	 component seg7 is
		port(A: in std_logic_vector(3 downto 0);
			SD: out std_logic_vector(6 downto 0));
	end component;

    

    component button is
        port (clk , r, bi: in std_logic ;
                bo : out std_logic);
    end component ;

    component HEX_display is
        port ( Hex_in: in std_logic_vector(3 downto 0) ;
                Hex_out : out std_logic_vector(6 downto 0) );
    end component ;

    component FFD is
        port ( clk_ffd ,d ,p ,c: in std_logic ;
                q : out std_logic );
    end component ;

    
    shared variable s: integer range 0 to 1 := 1; 

begin

    box0 : CLK_Div port map(
        clk_in => clk, 
        clk_out => clkD
    );
    box1: button port map(clkD, '0', Key(3),Key_Sync(3) );
    box2: button port map(clkD, '0', Key(2),Key_Sync(2) );
    box3: button port map(clkD, '0', Key(1),Key_Sync(1) );
    box4: button port map(clkD, '0', Key(0),Key_Sync(0) );
    box5: seg7 port map(HEX_temp, HEX);
    --bos6: FFD port map(clk,s_in,'1','1',s);
    process(clkD)
    begin 
    
    
    if ( clkD'event and clkD = '1') then
        case y is
            when W =>
                if Key_Sync = "0111" then y <= F1;
                else y<= W; end if;
            when F1=>
                if Key_Sync(2 downto 0) = "111" then y <= F1; 
                elsif s_in = '0' then y <= W;
                else y <= F2; end if;
            when F2=>
                if Key_Sync(2 downto 0) = "111" then y <= F2; 
                elsif s_in = '0' then y <= W; 
                else y <= F3; end if;
            when F3=>
                if Key_Sync(2 downto 0) = "111" then y <= F3; 
                elsif s_in = '0' then y <= W;
                else y <= F4; end if;
            when F4=>
                if Key_Sync(2 downto 0) = "111" then y <= F4; 
                elsif s_in = '0' then y <= W;
                else y <= F5; end if;
            when F5=>
                if Key_Sync(2 downto 0) = "111" then y <= F5; 
                elsif s_in = '0' then y <= W;
                else y <= F6; end if;
            when F6=>
                if s_in = '1' then y <= G;
                else y <= W; end if;
            when G=> 
                if SW = '0' then y <= G;
                else y <= W; end if; 
            

        end case;
    end if;  

end process;

process (Key_Sync,SW)
begin
    
    case y is
        when W =>
        HEX_temp <= "0000";
            s_in <= '1';
        when F1 => 
        HEX_temp <= "0001";
            s_in <= not( not (Key_Sync(2) and Key_Sync(1) and Key_Sync(0)) and not( Key_Sync(2) and not  Key_Sync(1) and  Key_Sync(0)) );
            --if (not Key_Sync(2 downto 0) = "101" and not Key_Sync(2 downto 0) = "111") then s <= '0'; end if;
        when F2 =>
        HEX_temp <= "0010";
            s_in <= not (  not (Key_Sync(2) and Key_Sync(1) and Key_Sync(0)) and not (Key_Sync(2) and Key_Sync(1) and not Key_Sync(0))  ) ;
            
            --if not Key_Sync(2 downto 0) = "110" then s_in := 0; end if;
        when F3 =>
        HEX_temp <= "0011";
            s_in <= not (  not (Key_Sync(2) and Key_Sync(1) and Key_Sync(0)) and not (not Key_Sync(2) and Key_Sync(1) and  Key_Sync(0))  ) ;

            --if not Key_Sync(2 downto 0) = "011" then s_in := 0; end if;
        when F4 =>
        HEX_temp <= "0100";
            s_in <= not (  not (Key_Sync(2) and Key_Sync(1) and Key_Sync(0)) and not (not Key_Sync(2) and Key_Sync(1) and  Key_Sync(0))  ) ;
        --if not Key_Sync(2 downto 0) = "011" then s_in := 0; end if;
        when F5 =>
        HEX_temp <= "0101";
            s_in <= not (  not (Key_Sync(2) and Key_Sync(1) and Key_Sync(0)) and not ( Key_Sync(2) and not Key_Sync(1) and Key_Sync(0))  ) ;
        --if not Key_Sync(2 downto 0) = "101" then s_in := 0; end if;
        when F6 =>
        HEX_temp <= "0110";
            if s = 1 then LEDR(1) <= '0'; end if;
        when G => 
        HEX_temp <= "0111";
            if SW = '1' then LEDR(1) <= '1'; end if;
    end case ;
end process ;
s_out <= s_in;
Key_out <= Key_Sync;
end ckt;