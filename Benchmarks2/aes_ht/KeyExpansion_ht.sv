module KeyExpansion_ht #(parameter COUNTER = 0)(  
	input     [127:0]	key,
	output    [127:0]	nextKey
);

  parameter NR = 10;
  parameter [7:0] RCon[0:NR]   = '{8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h1b, 8'h36, 8'h00};


  wire      [31:0]           w[3:0];
  wire      [31:0]           wNext[3:0];

  wire      [31:0]           t;
  wire      [31:0]           rotWord;
  wire      [31:0]           Q;
  wire      [95:0]           unused;

  genvar i;

  generate 
  for(i=0;i<4;i=i+1) begin:EXPANDKEY
    assign w[i] = (COUNTER<10)?key[32*(i+1)-1:32*i]:32'b0;
    assign nextKey[32*(i+1)-1:32*i] = wNext[i];
  end
  endgenerate


  generate 
  for(i=0;i<4;i=i+1) begin:NR_W
    if(i==0) begin:FIRST
      assign wNext[i] = w[i] ^ t;
    end else begin:THEN
      assign wNext[i] = w[i] ^ wNext[i-1];
    end
  end
  endgenerate


  
  assign rotWord = {w[3][7:0], w[3][31:8]};
  SubBytes a(.x({rotWord, 96'b0}), .z({Q, unused}));
  assign t = {Q[31:8], RCon[COUNTER] ^ Q[7:0]};
  

endmodule


