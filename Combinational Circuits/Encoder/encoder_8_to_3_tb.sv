//-----INTERFACE-----

interface inter;
  logic [7:0]din;
  logic [2:0]dout;
endinterface

//-----GENERATOR-----

class generator;
  mailbox mbx;
  task run();
    for(int i=0;i<8;i++) begin
      logic [7:0]din = 1 << i; //One hot Pattern
      mbx.put(din);
      $display("Generated Test Cases: DIN=%8b",din);
    end
  endtask
endclass

//------DRIVER------

class driver;
  mailbox mbx;
  virtual inter vif;
  task run();
    forever begin
      logic [7:0]din;
      mbx.get(din);
      vif.din = din;
      #100;
      $display("Driver input: DIN=%8b | DUT Output =%3b",vif.din,vif.dout);
    end
  endtask
endclass


//------TEST BENCH-----

module tb;
  mailbox mbx;
  generator gen;
  driver dvr;
  inter aif();
  
  encoder DUT(.din(aif.din),.dout(aif.dout));
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars;
    
    gen = new();
    dvr = new();
    mbx = new();
    
    gen.mbx = mbx;
    dvr.mbx = mbx;
    dvr.vif = aif;
    fork
      gen.run();
      dvr.run();
    join
  end
endmodule
    
      
