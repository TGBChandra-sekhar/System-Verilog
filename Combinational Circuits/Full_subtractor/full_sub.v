//DUT
module full_sub(
  input a,b,c,
  output diff,b_out
);
  assign diff = a^b^c;
  assign b_out = (~a&b)|(b&c)|(~a&c);
endmodule


  
    
 
    
      
