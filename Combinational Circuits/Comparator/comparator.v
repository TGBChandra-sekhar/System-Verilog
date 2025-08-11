//-----COMPARATOR------

module comparator #(
  parameter N = 4
)(
  input [N-1:0]a,
  input [N-1:0]b,
  output equal,greater,smaller
);
  
  assign equal   = (a == b);
  assign greater = (a > b);
  assign smaller = (a < b);
  
  endmodule
  
  
  
  
