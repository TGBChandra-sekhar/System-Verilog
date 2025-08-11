//----PRIORITY ENCODER-----

module prior_encoder #(
  parameter N = 3,
  parameter M = 1 << N //8
)(
  input [M-1:0]din,
  output reg [N-1:0]dout
);
  
  assign dout = (din[M-1]? M-1:
                 din[M-2]? M-2:
                 din[M-3]? M-3:
                 din[M-4]? M-4:
                 din[M-5]? M-5:
                 din[M-6]? M-6:
                 din[M-7]? M-7: 0);
endmodule
