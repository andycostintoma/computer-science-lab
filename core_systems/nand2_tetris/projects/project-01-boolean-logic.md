# Project 1: Boolean Logic

### Not

```hdl
/**
 * Not gate:
 * if (in) out = 0, else out = 1
 */
CHIP Not {
    IN in;
    OUT out;

    PARTS:
    Nand(a=in, b=in, out=out);
}
```

### And

```hdl
/**
 * And gate:
 * if (a and b) out = 1, else out = 0
 */
CHIP And {
    IN a, b;
    OUT out;

    PARTS:
    Nand(a=a, b=b, out=c);
    Not(in=c, out=out);
}
```

### Or

```hdl
/**
 * Or gate:
 * if (a or b) out = 1, else out = 0
 *
 * Method:
 * Or is false only when both inputs are false.
 * First detect that false case: Not(a) and Not(b).
 * Then flip the detector, because Or is everything except that false case.
 * So: Or(a, b) = Not(And(Not(a), Not(b))).
 */
CHIP Or {
    IN a, b;
    OUT out;

    PARTS:
    Not(in=a, out=nota);
    Not(in=b, out=notb);
    Nand(a=nota, b=notb, out=out);
}
```

### Xor

```hdl
/**
 * Exclusive-or gate:
 * if ((a and Not(b)) or (Not(a) and b)) out = 1, else out = 0
 *
 * Method:
 * Xor is true only when the inputs are different.
 * Detect each true row separately:
 * - a is true and b is false: And(a, Not(b))
 * - b is true and a is false: And(b, Not(a))
 * Then combine those two true-row detectors with Or.
 */
CHIP Xor {
    IN a, b;
    OUT out;

    PARTS:
    Not(in=a, out=nota);
    Not(in=b, out=notb);
    And(a=a, b=notb, out=aAndNotB);
    And(a=b, b=nota, out=bAndNotA);
    Or(a=aAndNotB, b=bAndNotA, out=out);
}
```

### Mux

```hdl
/**
 * Multiplexor:
 * if (sel = 0) out = a, else out = b
 *
 * Method:
 * Make one path for each selector case.
 * The a path is active only when sel is false: And(a, Not(sel)).
 * The b path is active only when sel is true: And(b, sel).
 * Since only one path can be active at a time, combine them with Or.
 */
CHIP Mux {
    IN a, b, sel;
    OUT out;

    PARTS:
    Not(in=sel, out=notSel);
    And(a=a, b=notSel, out=aPath);
    And(a=b, b=sel, out=bPath);
    Or(a=aPath, b=bPath, out=out);
}
```

### DMux

```hdl
/**
 * Demultiplexor:
 * [a, b] = [in, 0] if sel = 0
 *          [0, in] if sel = 1
 *
 * Method:
 * Make one output path for each selector case.
 * The a path is active only when sel is false: And(in, Not(sel)).
 * The b path is active only when sel is true: And(in, sel).
 * Since only one selector case can be active at a time, the input is routed
 * to exactly one output and the other output becomes 0.
 */
CHIP DMux {
    IN in, sel;
    OUT a, b;

    PARTS:
    Not(in=sel, out=notSel);
    And(a=in, b=notSel, out=a);
    And(a=in, b=sel, out=b);
}
```

### Not16

```hdl
/**
 * 16-bit Not gate:
 * for i = 0, ..., 15:
 * out[i] = Not(in[i])
 *
 * Method:
 * Treat the 16-bit input as 16 independent 1-bit wires.
 * Apply the Not gate to each bit separately.
 * Then collect the 16 results into the 16-bit output bus.
 */
CHIP Not16 {
    IN in[16];
    OUT out[16];

    PARTS:
    Not(in=in[0], out=out[0]);
    Not(in=in[1], out=out[1]);
    Not(in=in[2], out=out[2]);
    Not(in=in[3], out=out[3]);
    Not(in=in[4], out=out[4]);
    Not(in=in[5], out=out[5]);
    Not(in=in[6], out=out[6]);
    Not(in=in[7], out=out[7]);
    Not(in=in[8], out=out[8]);
    Not(in=in[9], out=out[9]);
    Not(in=in[10], out=out[10]);
    Not(in=in[11], out=out[11]);
    Not(in=in[12], out=out[12]);
    Not(in=in[13], out=out[13]);
    Not(in=in[14], out=out[14]);
    Not(in=in[15], out=out[15]);
}
```

### And16

```hdl
/**
 * 16-bit And gate:
 * for i = 0, ..., 15:
 * out[i] = And(a[i], b[i])
 *
 * Method:
 * Treat the two 16-bit inputs as 16 independent pairs of 1-bit wires.
 * Apply the And gate to each pair separately.
 * Then collect the 16 results into the 16-bit output bus.
 */
CHIP And16 {
    IN a[16], b[16];
    OUT out[16];

    PARTS:
    And(a=a[0], b=b[0], out=out[0]);
    And(a=a[1], b=b[1], out=out[1]);
    And(a=a[2], b=b[2], out=out[2]);
    And(a=a[3], b=b[3], out=out[3]);
    And(a=a[4], b=b[4], out=out[4]);
    And(a=a[5], b=b[5], out=out[5]);
    And(a=a[6], b=b[6], out=out[6]);
    And(a=a[7], b=b[7], out=out[7]);
    And(a=a[8], b=b[8], out=out[8]);
    And(a=a[9], b=b[9], out=out[9]);
    And(a=a[10], b=b[10], out=out[10]);
    And(a=a[11], b=b[11], out=out[11]);
    And(a=a[12], b=b[12], out=out[12]);
    And(a=a[13], b=b[13], out=out[13]);
    And(a=a[14], b=b[14], out=out[14]);
    And(a=a[15], b=b[15], out=out[15]);
}
```

### Or16

```hdl
/**
 * 16-bit Or gate:
 * for i = 0, ..., 15:
 * out[i] = Or(a[i], b[i])
 *
 * Method:
 * Treat the two 16-bit inputs as 16 independent pairs of 1-bit wires.
 * Apply the Or gate to each pair separately.
 * Then collect the 16 results into the 16-bit output bus.
 */
CHIP Or16 {
    IN a[16], b[16];
    OUT out[16];

    PARTS:
    Or(a=a[0], b=b[0], out=out[0]);
    Or(a=a[1], b=b[1], out=out[1]);
    Or(a=a[2], b=b[2], out=out[2]);
    Or(a=a[3], b=b[3], out=out[3]);
    Or(a=a[4], b=b[4], out=out[4]);
    Or(a=a[5], b=b[5], out=out[5]);
    Or(a=a[6], b=b[6], out=out[6]);
    Or(a=a[7], b=b[7], out=out[7]);
    Or(a=a[8], b=b[8], out=out[8]);
    Or(a=a[9], b=b[9], out=out[9]);
    Or(a=a[10], b=b[10], out=out[10]);
    Or(a=a[11], b=b[11], out=out[11]);
    Or(a=a[12], b=b[12], out=out[12]);
    Or(a=a[13], b=b[13], out=out[13]);
    Or(a=a[14], b=b[14], out=out[14]);
    Or(a=a[15], b=b[15], out=out[15]);
}
```

### Mux16

```hdl
/**
 * 16-bit multiplexor:
 * for i = 0, ..., 15:
 * if (sel = 0) out[i] = a[i], else out[i] = b[i]
 *
 * Method:
 * Use the same selector for all 16 bit positions.
 * For each bit, apply the 1-bit Mux to choose between a[i] and b[i].
 * Then collect the 16 selected bits into the 16-bit output bus.
 */
CHIP Mux16 {
    IN a[16], b[16], sel;
    OUT out[16];

    PARTS:
    Mux(a=a[0], b=b[0], sel=sel, out=out[0]);
    Mux(a=a[1], b=b[1], sel=sel, out=out[1]);
    Mux(a=a[2], b=b[2], sel=sel, out=out[2]);
    Mux(a=a[3], b=b[3], sel=sel, out=out[3]);
    Mux(a=a[4], b=b[4], sel=sel, out=out[4]);
    Mux(a=a[5], b=b[5], sel=sel, out=out[5]);
    Mux(a=a[6], b=b[6], sel=sel, out=out[6]);
    Mux(a=a[7], b=b[7], sel=sel, out=out[7]);
    Mux(a=a[8], b=b[8], sel=sel, out=out[8]);
    Mux(a=a[9], b=b[9], sel=sel, out=out[9]);
    Mux(a=a[10], b=b[10], sel=sel, out=out[10]);
    Mux(a=a[11], b=b[11], sel=sel, out=out[11]);
    Mux(a=a[12], b=b[12], sel=sel, out=out[12]);
    Mux(a=a[13], b=b[13], sel=sel, out=out[13]);
    Mux(a=a[14], b=b[14], sel=sel, out=out[14]);
    Mux(a=a[15], b=b[15], sel=sel, out=out[15]);
}
```

### Or8Way

```hdl
/**
 * 8-way Or gate:
 * out = Or(in[0], in[1], ..., in[7])
 *
 * Method:
 * Reduce the 8 input bits down to 1 bit by chaining Or gates.
 * Each Or combines the accumulated result with the next input bit.
 * If any input bit is 1, the output is 1.
 */
CHIP Or8Way {
    IN in[8];
    OUT out;

    PARTS:
    Or(a=in[0], b=in[1], out=o1);
    Or(a=o1, b=in[2], out=o2);
    Or(a=o2, b=in[3], out=o3);
    Or(a=o3, b=in[4], out=o4);
    Or(a=o4, b=in[5], out=o5);
    Or(a=o5, b=in[6], out=o6);
    Or(a=o6, b=in[7], out=out);
}
```

### Mux4Way16

```hdl
/**
 * 4-way 16-bit multiplexor:
 * if (sel = 00) out = a
 * if (sel = 01) out = b
 * if (sel = 10) out = c
 * if (sel = 11) out = d
 *
 * Method:
 * Use a two-level tree of Mux16 gates.
 * Level 1: sel[0] chooses between (a, b) and (c, d).
 * Level 2: sel[1] chooses between the two level-1 results.
 */
CHIP Mux4Way16 {
    IN a[16], b[16], c[16], d[16], sel[2];
    OUT out[16];

    PARTS:
    Mux16(a=a, b=b, sel=sel[0], out=ab);
    Mux16(a=c, b=d, sel=sel[0], out=cd);
    Mux16(a=ab, b=cd, sel=sel[1], out=out);
}
```

### Mux8Way16

```hdl
/**
 * 8-way 16-bit multiplexor:
 * if (sel = 000) out = a
 * if (sel = 001) out = b
 * if (sel = 010) out = c
 * if (sel = 011) out = d
 * if (sel = 100) out = e
 * if (sel = 101) out = f
 * if (sel = 110) out = g
 * if (sel = 111) out = h
 *
 * Method:
 * Use a three-level tree of Mux16 gates (4 + 2 + 1 = 7 chips).
 * Level 1: sel[0] pairs up adjacent inputs.
 * Level 2: sel[1] pairs the four level-1 results.
 * Level 3: sel[2] picks the final output.
 */
CHIP Mux8Way16 {
    IN a[16], b[16], c[16], d[16],
       e[16], f[16], g[16], h[16], sel[3];
    OUT out[16];

    PARTS:
    Mux16(a=a, b=b, sel=sel[0], out=ab);
    Mux16(a=c, b=d, sel=sel[0], out=cd);
    Mux16(a=e, b=f, sel=sel[0], out=ef);
    Mux16(a=g, b=h, sel=sel[0], out=gh);
    Mux16(a=ab, b=cd, sel=sel[1], out=abcd);
    Mux16(a=ef, b=gh, sel=sel[1], out=efgh);
    Mux16(a=abcd, b=efgh, sel=sel[2], out=out);
}
```

### DMux4Way

```hdl
/**
 * 4-way demultiplexor:
 * [a, b, c, d] = [in, 0, 0, 0] if sel = 00
 *                [0, in, 0, 0] if sel = 01
 *                [0, 0, in, 0] if sel = 10
 *                [0, 0, 0, in] if sel = 11
 *
 * Method:
 * Use a two-level tree of DMux gates (1 + 2 = 3 chips).
 * Level 1: sel[1] splits the input into two groups.
 * Level 2: sel[0] routes within each group to the final output.
 */
CHIP DMux4Way {
    IN in, sel[2];
    OUT a, b, c, d;

    PARTS:
    DMux(in=in, sel=sel[1], out=o1, out=o2);
    DMux(in=o1, sel=sel[0], out=a, out=b);
    DMux(in=o2, sel=sel[0], out=c, out=d);
}
```

### DMux8Way

```hdl
/**
 * 8-way demultiplexor:
 * [a, b, c, d, e, f, g, h] = [in, 0, ... 0] if sel = 000
 *                             ...
 *                             [0, ..., 0, in] if sel = 111
 *
 * Method:
 * Use a three-level tree of DMux gates (1 + 2 + 4 = 7 chips).
 * Level 1: sel[2] splits the input into two groups.
 * Level 2: sel[1] splits each group in half.
 * Level 3: sel[0] routes within each subgroup to the final output.
 */
CHIP DMux8Way {
    IN in, sel[3];
    OUT a, b, c, d, e, f, g, h;

    PARTS:
    DMux(in=in, sel=sel[2], out=o1, out=o2);
    DMux(in=o1, sel=sel[1], out=o3, out=o4);
    DMux(in=o2, sel=sel[1], out=o5, out=o6);
    DMux(in=o3, sel=sel[0], out=a, out=b);
    DMux(in=o4, sel=sel[0], out=c, out=d);
    DMux(in=o5, sel=sel[0], out=e, out=f);
    DMux(in=o6, sel=sel[0], out=g, out=h);
}
```
