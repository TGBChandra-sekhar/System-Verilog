//-----INTERFACE-----

interface inter;
  logic din;
  logic [2:0]sel;
  logic [7:0]dout;
  
endinterface


//-----GENERATOR-----

class generator;
  mailbox mbx;
  task run();
    logic din = 1'b1;
    for(int i=0;i<8;i++) begin
      logic [2:0]sel = i;
      mbx.put({din,sel});
      $display("Generated Test Cases: DIN =%0b | SEL =%03b", din,sel);
    end
  endtask
endclass

//-----DRIVER------

class driver;
  mailbox mbx;
  virtual inter vif;
  task run();
    repeat(8) begin
      logic [3:0]temp;
      logic din;
      logic [2:0]sel;
      mbx.get(temp);
      din = temp[3];
      sel = temp[2:0];
      vif.din = din;
      vif.sel = sel;
      #100;
      $display("Input applied to DUT: DIN =%0b | SEL =%3b, DUT Output: DOUT =%8b ", vif.din,vif.sel,vif.dout);
    end
  endtask
endclass


//------TEST BENCH-----

module tb;
  mailbox mbx;
  generator gen;
  driver dvr;
  inter aif();
  
  demux_1_8 DUT (.din(aif.din),.sel(aif.sel),.dout(aif.dout));
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb.DUT);
    
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
    
