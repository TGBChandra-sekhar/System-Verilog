//-----INTERFACE------

interface inter;
  logic [2:0]din;
  logic [7:0]dout;
endinterface


//-----GENERATOR-----

class generator;
  mailbox mbx;
  task run();
    for(int i=0;i<8;i++) begin
      logic [2:0]din = i;
      mbx.put(din);
      $display("Generated Test Case: DIN =%3b",din);
    end
  endtask
endclass


//-----DRIVER-----
class driver;
  mailbox mbx;
  virtual inter vif;
  task run();
    forever begin
      logic [2:0]din;
      mbx.get(din);
      vif.din = din;
      #100;
      $display("Driver Inputs: DIN =%3b | DOUT =%8b",vif.din,vif.dout);
    end
  endtask
endclass


//-----TEST BENCH----

module tb;
  mailbox mbx;
  generator gen;
  driver dvr;
  inter aif();
  
  decoder_3_8 DUT (.din(aif.din),.dout(aif.dout));
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars();
    
    gen = new();
    mbx = new();
    dvr = new();
    gen.mbx = mbx;
    dvr.mbx = mbx;
    dvr.vif = aif;
    fork 
      gen.run();
      dvr.run();
    join
  end
endmodule

    
