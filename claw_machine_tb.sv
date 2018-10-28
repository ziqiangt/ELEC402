`timescale 1ns/1ps

module claw_machine_tb(rstn, clk, enable, one, two, catch, refund, strength, balance, strength_LED, balance_units_LED, balance_tens_LED, max_count);

//I/O ports
input  logic		rstn;
input  logic		enable;
input  logic		clk;
input  logic		one;
input  logic		two;
input  logic		catch;
input  logic		refund;		
output logic 	[3:0]	strength;		//up to 9 strength
output logic 	[3:0]	balance;		//up tp 14 dollars refund
output logic 	[6:0]	strength_LED;		//7 segments to display strength
output logic 	[6:0]	balance_units_LED;	//7 segments to display balance
output logic 	[6:0]	balance_tens_LED;	//7 segments to display balance
output logic 	[31:0]	max_count;		//counter
//dut
claw_machine_map dut(
       .rstn(rstn),
       .enable(enable),
       .clk(clk),
       .one(one),
       .two(two),
       .catch(catch),
       .refund(refund),		
       .strength(strength),	
       .balance(balance),
       .strength_LED(strength_LED),
       .balance_units_LED(balance_units_LED),
       .balance_tens_LED(balance_tens_LED),
       .max_count(max_count)	
);

//clock generator
initial begin
	clk <= 0;
	forever begin
		#50 clk = ~clk;	//clk at 100Mhz
	end
end

//reset trigger
initial begin
	#100 rstn <= 0;
	repeat(10) @(posedge clk);
	rstn <= 1;
end

//enable trigger
initial begin
	#100 enable <= 0;
	repeat(10) @(posedge clk);
	enable <= 1;
end
//task for five combinations of sequence_generator
task sequence_generator(input reg[3:0] data_seq);	//data_seq 4 bits which represents signal: one, two, catch, refund seperatly 
	casez(data_seq)
		4'b0000: begin		//No operation
			one <= 0;
			two <= 0;
			catch <= 0;
			refund <= 0;
			@(posedge clk);
		end
		4'b10??: begin		//C1, input one dollar
			one <= 1;	
			two <= 0;
			catch <= data_seq[1];
			refund <= data_seq[0];
			@(posedge clk);
		end
		4'b01??: begin		//C2, input two dollars
			one <= 0;
			two <= 1;
			catch <= data_seq[1];
			refund <= data_seq[1];
			@(posedge clk);
		end
		4'b11??: begin		//C3, input three dollars
			one <= 1;
			two <= 1;
			catch <= data_seq[1];
			refund <= data_seq[0];
			@(posedge clk);
		end
		4'b0010: begin		//C4, catch
			one <= 0;
			two <= 0;
			catch <= 1;
			refund <= 0;
			@(posedge clk);
		end
		4'b0001: begin		//C5, refund
			one <= 0;
			two <= 0;
			catch <= 0;
			refund <= 1;
			@(posedge clk);
		end
		default: begin		//other should maintain as it's current state
			one <= data_seq[3];
			two <= data_seq[2];
			catch <= data_seq[1];
			refund <= data_seq[0];
			@(posedge clk);
		end
	endcase
	$display("current data_seqiton input is one=%b, two=%b, catch=%b, refund=%b", one, two, catch, refund);	
endtask


//test
initial begin
	@(posedge rstn);

	//let's verify the no input function-------------------------------------------------------------------------------
	$display("\nlet's generate 5 IDEL state");	
	repeat(5)	sequence_generator(4'b0000);	//it should stay at the IDEL state 
	if(strength != 4'b0000 && balance != 4'b0000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000, balance=4'b0000\n");
	else
		$display("Congradulations! This function is pass.\n");
	//-----------------------------------------------------------------------------------------------------------------


	//let's verify the one dollar state transfer function--------------------------------------------------------------
	$display("let's generate 10 one dollar and this will refound 10 dollars");	
	repeat(10)	sequence_generator(4'b1000);	//it should branch from IDEL state to S9 state, and refund 10 dollars and return to IDEL
	if(strength != 4'b0000 && balance != 4'b1010)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000, balance=4'b1010\n");
	else
		$display("Congradulations! This function is pass.\n");
	//-----------------------------------------------------------------------------------------------------------------


	//let's verify the two dollars state transfer function-------------------------------------------------------------
	$display("let's generate 5 two dollar and this will refound 10 dollars");	
	repeat(6)	sequence_generator(4'b0100);	//refund 10 dollars and then return to IDLE
	if(strength != 4'b0000 && balance != 4'b1100)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000, balance=4'b1010\n");
	else
		$display("Congradulations! This function is pass.\n");
	//-----------------------------------------------------------------------------------------------------------------


	//let's verify the three dollar state transfer function------------------------------------------------------------
	$display("let's generate 4 three dollar and this will refound 12 dollars");	
	repeat(4)	sequence_generator(4'b1100);	//refund 12 dollars and then return to IDLE
	if(strength != 4'b0000 && balance != 4'b1100)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000, balance=4'b1100\n");
	else
		$display("Congradulations! This function is pass.\n");
	//-----------------------------------------------------------------------------------------------------------------



	
	//let's verify the catch function-----------------------------------------------------------------------------------
	//let's verify the catch function: strength 1----------------------------------------------------------------------
	$display("let's generate catch with strength 1");	
			sequence_generator(4'b1000);		//branch to S1
			sequence_generator(4'b0010);		//strength 1 to catch
	if(strength != 4'b0001 && balance != 4'b0000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0001, balance=4'b0000\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the catch function: strength 2----------------------------------------------------------------------
	$display("let's generate catch with strength 2");	
		 	sequence_generator(4'b0100);		//branch to S2
			sequence_generator(4'b0010);		//strength 2 to catch
	if(strength != 4'b0010 && balance != 4'b0000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0010`, balance=4'b0000\n");
	else
		$display("Congradulations! This function is pass.\n");
		
	//let's verify the catch function: strength 3----------------------------------------------------------------------
	$display("let's generate catch with strength 3");	
	repeat(3) 	sequence_generator(4'b1000);		//branch to S3
			sequence_generator(4'b0010);		//strength 3 to catch
	if(strength != 4'b0011 && balance != 4'b0000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0011`, balance=4'b0000\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the catch function: strength 4----------------------------------------------------------------------
	$display("let's generate catch with strength 4");	
	repeat(2) 	sequence_generator(4'b0100);		//branch to S4
			sequence_generator(4'b0010);		//strength 4 to catch
	if(strength != 4'b0100 && balance != 4'b0000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0100`, balance=4'b0000\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the catch function: strength 5----------------------------------------------------------------------
	$display("let's generate catch with strength 5");	
	repeat(5) 	sequence_generator(4'b1000);		//branch to S5
			sequence_generator(4'b0010);		//strength 5 to catch
	if(strength != 4'b0101 && balance != 4'b0000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0101`, balance=4'b0000\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the catch function: strength 6----------------------------------------------------------------------
	$display("let's generate catch with strength 6");	
	repeat(3) 	sequence_generator(4'b0100);		//branch to S6
			sequence_generator(4'b0010);		//strength 6 to catch
	if(strength != 4'b0110 && balance != 4'b0000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0110`, balance=4'b0000\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the catch function: strength 7----------------------------------------------------------------------
	$display("let's generate catch with strength 7");	
	repeat(7) 	sequence_generator(4'b1000);		//branch to S7
			sequence_generator(4'b0010);		//strength 7 to catch
	if(strength != 4'b0111 && balance != 4'b0000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0111`, balance=4'b0000\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the catch function: strength 8----------------------------------------------------------------------
	$display("let's generate catch with strength 8");	
	repeat(4) 	sequence_generator(4'b0100);		//branch to S8
			sequence_generator(4'b0010);		//strength 8 to catch
	if(strength != 4'b1000 && balance != 4'b0000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b1000`, balance=4'b0000\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the catch function: strength 9----------------------------------------------------------------------
	$display("let's generate catch with strength 9");	
	repeat(9) 	sequence_generator(4'b1000);		//branch to S9
			sequence_generator(4'b0010);		//strength 9 to catch
	if(strength != 4'b1001 && balance != 4'b0000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b1001`, balance=4'b0000\n");
	else
		$display("Congradulations! This function is pass.\n");
	//-----------------------------------------------------------------------------------------------------------------




	//let's verify the refund function-----------------------------------------------------------------------------------
	//let's verify the refund function: balance 1------------------------------------------------------------------------
	$display("let's generate catch with balance 1");	
			sequence_generator(4'b1000);		//branch to S1
			sequence_generator(4'b0001);		//balance 1
	if(strength != 4'b0000 && balance != 4'b0001)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000`, balance=4'b0001\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the refund function: balance 2------------------------------------------------------------------------
	$display("let's generate catch with balance 2");	
		 	sequence_generator(4'b0100);		//branch to S2
			sequence_generator(4'b0001);		//balance 2
	if(strength != 4'b0000 && balance != 4'b0010)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000`, balance=4'b0010\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the refund function: balance 3------------------------------------------------------------------------
	$display("let's generate catch with balance 3");	
	repeat(3) 	sequence_generator(4'b1000);		//branch to S3
			sequence_generator(4'b0001);		//balance 3
	if(strength != 4'b0000 && balance != 4'b0011)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000`, balance=4'b0011\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the refund function: balance 4------------------------------------------------------------------------
	$display("let's generate catch with balance 4");	
	repeat(2) 	sequence_generator(4'b0100);		//branch to S4
			sequence_generator(4'b0001);		//balance 4
	if(strength != 4'b0000 && balance != 4'b0100)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000`, balance=4'b0100\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the refund function: balance 5------------------------------------------------------------------------
	$display("let's generate catch with balance 5");	
	repeat(5) 	sequence_generator(4'b1000);		//branch to S5
			sequence_generator(4'b0001);		//balance 5
	if(strength != 4'b0000 && balance != 4'b0101)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000`, balance=4'b0101\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the refund function: balance 6------------------------------------------------------------------------
	$display("let's generate catch with balance 6");	
	repeat(3) 	sequence_generator(4'b0100);		//branch to S6
			sequence_generator(4'b0001);		//balance 6
	if(strength != 4'b0000 && balance != 4'b0110)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000`, balance=4'b0110\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the refund function: balance 7------------------------------------------------------------------------
	$display("let's generate catch with balance 7");	
	repeat(7) 	sequence_generator(4'b1000);		//branch to S7
			sequence_generator(4'b0001);		//balance 7
	if(strength != 4'b0000 && balance != 4'b0111)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000`, balance=4'b0111\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the refund function: balance 8------------------------------------------------------------------------
	$display("let's generate catch with balance 8");	
	repeat(4) 	sequence_generator(4'b0100);		//branch to S8
			sequence_generator(4'b0001);		//balance 8
	if(strength != 4'b0000 && balance != 4'b1000)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000`, balance=4'b1000\n");
	else
		$display("Congradulations! This function is pass.\n");

	//let's verify the refund function: balance 9------------------------------------------------------------------------
	$display("let's generate catch with balance 9");	
	repeat(9) 	sequence_generator(4'b1000);		//branch to S9
			sequence_generator(4'b0001);		//balance 9
	if(strength != 4'b0000 && balance != 4'b1001)
		$display("Sorry, this function is worng! The supposed output is: strengh=4'b0000`, balance=4'b1001\n");
	else
		$display("Congradulations! This function is pass.\n");
	//-----------------------------------------------------------------------------------------------------------------

	$finish;
end
	 
endmodule
