//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest),
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);

integer i,j,k,l,m,n,o,p;
    // Initialize register driver signals
    initial begin
        WriteData=32'd0;
        ReadRegister1=5'd0;
        ReadRegister2=5'd0;
        WriteRegister=5'd0;
        RegWrite=0;
        Clk=0;
    end

  // Once 'begintest' is asserted, start running test cases
    always @(posedge begintest) begin
        endtest = 0;
        dutpassed = 1;
        #10;

//---Provided Test Case 1-------------------------------------------------------
    // Write '42' to register 2, verify with Read Ports 1 and 2
    // (Passes because example register file is hardwired to return 42)
    WriteRegister = 5'd2;
    WriteData = 32'd42;
    RegWrite = 1;
    ReadRegister1 = 5'd2;
    ReadRegister2 = 5'd2;
    #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

    // Verify expectations and report test result
    if((ReadData1 != 42) || (ReadData2 != 42)) begin
        dutpassed = 0;	// Set to 'false' on failure
        $display("Provided Test Case 1 Failed");
    end
//------------------------------------------------------------------------------

//---Provided Test Case 2-------------------------------------------------------
    // Write '15' to register 2, verify with Read Ports 1 and 2
    // (Fails with example register file, but should pass with yours)
    WriteRegister = 5'd2;
    WriteData = 32'd15;
    RegWrite = 1;
    ReadRegister1 = 5'd2;
    ReadRegister2 = 5'd2;
    #5 Clk=1; #5 Clk=0;

    if((ReadData1 != 15) || (ReadData2 != 15)) begin
        dutpassed = 0;
        $display("Test Case 2 Failed");
    end
//------------------------------------------------------------------------------

//---Test Case 2----------------------------------------------------------------
    // Write Enable is broken/ignored – Register is always written to
    // Write 63 to all reg's, disable write, write 42 to all reg's, check all reg's

    WriteData = 32'd63;
    RegWrite = 1;

    for(k=0;k<32;k=k+1) begin
        WriteRegister = 5'd0 + k;
        #5 Clk=1; #5 Clk=0;
    end

    WriteData = 32'd42;
    RegWrite = 0;

    for(l=0;l<32;l=l+1) begin
        WriteRegister = 5'd0 + l;
        #5 Clk=1; #5 Clk=0;
    end

begin: break2
    for(m=0;m<32;m=m+1) begin
        ReadRegister1 = 5'd0 + m;
        if(ReadData1 == 42) begin
            dutpassed = 0;  // Set to 'false' on failure
            $display("Test Case 2 Failed");
            disable break2;
        end
    end
end
//------------------------------------------------------------------------------

//---Test Case 3----------------------------------------------------------------
    // Decoder is broken – All registers are written to
    // Loop: Write 63 to all reg's, write 42 to specific reg, check all reg's


begin: break0
    for(p=0;p<32;p=p+1) begin

        WriteData = 32'd63;
        RegWrite = 1;

        for(n=0;n<32;n=n+1) begin
            WriteRegister = 5'd0 + n;
            #5 Clk=1; #5 Clk=0;
        end

        WriteData = 32'd42;
        RegWrite = 1;
        WriteRegister = 5'd0 + p;
        #5 Clk=1; #5 Clk=0;

        for(o=0;o<32;o=o+1) begin

            ReadRegister1 = 5'd0 + o;
            if((ReadData1 == 42) && (p != o)) begin
                dutpassed = 0;  // Set to 'false' on failure
                $display("Test Case 3 Failed");
                disable break0;
            end
        end
    end
end
//------------------------------------------------------------------------------

//---Test Case 4----------------------------------------------------------------
    // Register 0 is actually a register instead of the constant value zero
    // Write 63 to register 0, read reg zero

    WriteRegister = 5'd0;
    WriteData = 32'd63;
    RegWrite = 1;
    ReadRegister1 = 5'd0;
    ReadRegister2 = 5'd0;
    #5 Clk=1; #5 Clk=0;

    if((ReadData1 != 0) || (ReadData2 != 0)) begin
        dutpassed = 0;  // Set to 'false' on failure
        $display("Test Case 4 Failed");
    end
//------------------------------------------------------------------------------

//---Test Case 5----------------------------------------------------------------
    // Port 2 is broken and always reads reg 17
    // Write 63 to all reg's, 42 to reg 17, read all registers

    WriteData = 32'd63;
    RegWrite = 1;

    for(i=0;i<32;i=i+1) begin: case5write
        WriteRegister = 5'd0 + i;
        #5 Clk=1; #5 Clk=0;
    end

    WriteRegister = 5'd17;
    WriteData = 32'd42;
    RegWrite = 1;
    #5 Clk=1; #5 Clk=0;
    ReadRegister2 = 5'd16;

begin: break1
    for(j=0;j<32;j=j+1) begin: case5read
        ReadRegister2 = 5'd0 + j;
        if((ReadData2 == 42) && (j != 17)) begin
          dutpassed = 0;
          $display("Test Case 5 Failed");
          disable break1;
        end
    end
end
//------------------------------------------------------------------------------

    #5 endtest = 1;

end

endmodule