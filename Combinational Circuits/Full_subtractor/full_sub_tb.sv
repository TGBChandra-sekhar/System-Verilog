//Interface
interface inter;
  logic a,b,c,diff,b_out;
endinterface

//Generator
class generator;
  mailbox mbx;
  task run();
    for(int i=0;i<8;i++) begin
      logic a = i[2]; //MSB
      logic b = i[1];
      logic c = i[0]; //LSB
      mbx.put({a,b,c});
      $display("Generated Test Case: a=%0b | b=%0b | c=%0b", a,b,c);
    end
  endtask
endclass

//Driver
class driver;
  mailbox mbx;
  virtual inter vif; //virtual interface
  task run();
    forever begin
      logic [2:0]temp;
      logic a,b,c;
      mbx.get(temp);
      a = temp[2];
      b = temp[1];
      c = temp[0];
      vif.a = a;
      vif.b = b;
      vif.c = c;
      #50;
      $display("Input applied to DUT: a=%0b | b=%0b | c=%0b, Output of DUT: diff:%0b | b_out=%0b", vif.a,vif.b,vif.c,vif.diff,vif.b_out);
    end
  endtask
endclass

//TB
module tb;
  mailbox mbx;
  generator gen;
  driver div;
  inter aif();
  
  full_sub DUT(.a(aif.a),.b(aif.b),.c(aif.c),.diff(aif.diff),.b_out(aif.b_out));
  
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars;
    
    gen = new();
    div = new(); 
    mbx = new(); 
    gen.mbx = mbx;
    div.mbx = mbx;
    div.vif = aif;
    fork
      gen.run();
      div.run();
    join
  end
endmodule
  
