//------Interface------

interface inter;
  logic a,b,c;
  logic sum,cout;
endinterface



//------Generator-----

class generator;
  mailbox mbx;
  task run();
    for(int i=0;i<8;i++) begin
      bit a=i[2]; //MSB
      bit b=i[1]; 
      bit c=i[0]; //LSB
      mbx.put({a,b,c});
      $display("Generated Test Cases:a=%0b,b=%0b,c=%0b",a,b,c);
    end
  endtask
endclass

//------Driver------

class driver;
  mailbox mbx;
  virtual inter vif;
  task run();
    forever begin
      bit [2:0]temp;
      bit a,b,c;
      mbx.get(temp);
      a = temp[2];
      b = temp[1];
      c = temp[0];
      vif.a = a;
      vif.b = b;
      vif.c = c;
      #50;
      $display("Driver Applied Input: a=%0b,b=%0b,c=%0b,Output: sum=%0b,cout=%0b",a,b,c,vif.sum,vif.cout);
    end
  endtask
endclass

//-----Test Bench------

module tb;
  inter aif();
  generator gen;
  driver div;
  mailbox mbx;
  
  full_adder DUT( .a(aif.a),.b(aif.b),.c(aif.c),.sum(aif.sum),.cout(aif.cout));
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0,tb.DUT);
    
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
