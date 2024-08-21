module hA(input a, b, output s0, c0);
//Half Adder
  assign s0 = a ^ b;
  assign c0 = a & b;
endmodule

module fA(input a, b, cin, output s1, c1);
//Full Adder
  assign s1 = a ^ b ^ cin;
  assign c1 = (a & b) | (b & cin) | (a & cin);
endmodule

module wtm(input [7:0] A, B, output [15:0] Z);
//Wallace Tree Multiplier
genvar g;
wire p[7:0][7:0]; // to store partial products
generate
    for(g = 0; g<8; g = g + 1) begin: loop1
      and a0(p[g][0], A[0], B[g]);
		and a1(p[g][1], A[1], B[g]);
		and a2(p[g][2], A[2], B[g]);
		and a3(p[g][3], A[3], B[g]);
		and a4(p[g][4], A[4], B[g]);
		and a5(p[g][5], A[5], B[g]);
		and a6(p[g][6], A[6], B[g]);
		and a7(p[g][7], A[7], B[g]);
    end
endgenerate
assign Z[0] = p[0][0];
wire c[5:0][10:0], s[5:0][10:0]; // to store sum and carry at each stageS
hA h0(p[0][1], p[1][0], Z[1], c[0][1]);

generate
	for(g = 0; g < 6; g = g + 1) begin: loop2
		fA f0(p[0][g+2], p[1][g+1], p[2][g], s[0][g+2], c[0][g+2]);
	end
endgenerate

hA h1(p[1][7], p[2][6], s[0][8], c[0][8]);
hA h2(p[3][1], p[4][0], s[1][1], c[1][1]);

generate
	for(g = 0; g < 6; g = g + 1) begin: loop3
		fA f1(p[3][g+2], p[4][g+1], p[5][g], s[1][g+2], c[1][g+2]);
	end
endgenerate

hA h3(p[4][7], p[5][6], s[1][8], c[1][8]);
hA h4(s[0][2], c[0][1], Z[2], c[2][1]);
fA f2(s[0][3], c[0][2], p[3][0], s[2][2], c[2][2]);

generate
	for(g = 0; g < 5; g = g + 1) begin: loop4
		fA f3(s[0][g+4], c[0][g+3], s[1][g+1], s[2][g+3], c[2][g+3]);
	end
endgenerate

fA f4(p[2][7], c[0][8], s[1][6], s[2][8], c[2][8]);
hA h5(c[1][2], p[6][0], s[3][1], c[3][1]);

generate
	for(g = 0; g < 6; g = g + 1) begin: loop5
		fA f5(c[1][g+3], p[6][g+1], p[7][g], s[3][g+2], c[3][g+2]);
	end
endgenerate

hA h6(p[6][7], p[7][6], s[3][8], c[3][8]);
hA h7(s[2][2], c[2][1], Z[3], c[4][0]);
hA h8(s[2][3], c[2][2], s[4][1], c[4][1]);
fA f6(s[2][4], c[2][3], c[1][1], s[4][2], c[4][2]);

generate
	for(g = 0; g < 4; g = g + 1) begin: loop6
		fA f7(s[2][g+5], c[2][g+4], s[3][g+1], s[4][g+3], c[4][g+3]);
	end
endgenerate

fA f8(s[1][7], c[2][8], s[3][5], s[4][7], c[4][7]);
hA h9(s[1][8], s[3][6], s[4][8], c[4][8]);
hA h10(p[5][7], s[3][7], s[4][9], c[4][9]);

hA h11(s[4][1], c[4][0], Z[4], c[5][0]);
hA h12(s[4][2], c[4][1], s[5][1], c[5][1]);
hA h13(s[4][3], c[4][2], s[5][2], c[5][2]);

generate
	for(g = 0; g < 6; g = g + 1) begin: loop7
		fA f9(s[4][g+4], c[4][g+3], c[3][g+1], s[5][g+3], c[5][g+3]);
	end
endgenerate

fA f10(s[3][8], c[4][9], c[3][7], s[5][9], c[5][9]);
hA h14(p[7][7], c[3][8], s[5][10], Z[15]);

wire [9:0]c_out;

hA h15(s[5][1], c[5][0], Z[5], c_out[0]);

generate
	for(g = 0; g < 9; g = g + 1) begin: loop8
		fA f9(s[5][g+2], c[5][g+1], c_out[g], Z[g+6], c_out[g+1]);
	end
endgenerate

endmodule
