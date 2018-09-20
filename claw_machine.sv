module claw_machine(rstn, clk, one, two, catch, refund, strength, balance);

//I/O ports
input  logic		rstn;
input  logic		clk;
input  logic		one;
input  logic		two;
input  logic		catch;
input  logic		refund;		
output logic 	[3:0]	strength;	//up to 9 strength
output logic 	[3:0]	balance;	//up tp 12 dollars refund

//FSM
typedef enum{IDEL, S1, S2, S3, S4, S5, S6, S7, S8, S9} fsmstate_e;	//10 states

fsmstate_e cstate;	//current state
fsmstate_e nstate;	//next state

//intermnal condition signals
wire 			C1;
wire 			C2;
wire 			C3;
wire 			C4;
wire 			C5;

//branch conditions
assign C1 = (one && !two); 				//one dollar
assign C2 = (!one && two);				//two dollars
assign C3 = (one && two);				//three dollars
assign C4 = (catch && !refund && !one && !two);		//catch
assign C5 = (!catch && refund && !one && !two);		//refund

//state transfer - sequencial logic
always_ff @(posedge clk)
begin
	if(~rstn)
	begin
		cstate 	 <= IDEL;
	end
	else
	begin
		cstate <= nstate;
	end
end

//branch conditions - combinational logic
always_comb
begin
	case(cstate)
		//IDEL state
		IDEL:begin
			if(C1) 		begin	nstate = S1;	end
			else if(C2)	begin	nstate = S2;	end 
			else if(C3)	begin	nstate = S3;	end
			else		begin	nstate = IDEL;	end
		end

		//S1 state
		S1:begin
			if(C1)		begin	nstate = S2;	end
			else if(C2)	begin	nstate = S3;	end 
			else if(C3)	begin	nstate = S4;	end
			else if(C4)	begin	nstate = IDEL;	end
			else if(C5)	begin	nstate = IDEL;	end
			else		begin	nstate = S1;	end
		end

		//S2 state
		S2:begin
			if(C1)		begin	nstate = S3;	end
			else if(C2)	begin	nstate = S4;	end 
			else if(C3)	begin	nstate = S5;	end
			else if(C4)	begin	nstate = IDEL;	end
			else if(C5)	begin	nstate = IDEL;	end
			else		begin	nstate = S2;	end
		end

		//S3 state
		S3:begin
			if(C1)		begin	nstate = S4;	end
			else if(C2)	begin	nstate = S5;	end 
			else if(C3)	begin	nstate = S6;	end
			else if(C4)	begin	nstate = IDEL;	end
			else if(C5)	begin	nstate = IDEL;	end
			else		begin	nstate = S3;	end
		end

		//S4 state
		S4:begin
			if(C1)		begin	nstate = S5;	end
			else if(C2)	begin	nstate = S6;	end 
			else if(C3)	begin	nstate = S7;	end
			else if(C4)	begin	nstate = IDEL;	end
			else if(C5)	begin	nstate = IDEL;	end
			else		begin	nstate = S4;	end
		end

		//S5 state
		S5:begin
			if(C1)		begin	nstate = S6;	end
			else if(C2)	begin	nstate = S7;	end 
			else if(C3)	begin	nstate = S8;	end
			else if(C4)	begin	nstate = IDEL;	end
			else if(C5)	begin	nstate = IDEL;	end
			else		begin	nstate = S5;	end
		end

		//S6 state
		S6:begin
			if(C1)		begin	nstate = S7;	end
			else if(C2)	begin	nstate = S8;	end 
			else if(C3)	begin	nstate = S9;	end
			else if(C4)	begin	nstate = IDEL;	end
			else if(C5)	begin	nstate = IDEL;	end
			else		begin	nstate = S6;	end
		end

		//S7 state
		S7:begin
			if(C1)		begin	nstate = S8;	end
			else if(C2)	begin	nstate = S9;	end 
			else if(C3)	begin	nstate = IDEL;	end
			else if(C4)	begin	nstate = IDEL;	end
			else if(C5)	begin	nstate = IDEL;	end
			else		begin	nstate = S7;	end
		end

		//S8 state
		S8:begin
			if(C1)		begin	nstate = S9;	end
			else if(C2)	begin	nstate = IDEL;	end 
			else if(C3)	begin	nstate = IDEL;	end
			else if(C4)	begin	nstate = IDEL;	end
			else if(C5)	begin	nstate = IDEL;	end
			else		begin	nstate = S8;	end
		end

		//S9 state
		S9:begin
			if(C1)		begin	nstate = IDEL;	end
			else if(C2)	begin	nstate = IDEL;	end 
			else if(C3)	begin	nstate = IDEL;	end
			else if(C4)	begin	nstate = IDEL;	end
			else if(C5)	begin	nstate = IDEL;	end
			else		begin	nstate = S9;	end
		end
	
		default:begin
				nstate = IDEL;
		end
			
	endcase
end
//branch output - combinational logic
always_comb
begin
	case(cstate)
		//IDEL state
		IDEL:begin
			if(C1)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C2)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end 
			else if(C3)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
		end


		//S1 state
		S1:begin
			if(C1)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C2)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end 
			else if(C3)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C4)
			begin
				strength = 4'b0001;	//catch with strength level 1
				balance = 4'b0000;
			end
			else if(C5)
			begin
				strength = 4'b0000;	
				balance = 4'b0001;	//refund money 1 dollar
			end
			else
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
		end

		//S2 state
		S2:begin
			if(C1)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C2)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end 
			else if(C3)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C4)
			begin
				strength = 4'b0010;	//catch with strength level 2
				balance = 4'b0000;
			end
			else if(C5)
			begin
				strength = 4'b0000;	
				balance = 4'b0010;	//refund money 2 dollars
			end
			else
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
		end


		//S3 state
		S3:begin
			if(C1)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C2)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end 
			else if(C3)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C4)
			begin
				strength = 4'b0011;	//catch with strength level 3
				balance = 4'b0000;
			end
			else if(C5)
			begin
				strength = 4'b0000;	
				balance = 4'b0011;	//refund money 3 dollars
			end
			else
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
		end

		//S4 state
		S4:begin
			if(C1)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C2)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end 
			else if(C3)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C4)
			begin
				strength = 4'b0100;	//catch with strength level 4
				balance = 4'b0000;
			end
			else if(C5)
			begin
				strength = 4'b0000;	
				balance = 4'b0100;	//refund money 4 dollars
			end
			else
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
		end

		//S5 state
		S5:begin
			if(C1)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C2)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end 
			else if(C3)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C4)
			begin
				strength = 4'b0101;	//catch with strength level 5
				balance = 4'b0000;
			end
			else if(C5)
			begin
				strength = 4'b0000;	
				balance = 4'b0101;	//refund money 5 dollars
			end
			else
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
		end

		//S6 state
		S6:begin
			if(C1)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C2)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end 
			else if(C3)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C4)
			begin
				strength = 4'b0110;	//catch with strength level 6
				balance = 4'b0000;
			end
			else if(C5)
			begin
				strength = 4'b0000;	
				balance = 4'b0110;	//refund money 6 dollars
			end
			else
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
		end
		//S7 state
		S7:begin
			if(C1)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C2)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end 
			else if(C3)
			begin
				strength = 4'b0000;
				balance = 4'b1010;	//over the limits, refund all money: 10 dollars
			end
			else if(C4)
			begin
				strength = 4'b0111;	//catch with strength level 7
				balance = 4'b0000;
			end
			else if(C5)
			begin
				strength = 4'b0000;	
				balance = 4'b0111;	//refund money 7 dollars
			end
			else
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
		end

		//S8 state
		S8:begin
			if(C1)
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
			else if(C2)
			begin
				strength = 4'b0000;
				balance = 4'b1010;	//over the limits, refund all money: 10 dollars
			end 
			else if(C3)
			begin
				strength = 4'b0000;
				balance = 4'b1011;	//over the limits, refund all money: 11 dollars
			end
			else if(C4)
			begin
				strength = 4'b1000;	//catch with strength level 8
				balance = 4'b0000;
			end
			else if(C5)
			begin
				strength = 4'b0000;	
				balance = 4'b1000;	//refund money 8 dollars
			end
			else
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
		end


		//S9 state
		S9:begin
			if(C1)
			begin
				strength = 4'b0000;
				balance = 4'b1010;	//over limits, refund all money: 10 dollars 	
			end
			else if(C2)
			begin
				strength = 4'b0000;
				balance = 4'b1011;	//over limits, refund all money: 11 dollars
			end 
			else if(C3)
			begin
				strength = 4'b0000;
				balance = 4'b1100;	//over the limits, refund all money: 12 dollars
			end
			else if(C4)
			begin
				strength = 4'b1001;	//catch with strength level 9
				balance = 4'b0000;
			end
			else if(C5)
			begin
				strength = 4'b0000;	
				balance = 4'b1001;	//refund money 9 dollars
			end
			else
			begin
				strength = 4'b0000;
				balance = 4'b0000;
			end
		end
	
		default:begin
				strength = 4'b0000;
				balance = 4'b0000;
		end
			
	endcase
end
endmodule
