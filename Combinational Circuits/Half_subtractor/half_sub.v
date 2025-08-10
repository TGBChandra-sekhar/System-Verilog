//DUT
module half_sub(
  input a,b,
  output dif,bout
);
  
  assign dif = a^b;
  assign bout = ~a&b;
endmodule






  
  
  
  
  
    
