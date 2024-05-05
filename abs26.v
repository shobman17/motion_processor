`timescale 1ns / 1ps

module abs26(A, S);
  localparam N = 26;
  input [N-1:0] A;
  output [N-1:0] S;
  // All Pi:i values are equal to xorA[i]
  wire [N-1:0] xorA = A ^ {N{A[N-1]}};
  // G[i] is an alias for Gi:i
  wire [-1:-1] G;

  assign G[-1] = A[N-1];

  assign S[0] = xorA[0] ^ G[-1];

  wire \G0:-1 ;

  assign \G0:-1  = xorA[0]  & G[-1] ;

  assign S[1] = xorA[1] ^ \G0:-1 ;

  wire \G1:-1 ;

  assign \G1:-1  = xorA[1]  & \G0:-1  ;

  assign S[2] = xorA[2] ^ \G1:-1 ;

  wire \P2:1 ;

  assign \P2:1  = xorA[2] & xorA[1] ;

  wire \G2:-1 ;

  assign \G2:-1  = \P2:1   & \G0:-1  ;

  assign S[3] = xorA[3] ^ \G2:-1 ;

  wire \G3:-1 ;

  assign \G3:-1  = xorA[3]  & \G2:-1  ;

  assign S[4] = xorA[4] ^ \G3:-1 ;

  wire \P4:3 ;

  assign \P4:3  = xorA[4] & xorA[3] ;

  wire \G4:-1 ;

  assign \G4:-1  = \P4:3   & \G2:-1  ;

  assign S[5] = xorA[5] ^ \G4:-1 ;

  wire \P5:3 ;

  assign \P5:3  = xorA[5] & \P4:3  ;

  wire \G5:-1 ;

  assign \G5:-1  = \P5:3   & \G2:-1  ;

  assign S[6] = xorA[6] ^ \G5:-1 ;

  wire \P6:5 ;

  assign \P6:5  = xorA[6] & xorA[5] ;

  wire \P6:3 ;

  assign \P6:3  = \P6:5  & \P4:3  ;

  wire \G6:-1 ;

  assign \G6:-1  = \P6:3   & \G2:-1  ;

  assign S[7] = xorA[7] ^ \G6:-1 ;

  wire \G7:-1 ;

  assign \G7:-1  = xorA[7]  & \G6:-1  ;

  assign S[8] = xorA[8] ^ \G7:-1 ;

  wire \P8:7 ;

  assign \P8:7  = xorA[8] & xorA[7] ;

  wire \G8:-1 ;

  assign \G8:-1  = \P8:7   & \G6:-1  ;

  assign S[9] = xorA[9] ^ \G8:-1 ;

  wire \P9:7 ;

  assign \P9:7  = xorA[9] & \P8:7  ;

  wire \G9:-1 ;

  assign \G9:-1  = \P9:7   & \G6:-1  ;

  assign S[10] = xorA[10] ^ \G9:-1 ;

  wire \P10:9 ;

  assign \P10:9  = xorA[10] & xorA[9] ;

  wire \P10:7 ;

  assign \P10:7  = \P10:9  & \P8:7  ;

  wire \G10:-1 ;

  assign \G10:-1  = \P10:7   & \G6:-1  ;

  assign S[11] = xorA[11] ^ \G10:-1 ;

  wire \P11:7 ;

  assign \P11:7  = xorA[11] & \P10:7  ;

  wire \G11:-1 ;

  assign \G11:-1  = \P11:7   & \G6:-1  ;

  assign S[12] = xorA[12] ^ \G11:-1 ;

  wire \P12:11 ;

  assign \P12:11  = xorA[12] & xorA[11] ;

  wire \P12:7 ;

  assign \P12:7  = \P12:11  & \P10:7  ;

  wire \G12:-1 ;

  assign \G12:-1  = \P12:7   & \G6:-1  ;

  assign S[13] = xorA[13] ^ \G12:-1 ;

  wire \P13:11 ;

  assign \P13:11  = xorA[13] & \P12:11  ;

  wire \P13:7 ;

  assign \P13:7  = \P13:11  & \P10:7  ;

  wire \G13:-1 ;

  assign \G13:-1  = \P13:7   & \G6:-1  ;

  assign S[14] = xorA[14] ^ \G13:-1 ;

  wire \P14:13 ;

  assign \P14:13  = xorA[14] & xorA[13] ;

  wire \P14:11 ;

  assign \P14:11  = \P14:13  & \P12:11  ;

  wire \P14:7 ;

  assign \P14:7  = \P14:11  & \P10:7  ;

  wire \G14:-1 ;

  assign \G14:-1  = \P14:7   & \G6:-1  ;

  assign S[15] = xorA[15] ^ \G14:-1 ;

  wire \G15:-1 ;

  assign \G15:-1  = xorA[15]  & \G14:-1  ;

  assign S[16] = xorA[16] ^ \G15:-1 ;

  wire \P16:15 ;

  assign \P16:15  = xorA[16] & xorA[15] ;

  wire \G16:-1 ;

  assign \G16:-1  = \P16:15   & \G14:-1  ;

  assign S[17] = xorA[17] ^ \G16:-1 ;

  wire \P17:15 ;

  assign \P17:15  = xorA[17] & \P16:15  ;

  wire \G17:-1 ;

  assign \G17:-1  = \P17:15   & \G14:-1  ;

  assign S[18] = xorA[18] ^ \G17:-1 ;

  wire \P18:17 ;

  assign \P18:17  = xorA[18] & xorA[17] ;

  wire \P18:15 ;

  assign \P18:15  = \P18:17  & \P16:15  ;

  wire \G18:-1 ;

  assign \G18:-1  = \P18:15   & \G14:-1  ;

  assign S[19] = xorA[19] ^ \G18:-1 ;

  wire \P19:15 ;

  assign \P19:15  = xorA[19] & \P18:15  ;

  wire \G19:-1 ;

  assign \G19:-1  = \P19:15   & \G14:-1  ;

  assign S[20] = xorA[20] ^ \G19:-1 ;

  wire \P20:19 ;

  assign \P20:19  = xorA[20] & xorA[19] ;

  wire \P20:15 ;

  assign \P20:15  = \P20:19  & \P18:15  ;

  wire \G20:-1 ;

  assign \G20:-1  = \P20:15   & \G14:-1  ;

  assign S[21] = xorA[21] ^ \G20:-1 ;

  wire \P21:19 ;

  assign \P21:19  = xorA[21] & \P20:19  ;

  wire \P21:15 ;

  assign \P21:15  = \P21:19  & \P18:15  ;

  wire \G21:-1 ;

  assign \G21:-1  = \P21:15   & \G14:-1  ;

  assign S[22] = xorA[22] ^ \G21:-1 ;

  wire \P22:21 ;

  assign \P22:21  = xorA[22] & xorA[21] ;

  wire \P22:19 ;

  assign \P22:19  = \P22:21  & \P20:19  ;

  wire \P22:15 ;

  assign \P22:15  = \P22:19  & \P18:15  ;

  wire \G22:-1 ;

  assign \G22:-1  = \P22:15   & \G14:-1  ;

  assign S[23] = xorA[23] ^ \G22:-1 ;

  wire \P23:15 ;

  assign \P23:15  = xorA[23] & \P22:15  ;

  wire \G23:-1 ;

  assign \G23:-1  = \P23:15   & \G14:-1  ;

  assign S[24] = xorA[24] ^ \G23:-1 ;

  wire \P24:23 ;

  assign \P24:23  = xorA[24] & xorA[23] ;

  wire \P24:15 ;

  assign \P24:15  = \P24:23  & \P22:15  ;

  wire \G24:-1 ;

  assign \G24:-1  = \P24:15   & \G14:-1  ;

  assign S[25] = xorA[25] ^ \G24:-1 ;

endmodule