//-----INTERFACE-----

interface inter;
  logic [3:0]a,b;
  logic equal,greater,smaller;
  
endinterface


//-----GENERATOR------

class generator;
  mailbox mbx;
  task run();
    repeat(10) begin
      logic [3:0]a = $urandom_range(0 ,15);
      logic [3:0]b = $urandom_range(0 ,15);
      mbx.put({a,b});
      $display("Generated test cases: a =%4b | b =%4b", a,b);
    end
  endtask
endclass


//------DRIVER------

class driver;
  mailbox mbx;
  virtual inter vif;
  task run();
    $display("|   A   |   B   |   A>B  |   A<B  |   A=B  |");
    $display("-------------------------------------------");
  forever begin
    logic [7:0]temp;
    logic [3:0]a,b;
    mbx.get(temp);
    b = temp[3:0];
    a = temp[7:4];
    vif.a = a;
    vif.b = b;
    #100;
    
    $display("|  %4b |  %4b |    %0b   |    %0b   |    %0b   |", vif.a,vif.b,vif.greater,vif.smaller,vif.equal);
    end
    $display("-------------------------------------------");
    endtask
endclass
    
      
//-----TEST BENCH-----

module tb;
  mailbox mbx;
  generator gen;
  driver dvr;
  inter aif();
  
  comparator DUT (.a(aif.a),.b(aif.b),.equal(aif.equal),.greater(aif.greater),.smaller(aif.smaller));
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars();
    
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
  
  
