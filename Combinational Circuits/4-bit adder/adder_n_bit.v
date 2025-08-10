//N-bit adder
module adder #(
    parameter N = 4
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    input          cin,
    output [N-1:0] sum,
    output         cout
);
    assign {cout, sum} = a + b + cin;
endmodule

