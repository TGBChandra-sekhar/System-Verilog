//------Interface-----

interface inter;
  logic [7:0]din;
  logic [2:0]sel;
  logic y;
endinterface

//-----Generator-----

class generator;
  mailbox mbx;
  task run();
    for(int i=0;i<50;i=i+5) begin
      logic [7:0]din = i;
      logic [2:0]sel = $urandom_range(0, 7);
      mbx.put({sel,din});
      $display("Generated Test cases: INPUT=%8b | SEL=%3b",din,sel);
    end
  endtask
endclass

//----Driver-----

class driver;
  mailbox mbx;
  virtual inter vif;
  task run();
    forever begin
      logic [10:0]temp;
      logic [7:0]din;
      logic [2:0]sel;
      mbx.get(temp);
      din = temp[7:0];
      sel = temp[10:8];
      vif.din = din;
      vif.sel = sel;
      #100;
      $display("Driver Input: %8b | sel=%3b, DUT output: Y=%1b",vif.din,vif.sel,vif.y);
    end
  endtask
endclass

//----Test Bench----

module tb;
  mailbox mbx;
  generator gen;
  driver dvr;
  inter aif();
  
  mux_8to1 DUT (.din(aif.din),.sel(aif.sel),.y(aif.y));
  
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
  
      
      
