# Project 2: Boolean Arithmetic

### HalfAdder

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/2/HalfAdder.hdl
/**
 * Computes the sum of two bits.
 */
CHIP HalfAdder {
    IN a, b;    // 1-bit inputs
    OUT sum,    // Right bit of a + b 
        carry;  // Left bit of a + b

    PARTS:
    Xor(a= a, b= b, out= sum);
    And(a= a, b= b, out= carry);
}
```

### FullAdder

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/2/FullAdder.hdl
/**
 * Computes the sum of three bits.
 */
CHIP FullAdder {
    IN a, b, c;  // 1-bit inputs
    OUT sum,     // Right bit of a + b + c
        carry;   // Left bit of a + b + c

    PARTS:
    HalfAdder(a= a, b= b, sum= sum1, carry= carry1);
    HalfAdder(a= c, b= sum1 , sum= sum , carry= carry2);
    Or(a= carry1, b= carry2, out= carry);
}
```

### Add16

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/2/Add16.hdl
/**
 * Adds two 16-bit numbers.
 * The most significant carry bit is ignored.
 */
CHIP Add16 {
    IN a[16], b[16];
    OUT out[16];

    PARTS:
    HalfAdder(a=a[0], b=b[0], sum=out[0], carry=c1);
    FullAdder(a=a[1], b=b[1], c=c1, sum=out[1], carry=c2);
    FullAdder(a=a[2], b=b[2], c=c2, sum=out[2], carry=c3);
    FullAdder(a=a[3], b=b[3], c=c3, sum=out[3], carry=c4);
    FullAdder(a=a[4], b=b[4], c=c4, sum=out[4], carry=c5);
    FullAdder(a=a[5], b=b[5], c=c5, sum=out[5], carry=c6);
    FullAdder(a=a[6], b=b[6], c=c6, sum=out[6], carry=c7);
    FullAdder(a=a[7], b=b[7], c=c7, sum=out[7], carry=c8);
    FullAdder(a=a[8], b=b[8], c=c8, sum=out[8], carry=c9);
    FullAdder(a=a[9], b=b[9], c=c9, sum=out[9], carry=c10);
    FullAdder(a=a[10], b=b[10], c=c10, sum=out[10], carry=c11);
    FullAdder(a=a[11], b=b[11], c=c11, sum=out[11], carry=c12);
    FullAdder(a=a[12], b=b[12], c=c12, sum=out[12], carry=c13);
    FullAdder(a=a[13], b=b[13], c=c13, sum=out[13], carry=c14);
    FullAdder(a=a[14], b=b[14], c=c14, sum=out[14], carry=c15);
    FullAdder(a=a[15], b=b[15], c=c15, sum=out[15], carry=ignore);
}
```

### Inc16 using HalfAdders

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/2/Inc16.hdl
/**
 * Incrementer:
 * out = in + 1
 */
CHIP Inc16 {
    IN in[16];
    OUT out[16];

    PARTS:
    HalfAdder(a=in[0], b=true, sum=out[0], carry=c1);
    HalfAdder(a=in[1], b=c1, sum=out[1], carry=c2);
    HalfAdder(a=in[2], b=c2, sum=out[2], carry=c3);
    HalfAdder(a=in[3], b=c3, sum=out[3], carry=c4);
    HalfAdder(a=in[4], b=c4, sum=out[4], carry=c5);
    HalfAdder(a=in[5], b=c5, sum=out[5], carry=c6);
    HalfAdder(a=in[6], b=c6, sum=out[6], carry=c7);
    HalfAdder(a=in[7], b=c7, sum=out[7], carry=c8);
    HalfAdder(a=in[8], b=c8, sum=out[8], carry=c9);
    HalfAdder(a=in[9], b=c9, sum=out[9], carry=c10);
    HalfAdder(a=in[10], b=c10, sum=out[10], carry=c11);
    HalfAdder(a=in[11], b=c11, sum=out[11], carry=c12);
    HalfAdder(a=in[12], b=c12, sum=out[12], carry=c13);
    HalfAdder(a=in[13], b=c13, sum=out[13], carry=c14);
    HalfAdder(a=in[14], b=c14, sum=out[14], carry=c15);
    HalfAdder(a=in[15], b=c15, sum=out[15], carry=ignore);
}
```

### Inc16 using Add16

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/2/Inc16.hdl
/**
 * Incrementer:
 * out = in + 1
 */
CHIP Inc16 {
    IN in[16];
    OUT out[16];

    PARTS:
    Add16(
        a=in,
        b[0]=true,
        b[1]=false,
        b[2]=false,
        b[3]=false,
        b[4]=false,
        b[5]=false,
        b[6]=false,
        b[7]=false,
        b[8]=false,
        b[9]=false,
        b[10]=false,
        b[11]=false,
        b[12]=false,
        b[13]=false,
        b[14]=false,
        b[15]=false,
        out=out
    );
}
```

### ALU

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/2/ALU.hdl
/**
 * ALU (Arithmetic Logic Unit):
 * Computes out = one of the following functions:
 *                0, 1, -1,
 *                x, y, !x, !y, -x, -y,
 *                x + 1, y + 1, x - 1, y - 1,
 *                x + y, x - y, y - x,
 *                x & y, x | y
 * on the 16-bit inputs x, y,
 * according to the input bits zx, nx, zy, ny, f, no.
 * In addition, computes the two output bits:
 * if (out == 0) zr = 1, else zr = 0
 * if (out < 0)  ng = 1, else ng = 0
 */
// Implementation: Manipulates the x and y inputs
// and operates on the resulting values, as follows:
// if (zx == 1) sets x = 0        // 16-bit constant
// if (nx == 1) sets x = !x       // bitwise not
// if (zy == 1) sets y = 0        // 16-bit constant
// if (ny == 1) sets y = !y       // bitwise not
// if (f == 1)  sets out = x + y  // integer 2's complement addition
// if (f == 0)  sets out = x & y  // bitwise and
// if (no == 1) sets out = !out   // bitwise not

CHIP ALU {
    IN
        x[16], y[16],  // 16-bit inputs
        zx, // zero the x input?
        nx, // negate the x input?
        zy, // zero the y input?
        ny, // negate the y input?
        f,  // compute (out = x + y) or (out = x & y)?
        no; // negate the out output?
    OUT
        out[16], // 16-bit output
        zr,      // if (out == 0) equals 1, else 0
        ng;      // if (out < 0)  equals 1, else 0

    PARTS:
    // x zero / negate: apply zx, then nx
    Mux16(a=x, b[0..15]=false, sel=zx, out=xZeroed);
    Not16(in=xZeroed, out=xNegated);
    Mux16(a=xZeroed, b=xNegated, sel=nx, out=xProcessed);

    // y zero / negate: apply zy, then ny
    Mux16(a=y, b[0..15]=false, sel=zy, out=yZeroed);
    Not16(in=yZeroed, out=yNegated);
    Mux16(a=yZeroed, b=yNegated, sel=ny, out=yProcessed);

    // Core operation: choose x & y or x + y using f
    And16(a=xProcessed, b=yProcessed, out=andOut);
    Add16(a=xProcessed, b=yProcessed, out=addOut);
    Mux16(a=andOut, b=addOut, sel=f, out=result);

    // Optional output negation: apply no
    Not16(in=result, out=negatedResult);
    Mux16(
        a=result,
        b=negatedResult,
        sel=no,
        out=finalResult,
        out[0..7]=finalLeft,
        out[8..15]=finalRight,
        out[15]=signBit
    );

    // zr is 1 only when all 16 bits of the final result are 0
    Or8Way(in=finalLeft, out=zrl);
    Or8Way(in=finalRight, out=zrr);
    Or(a=zrl, b=zrr, out=nzr);
    Not(in=nzr, out=zr);

    // ng copies the sign bit of the final result
    And(a=signBit, b=true, out=ng);

    // Publish the final internal result to the chip output bus
    Mux16(a=finalResult, b[0..15]=false, sel=false, out=out);
}
```
