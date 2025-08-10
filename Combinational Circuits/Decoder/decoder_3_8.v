//-----DECODER 3 to 8

module decoder_3_8(
  input [2:0]din,
  output reg [7:0]dout
);
  always@(*) begin
    dout = 7'd0;
    case(din)
      0: dout[0]=1;
      1: dout[1]=1;
      2: dout[2]=1;
      3: dout[3]=1;
      4: dout[4]=1;
      5: dout[5]=1;
      6: dout[6]=1;
      7: dout[7]=1;
      default : dout = 0;
    endcase
  end
endmodule
  
