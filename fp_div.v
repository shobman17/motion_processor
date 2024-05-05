`timescale 1ns / 1ps

module fp_div(a, b, q, qFlags);
  parameter NEXP = 5;
  parameter NSIG = 10;
  `include "flags.vh"
  input [NEXP+NSIG:0] a, b;   
  output [NEXP+NSIG:0] q;     
  output [NTYPES-1:0] qFlags; 
  reg [NTYPES-1:0] qFlags;    
  
  wire signed [NEXP+1:0] aExp, bExp, expOut;
  reg signed [NEXP+1:0] normExp, expIn, qExp;
  wire [NSIG:0] aSigWire, bSigWire, sigOut;

  reg signed [NSIG+2:0] aSig, bSig, rSig;

  reg [NSIG+2:0] qSig;
  wire [NTYPES-1:0] aFlags, bFlags;
  wire qSign = a[NEXP+NSIG]^b[NEXP+NSIG];
  wire inexact;
  
  fp_class #(NEXP,NSIG) aClass(a, aExp, aSigWire, aFlags);
  fp_class #(NEXP,NSIG) bClass(b, bExp, bSigWire, bFlags);
  
  reg [NEXP+NSIG:0] alwaysQ; 
  reg si; 
  integer i;

  always @(*)
  begin
    qSig = 0;
    aSig = {2'b00, aSigWire};
    bSig = {2'b00, bSigWire};
    normExp = 0;
        
    qFlags = 0;

    if (aFlags[SNAN] | bFlags[SNAN])
      begin
        {alwaysQ, qFlags} = aFlags[SNAN] ? {a, aFlags} : {b, bFlags};
      end
    else if (aFlags[QNAN] | bFlags[QNAN])
      begin
        {alwaysQ, qFlags} = aFlags[QNAN] ? {a, aFlags} : {b, bFlags};
      end
    else if (aFlags[INFINITY] & bFlags[INFINITY])
      begin
        qFlags[QNAN] = 1;
        alwaysQ = {qSign, {NEXP+NSIG{1'b1}}};
      end
    else if (aFlags[INFINITY])
      begin
        si = qSign;
        alwaysQ = {qSign, {NEXP-1{1'b1}}, ~si, {NSIG{si}}};
        qFlags[INFINITY] = ~si;
        qFlags[NORMAL]   =  si;
      end
    else if (bFlags[INFINITY]) 
      begin
        qFlags[ZERO] = 1;
        alwaysQ = {qSign, {NEXP+NSIG{1'b0}}};
      end
    else if (aFlags[ZERO] & bFlags[ZERO])
      begin
        qFlags[QNAN] = 1;
        alwaysQ = {qSign, {NEXP+NSIG{1'b1}}};
      end
    else if (aFlags[ZERO])
      begin
        qFlags[ZERO] = 1;
        alwaysQ = {qSign, {NEXP+NSIG{1'b0}}};
      end
    else if (bFlags[ZERO])
      begin
        si = qSign;
        alwaysQ = {qSign, {NEXP-1{1'b1}}, ~si, {NSIG{si}}};
        qFlags[INFINITY] = ~si;
        qFlags[NORMAL]   =  si;
      end
    else
      begin
        for (i = 0; i < NSIG+3; i = i + 1)
          begin
            rSig = aSig - bSig;
            qSig = {qSig[NSIG+1:0], ~rSig[NSIG+2]};
            aSig = {(rSig[NSIG+2] ? aSig[NSIG+1:0] : rSig[NSIG+1:0]), 1'b0};
          end
    
        normExp[0] = ~qSig[NSIG+2];
        expIn = aExp - bExp - normExp;
        qSig = qSig << ~qSig[NSIG+2];

        if (~|sigOut)
          begin
            qFlags[ZERO] = 1;
            alwaysQ = 16'b0;
          end
        else if (expOut < EMIN)
          begin
            qFlags[SUBNORMAL] = 1;
            alwaysQ = {qSign, {NEXP{1'b0}}, sigOut[NSIG:1]};
          end
        else if (expOut > EMAX)
          begin
            si = qSign;
            alwaysQ = {qSign, {NEXP-1{1'b1}}, ~si, {NSIG{si}}};
            qFlags[INFINITY] = ~si;
            qFlags[NORMAL]   =  si;
          end
        else
          begin
            qFlags[NORMAL] = 1;
            qExp = expOut + BIAS;

            alwaysQ = {qSign, qExp[NEXP-1:0], sigOut[NSIG-1:0]};
          end

      end
  end
      
  assign q = alwaysQ;
  
endmodule