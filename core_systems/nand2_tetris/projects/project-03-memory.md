# Project 3: Memory

### Bit

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/3/a/Bit.hdl
/**
 * 1-bit register:
 * If load is asserted, the register's value is set to in;
 * Otherwise, the register maintains its current value:
 * if (load(t)) out(t+1) = in(t), else out(t+1) = out(t)
 *
 * Method:
 * A DFF always stores whatever reaches its input at the clock edge.
 * So we put a Mux before the DFF to choose the next value:
 * - if load = 0: feed back the stored value (hold)
 * - if load = 1: feed in the external input (store)
 */
CHIP Bit {
    IN in, load;
    OUT out;

    PARTS:
    Mux(a=stored, b=in, sel=load, out=next);
    DFF(in=next, out=out, out=stored);
}
```

Why this works:

```text
load = 0 -> next = stored -> DFF re-stores old value -> hold
load = 1 -> next = in     -> DFF stores new input    -> update
```

Important detail:

```text
Mux(a, b, sel):
  if sel = 0 -> out = a
  if sel = 1 -> out = b
```

So feedback (`stored`) must be on `a`, and new input (`in`) must be on `b`.

### Register

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/3/a/Register.hdl
/**
 * 16-bit register:
 * If load is asserted, the register stores the 16-bit input.
 * Otherwise, it keeps its old 16-bit value.
 *
 * Method:
 * A Register is just 16 Bit chips in parallel.
 * Every Bit receives the same load signal.
 * So on one clock tick:
 * - if load = 0: all 16 bits hold their old values
 * - if load = 1: all 16 bits store in[0..15]
 */
CHIP Register {
    IN in[16], load;
    OUT out[16];

    PARTS:
    Bit(in=in[0],  load=load, out=out[0]);
    Bit(in=in[1],  load=load, out=out[1]);
    Bit(in=in[2],  load=load, out=out[2]);
    Bit(in=in[3],  load=load, out=out[3]);
    Bit(in=in[4],  load=load, out=out[4]);
    Bit(in=in[5],  load=load, out=out[5]);
    Bit(in=in[6],  load=load, out=out[6]);
    Bit(in=in[7],  load=load, out=out[7]);
    Bit(in=in[8],  load=load, out=out[8]);
    Bit(in=in[9],  load=load, out=out[9]);
    Bit(in=in[10], load=load, out=out[10]);
    Bit(in=in[11], load=load, out=out[11]);
    Bit(in=in[12], load=load, out=out[12]);
    Bit(in=in[13], load=load, out=out[13]);
    Bit(in=in[14], load=load, out=out[14]);
    Bit(in=in[15], load=load, out=out[15]);
}
```

Why this works:

```text
Each Bit already knows how to hold or update one bit.
Putting 16 of them side by side gives one 16-bit storage word.
The shared load line makes them all act together as one register.
```

### RAM8

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/3/a/RAM8.hdl
/**
 * Memory of eight 16-bit registers, addressed by 3 bits.
 *
 * Method:
 * Build RAM8 from 8 Register chips.
 * - Writing: DMux8Way sends the single load signal to exactly one register.
 * - Reading: Mux8Way16 chooses exactly one register output.
 *
 * So the same address is used twice:
 * - once to decide which register writes
 * - once to decide which register is read
 */
CHIP RAM8 {
    IN in[16], load, address[3];
    OUT out[16];

    PARTS:
    // Split the single load signal into 8 load wires.
    // Exactly one of load0..load7 can become 1.
    DMux8Way(
        in=load,
        sel=address,
        a=load0,
        b=load1,
        c=load2,
        d=load3,
        e=load4,
        f=load5,
        g=load6,
        h=load7
    );

    // All registers see the same input bus.
    // Only the selected register gets load = 1 and stores the new value.
    Register(in=in, load=load0, out=out0);
    Register(in=in, load=load1, out=out1);
    Register(in=in, load=load2, out=out2);
    Register(in=in, load=load3, out=out3);
    Register(in=in, load=load4, out=out4);
    Register(in=in, load=load5, out=out5);
    Register(in=in, load=load6, out=out6);
    Register(in=in, load=load7, out=out7);

    // All stored outputs are available all the time.
    // The mux chooses which register becomes the RAM output.
    Mux8Way16(
        a=out0,
        b=out1,
        c=out2,
        d=out3,
        e=out4,
        f=out5,
        g=out6,
        h=out7,
        sel=address,
        out=out
    );
}
```

Why this works:

```text
address = 000 -> write/read Register 0
address = 001 -> write/read Register 1
...
address = 111 -> write/read Register 7

DMux8Way answers: where should the write go?
Mux8Way16 answers: which stored value should we read?
```

### RAM64

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/3/b/RAM64.hdl
/**
 * Memory of sixty-four 16-bit words.
 *
 * Method:
 * Build RAM64 from 8 RAM8 chips.
 * The 6-bit address is split into two 3-bit parts:
 * - address[3..5]: choose which RAM8 block
 * - address[0..2]: choose which word inside that RAM8
 *
 * Conceptually, this is like row and column:
 * - outer 3 bits = which row / block
 * - inner 3 bits = which column / word inside the block
 */
CHIP RAM64 {
    IN in[16], load, address[6];
    OUT out[16];

    PARTS:
    // Top-level write selection: choose which RAM8 block may write.
    DMux8Way(
        in=load,
        sel=address[3..5],
        a=load0,
        b=load1,
        c=load2,
        d=load3,
        e=load4,
        f=load5,
        g=load6,
        h=load7
    );

    // All RAM8 blocks receive the same input bus.
    // The outer address bits choose the block.
    // The inner address bits choose the location inside that block.
    RAM8(in=in, load=load0, address=address[0..2], out=out0);
    RAM8(in=in, load=load1, address=address[0..2], out=out1);
    RAM8(in=in, load=load2, address=address[0..2], out=out2);
    RAM8(in=in, load=load3, address=address[0..2], out=out3);
    RAM8(in=in, load=load4, address=address[0..2], out=out4);
    RAM8(in=in, load=load5, address=address[0..2], out=out5);
    RAM8(in=in, load=load6, address=address[0..2], out=out6);
    RAM8(in=in, load=load7, address=address[0..2], out=out7);

    // Top-level read selection: choose which RAM8 block's output becomes RAM64's output.
    Mux8Way16(
        a=out0,
        b=out1,
        c=out2,
        d=out3,
        e=out4,
        f=out5,
        g=out6,
        h=out7,
        sel=address[3..5],
        out=out
    );
}
```

Why this works:

```text
RAM64 = 8 RAM8 blocks

address[3..5] = which RAM8 block
address[0..2] = which word inside that block

Example:
address = 101011
  101 -> choose RAM8 block 5
  011 -> choose word 3 inside block 5
```

### RAM512

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/3/b/RAM512.hdl
/**
 * Memory of 512 16-bit words.
 *
 * Method:
 * Build RAM512 from 8 RAM64 chips.
 * The 9-bit address is split into two parts:
 * - address[6..8]: choose which RAM64 block
 * - address[0..5]: choose which word inside that RAM64
 *
 * This is the same pattern again:
 * - top-level DMux8Way decides where writing happens
 * - top-level Mux8Way16 decides what gets read
 */
CHIP RAM512 {
    IN in[16], load, address[9];
    OUT out[16];

    PARTS:
    // Choose which RAM64 block may receive load = 1.
    DMux8Way(
        in=load,
        sel=address[6..8],
        a=load0,
        b=load1,
        c=load2,
        d=load3,
        e=load4,
        f=load5,
        g=load6,
        h=load7
    );

    // Every child sees the same input bus.
    // The outer 3 bits choose the child block.
    // The inner 6 bits choose a word inside that block.
    RAM64(in=in, load=load0, address=address[0..5], out=out0);
    RAM64(in=in, load=load1, address=address[0..5], out=out1);
    RAM64(in=in, load=load2, address=address[0..5], out=out2);
    RAM64(in=in, load=load3, address=address[0..5], out=out3);
    RAM64(in=in, load=load4, address=address[0..5], out=out4);
    RAM64(in=in, load=load5, address=address[0..5], out=out5);
    RAM64(in=in, load=load6, address=address[0..5], out=out6);
    RAM64(in=in, load=load7, address=address[0..5], out=out7);

    // Choose which RAM64 output becomes RAM512's output.
    Mux8Way16(
        a=out0,
        b=out1,
        c=out2,
        d=out3,
        e=out4,
        f=out5,
        g=out6,
        h=out7,
        sel=address[6..8],
        out=out
    );
}
```

Why this works:

```text
RAM512 = 8 RAM64 blocks

address[6..8] = which RAM64 block
address[0..5] = which word inside that block

Example:
address = 101011001
  101    -> choose RAM64 block 5
  011001 -> choose one word inside block 5
```

### RAM4K

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/3/b/RAM4K.hdl
/**
 * Memory of 4096 16-bit words.
 *
 * Method:
 * Build RAM4K from 8 RAM512 chips.
 * The 12-bit address is split into two parts:
 * - address[9..11]: choose which RAM512 block
 * - address[0..8]: choose which word inside that RAM512
 */
CHIP RAM4K {
    IN in[16], load, address[12];
    OUT out[16];

    PARTS:
    // Choose which RAM512 block may write.
    DMux8Way(
        in=load,
        sel=address[9..11],
        a=load0,
        b=load1,
        c=load2,
        d=load3,
        e=load4,
        f=load5,
        g=load6,
        h=load7
    );

    // Each RAM512 receives the same input bus and inner address.
    RAM512(in=in, load=load0, address=address[0..8], out=out0);
    RAM512(in=in, load=load1, address=address[0..8], out=out1);
    RAM512(in=in, load=load2, address=address[0..8], out=out2);
    RAM512(in=in, load=load3, address=address[0..8], out=out3);
    RAM512(in=in, load=load4, address=address[0..8], out=out4);
    RAM512(in=in, load=load5, address=address[0..8], out=out5);
    RAM512(in=in, load=load6, address=address[0..8], out=out6);
    RAM512(in=in, load=load7, address=address[0..8], out=out7);

    // Choose which RAM512 output becomes RAM4K's output.
    Mux8Way16(
        a=out0,
        b=out1,
        c=out2,
        d=out3,
        e=out4,
        f=out5,
        g=out6,
        h=out7,
        sel=address[9..11],
        out=out
    );
}
```

Why this works:

```text
RAM4K = 8 RAM512 blocks

address[9..11] = which RAM512 block
address[0..8]  = which word inside that block
```

### RAM16K

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/3/b/RAM16K.hdl
/**
 * Memory of 16384 16-bit words.
 *
 * Method:
 * Build RAM16K from 4 RAM4K chips.
 * The 14-bit address is split into two parts:
 * - address[12..13]: choose which RAM4K block
 * - address[0..11]: choose which word inside that RAM4K
 *
 * This final chip is slightly different:
 * only 4 child blocks are needed, so we use DMux4Way and Mux4Way16.
 */
CHIP RAM16K {
    IN in[16], load, address[14];
    OUT out[16];

    PARTS:
    // Choose which RAM4K block may write.
    DMux4Way(
        in=load,
        sel=address[12..13],
        a=load0,
        b=load1,
        c=load2,
        d=load3
    );

    // Each RAM4K receives the same input bus and inner address.
    RAM4K(in=in, load=load0, address=address[0..11], out=out0);
    RAM4K(in=in, load=load1, address=address[0..11], out=out1);
    RAM4K(in=in, load=load2, address=address[0..11], out=out2);
    RAM4K(in=in, load=load3, address=address[0..11], out=out3);

    // Choose which RAM4K output becomes RAM16K's output.
    Mux4Way16(
        a=out0,
        b=out1,
        c=out2,
        d=out3,
        sel=address[12..13],
        out=out
    );
}
```

Why this works:

```text
RAM16K = 4 RAM4K blocks

address[12..13] = which RAM4K block
address[0..11]  = which word inside that block

This is the same hierarchy idea again, except the final level uses 4 blocks instead of 8.
```

### PC

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/3/a/PC.hdl
/**
 * 16-bit program counter.
 * If reset=1, the counter becomes 0.
 * Else if load=1, the counter becomes in.
 * Else if inc=1, the counter increments by 1.
 * Else it keeps its previous value.
 *
 * Method:
 * Build PC from one Register plus combinational logic in front of it.
 * The Register stores the current value.
 * Then a chain of Mux16 chips decides what the next value should be.
 *
 * Priority is created by the order of the muxes:
 * - first choose hold vs increment
 * - then allow load to override that result
 * - then allow reset to override everything
 */
CHIP PC {
    IN in[16], load, inc, reset;
    OUT out[16];

    PARTS:
    // The register stores the current PC value.
    // In HDL, this is wiring, not step-by-step execution:
    // the wire named next is computed below and fed back into the register input.
    Register(in=next, load=true, out=out, out=current);

    // One possible next value is current + 1.
    Inc16(in=current, out=incremented);

    // If inc = 0, keep the current value.
    // If inc = 1, use the incremented value.
    Mux16(a=current, b=incremented, sel=inc, out=afterInc);

    // If load = 1, external input overrides hold/increment.
    Mux16(a=afterInc, b=in, sel=load, out=afterLoad);

    // If reset = 1, zero overrides everything else.
    Mux16(a=afterLoad, b[0..15]=false, sel=reset, out=next);
}
```

Why this works:

```text
if reset = 1 -> next = 0
else if load = 1 -> next = in
else if inc = 1 -> next = current + 1
else -> next = current
```

Read the circuit from left to right:

```text
current -> maybe increment -> maybe replace with in -> maybe replace with 0 -> next
```

Important detail:

```text
HDL is not sequential code.
The line Register(in=next, ...) does not mean "use next before assignment".
It means "connect the register input pin to the wire named next".
Then later muxes drive that wire.
```

So the PC is really:

```text
Register + increment logic + selection logic
```

That is why it can hold, increment, load a new value, or reset to zero.
