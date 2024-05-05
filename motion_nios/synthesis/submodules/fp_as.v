`timescale 1ns / 1ps


module fp_as(a, b, control_as ,s, sFlags);
  parameter NEXP = 5;
  parameter NSIG = 10;
  `include "flags.vh"
  localparam CLOG2_NSIG = $clog2(NSIG+1);
  input [NEXP+NSIG:0] a, b;   
  input control_as ;          
  output [NEXP+NSIG:0] s;     
  output [NTYPES-1:0] sFlags; 
  reg [NTYPES-1:0] sFlags;    

  wire aSign = a[NEXP+NSIG];
  wire bSign = b[NEXP+NSIG] ^ control_as ;
  wire signed [NEXP+1:0] aExp, bExp;
  wire [NSIG:0] aSig, bSig;
  wire [NTYPES-1:0] aFlags, bFlags;

  wire signed [NEXP+1:0] expIn, expOut;
  wire [NSIG:0] sigOut;

  fp_class #(NEXP,NSIG) aClass(a, aExp, aSig, aFlags);
  fp_class #(NEXP,NSIG) bClass(b, bExp, bSig, bFlags);

  reg signed [NSIG+1:0] shiftAmt;

  reg signed [NSIG+2:-NSIG-3] augendSig, addendSig, sumSig, absSig, bigSig,
             normSig;
  wire signed [NSIG+2:-NSIG-3] sumSig_wire, absSig_wire;
  assign sumSig_wire = sumSig;
  assign absSig_wire = absSig;

  reg signed [NEXP+1:0] adjExp, bigExp, normExp, biasExp;

  reg sumSign;
  
  wire absSign;

  reg [CLOG2_NSIG-1:0] na;
  reg [NSIG+2:-NSIG-3] mask = ~0;

  wire Cout1;
  reg subtract, e0, si;

  reg [NEXP+NSIG:0] alwaysS; 
  integer i;

  always @(*)
  begin
  
    sFlags = 0;
    subtract = aSign ^ bSign;

    if (aFlags[SNAN] | bFlags[SNAN])
      begin
        {alwaysS, sFlags} = aFlags[SNAN] ? {a, aFlags} : {b, bFlags};
      end
    else if (aFlags[QNAN] | bFlags[QNAN])
      begin
        {alwaysS, sFlags} = aFlags[QNAN] ? {a, aFlags} : {b, bFlags};
      end
    else if (aFlags[ZERO] | bFlags[ZERO])
      begin
        {alwaysS, sFlags} = bFlags[ZERO] ?
                             {a, aFlags} :
                             {{bSign, b[NEXP+NSIG-1:0]}, bFlags};
      end
    else if (aFlags[INFINITY] & bFlags[INFINITY])
      begin
		  si = aSign;    
		  e0 = ~aSign;
		  sFlags[INFINITY]   = ~si;
        sFlags[QNAN]       =  subtract;
        sFlags[NORMAL]     = ~e0;
        alwaysS = {aSign, {{NEXP-1{1'b1}}, e0},{NSIG{si}}};
		  sFlags = aFlags;
      end
    else if (aFlags[INFINITY] | bFlags[INFINITY])
      begin
        {alwaysS, sFlags} = aFlags[INFINITY] ?
                                 {a, aFlags} :
                                 {{bSign, b[NEXP+NSIG-1:0]}, bFlags};
      end
    else 
      begin
        augendSig = 0;
        addendSig = 0;
        na = 0;

        if (aExp < bExp)
          begin
            sumSign = bSign;
            shiftAmt = bExp - aExp;
            augendSig[NSIG:0] = bSig;
            addendSig[NSIG:0] = aSig;
            adjExp = bExp;
          end
        else
          begin
            sumSign = aSign;
            shiftAmt = aExp - bExp;
            augendSig[NSIG:0] = aSig;
            addendSig[NSIG:0] = bSig;
            adjExp = aExp;
          end

        addendSig = addendSig >> ((shiftAmt > NSIG+3) ? NSIG+3 : shiftAmt);

       
        normSig = bigSig;

        for (i = (1 << (CLOG2_NSIG - 1)); i > 0; i = i >> 1)
          begin
            if ((normSig & (mask << (2*NSIG+4 - i))) == 0)
              begin
                normSig = normSig << i;
                na = na | i;
              end
          end

        normExp = bigExp - na;


        if (&na)
          begin
            sFlags[ZERO] = 1;
            alwaysS = 16'b0;
          end
        else if (expOut < EMIN)
          begin
            sFlags[SUBNORMAL] = 1;
            alwaysS = {absSign, {NEXP{1'b0}}, sigOut[NSIG:1]};
          end
        else if (expOut > EMAX)
          begin
			   si = absSign;
            alwaysS = {absSign, {NEXP-1{1'b1}}, ~si, {NSIG{si}}};
            sFlags[INFINITY] = ~si;
            sFlags[NORMAL]   =  si;
          end
        else
          begin
            sFlags[NORMAL] = 1;
            biasExp = expOut + BIAS;

            alwaysS = {absSign, biasExp[NEXP-1:0], sigOut[NSIG-1:0]};
          end
      end
		bigSig = absSig >> absSig[NSIG+1];
		bigExp = adjExp + absSig[NSIG+1];
  end


  padder26 U0(augendSig, addendSig^{2*NSIG+6{subtract}},
                subtract, sumSig_wire, Cout1);

  assign absSign = sumSign ^ sumSig[NSIG+2];

  abs26 U26(sumSig_wire, absSig_wire);


  assign s = alwaysS;

endmodule