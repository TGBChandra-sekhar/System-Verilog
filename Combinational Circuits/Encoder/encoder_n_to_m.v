//---- 2*N TO N ENCODER-----

module encoder #(
  parameter N_SEL = 3,
  parameter M_INPUTS = 1 << N_SEL // 1 shifted left by N bits
)(
  input [M_INPUTS-1:0]din,
  output [N_SEL-1:0]dout
);
  
  assign dout = (din[0] ? 0 : 0) |
               (din[1] ? 1 : 0) |
               (din[2] ? 2 : 0) |
               (din[3] ? 3 : 0) |
               (din[4] ? 4 : 0) |
               (din[5] ? 5 : 0) |
               (din[6] ? 6 : 0) |
               (din[7] ? 7 : 0); 
endmodule
