//DUT
module half_adder(
  input a,b,
  output sum,cout
);
  
  assign sum = a^b;
  assign cout = a&b;
endmodule

//Interface
interface inter;
  logic a,b;
  logic sum,cout;
endinterface


