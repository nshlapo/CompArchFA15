`define AND and #50 //simulate physical gate delay
`define OR or #50
`define NOT not #50
`define NOR nor #50
`define NAND nand #50
`define XOR xor #50


module behavioralFullAdder(sum, carryout, a, b, carryin);
    output sum, carryout;
    input a, b, carryin;
    assign {carryout, sum}=a+b+carryin;
endmodule

module structuralFullAdder(out, carryout, a, b, carryin);
    output out, carryout; //declare vars
    input a, b, carryin;
    wire AxorB, fullAnd, AandB;

    `XOR AxB (AxorB, a, b); //first level gates
    `AND ABand (AandB, a, b);
    `AND Alland (fullAnd, carryin, AxorB);

    `XOR Sout (out, AxorB, carryin); //final gates
    `XOR Cout (carryout, AandB, fullAnd);
endmodule



module testFullAdder;
    reg a, b, carryin;
    wire sum, carryout;

    //behavioralFullAdder adder (sum, carryout, a, b, carryin);
    structuralFullAdder adder (sum, carryout, a, b, carryin);

    initial begin
        $dumpfile("adder.vcd"); //dump info to create wave propagation later
        $dumpvars(0, testFullAdder);

        $display("A B Cin | Sum Cout | Expected"); //test bench
        a=0; b=0; carryin=0; #1000
        $display("%b  %b  %b |  %b  %b  | 0  0", a, b, carryin, sum, carryout);
        a=0; b=0; carryin=1; #1000
        $display("%b  %b  %b |  %b  %b  | 1  0", a, b, carryin, sum, carryout);
        a=0; b=1; carryin=0; #1000
        $display("%b  %b  %b |  %b  %b  | 1  0", a, b, carryin, sum, carryout);
        a=0; b=1; carryin=1; #1000
        $display("%b  %b  %b |  %b  %b  | 0  1", a, b, carryin, sum, carryout);
        a=1; b=0; carryin=0; #1000
        $display("%b  %b  %b |  %b  %b  | 1  0", a, b, carryin, sum, carryout);
        a=1; b=0; carryin=1; #1000
        $display("%b  %b  %b |  %b  %b  | 0  1", a, b, carryin, sum, carryout);
        a=1; b=1; carryin=0; #1000
        $display("%b  %b  %b |  %b  %b  | 0  1", a, b, carryin, sum, carryout);
        a=1; b=1; carryin=1; #1000
        $display("%b  %b  %b |  %b  %b  | 1  1", a, b, carryin, sum, carryout);
    end
endmodule
