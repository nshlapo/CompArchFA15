`define AND and #50 //simulate physical gate delay
`define OR or #50
`define NOT not #50
`define NOR nor #50
`define NAND nand #50
`define XOR xor #50

module behavioralDecoder(out0,out1,out2,out3, address0,address1, enable);
	output out0, out1, out2, out3;
	input address0, address1;
	input enable;
	assign {out3,out2,out1,out0}=enable<<{address1,address0};
endmodule

module structuralDecoder(out0,out1,out2,out3, address0,address1, enable);
	output out0, out1, out2, out3; //declare vars
	input address0, address1;
	input enable;
	wire notB;
	wire notA;

	`NOT nB (notB, address0); //NOTs
	`NOT nA (notA, address1);

	`AND and0 (out0, notA, notB, enable); //final gates
	`AND and1 (out1, notA, address0, enable);
	`AND and2 (out2, address1, notB, enable);
	`AND and3 (out3, address1, address0, enable);
endmodule

module testDecoder;
	reg addr0, addr1;
	reg enable;
	wire out0,out1,out2,out3;

	//behavioralDecoder decoder (out0,out1,out2,out3,addr0,addr1,enable);
	structuralDecoder decoder (out0,out1,out2,out3,addr0,addr1,enable); // Swap after testing

	initial begin
        $dumpfile("decoder.vcd"); //dump info to create wave propagation later
        $dumpvars(0, testDecoder);

		$display("En A0 A1| O0 O1 O2 O3 | Expected"); //test bench
		enable=0;addr0=0;addr1=0; #1000
		$display("%b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, out0, out1, out2, out3);
		enable=0;addr0=1;addr1=0; #1000
		$display("%b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, out0, out1, out2, out3);
		enable=0;addr0=0;addr1=1; #1000
		$display("%b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, out0, out1, out2, out3);
		enable=0;addr0=1;addr1=1; #1000
		$display("%b  %b  %b |  %b  %b  %b  %b | All false", enable, addr0, addr1, out0, out1, out2, out3);
		enable=1;addr0=0;addr1=0; #1000
		$display("%b  %b  %b |  %b  %b  %b  %b | O0 Only", enable, addr0, addr1, out0, out1, out2, out3);
		enable=1;addr0=1;addr1=0; #1000
		$display("%b  %b  %b |  %b  %b  %b  %b | O1 Only", enable, addr0, addr1, out0, out1, out2, out3);
		enable=1;addr0=0;addr1=1; #1000
		$display("%b  %b  %b |  %b  %b  %b  %b | O2 Only", enable, addr0, addr1, out0, out1, out2, out3);
		enable=1;addr0=1;addr1=1; #1000
		$display("%b  %b  %b |  %b  %b  %b  %b | O3 Only", enable, addr0, addr1, out0, out1, out2, out3);
	end
endmodule
