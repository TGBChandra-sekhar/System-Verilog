//Generator
class generator;
  mailbox mbx;
  task run();
    for(int i=0;i<4;i++) begin
      bit a=i[1]; //MSB
      bit b=i[0]; //LSB
    mbx.put({a,b});
    $display("Generated Test Cases:a=%0b,b=%0b",a,b);
    end
  endtask
endclass

//Driver
class driver;
  mailbox mbx;
  virtual inter vif;
  task run();
    forever begin
    bit [1:0]temp;
    bit a,b;
    mbx.get(temp);
    a = temp[1];
    b = temp[0];
    vif.a = a;
    vif.b = b;
    #50;
      $display("Driver Applied Input: a=%0b,b=%0b,Output: sum=%0b,cout=%0b",a,b,vif.sum,vif.cout);
    end
  endtask
endclass

//Interface
interface inter;
  logic a,b;
  logic sum,cout;
endinterface


//Test Bench
module tb;
  inter aif();
  generator gen;
  driver div;
  mailbox mbx;
  
  half_adder DUT( .a(aif.a),.b(aif.b),.sum(aif.sum),.cout(aif.cout));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    gen = new();
    div = new();
    mbx = new();
    gen.mbx=mbx;
    div.mbx=mbx;
    div.vif=aif;
    fork
      gen.run();
      div.run();
    join
  end
endmodule
