//Interface 
interface inter;
  logic [3:0]a,b;
  logic cin;
  logic [3:0]sum;
  logic  cout;
endinterface

//Generator
class generator;
  mailbox mbx;
  task run();
    repeat(8) begin
      logic [3:0] a = $urandom_range(0, 15);
      logic [3:0] b = $urandom_range(0, 15);
      logic       c = $urandom_range(0, 1);

      mbx.put({c,b,a});
      $display("Generated test cases: a=%4b | b=%4b | c=%0b",a,b,c);
  end
  endtask
endclass

//Driver
class driver;
  mailbox mbx;
  virtual inter vif;
  logic [8:0]temp;
  logic [3:0]a,b;
  logic c;
  task run();
    repeat(8) begin
    mbx.get(temp);
    a = temp[3:0];
    b = temp[7:4];
    c = temp[8];
    vif.a = a;
    vif.b = b;
    vif.cin = c ;
      #100;
      $display("Input applied to DUT: a=%4b | b=%4b | cin=%0b, Output of DUT: sum:%4b | cout=%0b", vif.a,vif.b,vif.cin,vif.sum,vif.cout);
    end
  endtask
endclass

//TB

module tb;
  mailbox mbx;
  generator gen;
  driver dvr;
  inter aif();
  
  adder4bit DUT (.a(aif.a),.b(aif.b),.cin(aif.cin),.sum(aif.sum),.cout(aif.cout));
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb.DUT);
    
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

    
    
    
