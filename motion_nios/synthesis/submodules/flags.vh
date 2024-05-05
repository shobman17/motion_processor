localparam NORMAL    = 0;
localparam SUBNORMAL = NORMAL + 1;
localparam ZERO      = SUBNORMAL + 1;
localparam INFINITY  = ZERO + 1;
localparam QNAN      = INFINITY + 1;
localparam SNAN      = QNAN + 1;
localparam NTYPES    = SNAN + 1;

localparam BIAS = ((1 << (NEXP - 1)) - 1); // IEEE 754, section 3.3
localparam EMAX = BIAS; // IEEE 754, section 3.3
localparam EMIN = (1 - EMAX); // IEEE 754, section 3.3
