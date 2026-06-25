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

#### PC

The Program Counter (`PC`) is a 16-bit register equipped with combinational control logic to select among several candidate next values based on reset, load, and inc commands.

#### HDL Implementation

```hdl
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/3/a/PC.hdl

/**
 * A 16-bit counter.
 * if      reset(t): out(t+1) = 0
 * else if load(t):  out(t+1) = in(t)
 * else if inc(t):   out(t+1) = out(t) + 1
 * else              out(t+1) = out(t)
 */
CHIP PC {
    IN in[16], reset, load, inc;
    OUT out[16];

    PARTS:
    // 1. State Storage: Stores the current PC address.
    // 'load' is hardwired to true because our multiplexer cascade always
    // calculates the correct candidate value for the next cycle.
    Register(in=nextPC, load=true, out=out, out=currentPC);

    // 2. Incrementer: Calculates the next sequential instruction address.
    Inc16(in=currentPC, out=incrementedPC);

    // 3. Stage 1 (Inc Selector): Chooses between holding and incrementing.
    // if inc = 0 -> output currentPC
    // if inc = 1 -> output incrementedPC
    Mux16(a=currentPC, b=incrementedPC, sel=inc, out=holdOrIncPC);

    // 4. Stage 2 (Load Selector): Handles jumping to external addresses.
    // 'load' overrides 'inc' and Hold by selecting input 'in' if asserted.
    // if load = 0 -> output holdOrIncPC
    // if load = 1 -> output in
    Mux16(a=holdOrIncPC, b=in, sel=load, out=jumpOrHoldOrIncPC);

    // 5. Stage 3 (Reset Selector): Handles clearing the counter.
    // 'reset' overrides all other inputs by selecting 0 if asserted.
    // if reset = 0 -> output jumpOrHoldOrIncPC
    // if reset = 1 -> output 0
    Mux16(a=jumpOrHoldOrIncPC, b[0..15]=false, sel=reset, out=nextPC);
}
```

Meaning:
- `Register(in=nextPC, load=true, out=out, out=currentPC);`: At each clock tick, the 16-bit register stores `nextPC` (the final computed value from the Mux cascade) because its load pin is hardwired to `true`. It outputs the stored value to the chip's external output `out` and to the internal feedback wire `currentPC`.
- `Inc16(in=currentPC, out=incrementedPC);`: The `Inc16` chip continuously takes `currentPC` and calculates the incremented value `currentPC + 1`, outputting it on the internal wire `incrementedPC`.
- `Mux16(a=currentPC, b=incrementedPC, sel=inc, out=holdOrIncPC);`: The first multiplexer selects between `currentPC` (channel `a`, selected when `inc = 0`) and `incrementedPC` (channel `b`, selected when `inc = 1`), outputting the result on `holdOrIncPC`.
- `Mux16(a=holdOrIncPC, b=in, sel=load, out=jumpOrHoldOrIncPC);`: The second multiplexer selects between the previous stage's result `holdOrIncPC` (channel `a`, selected when `load = 0`) and the external input `in` (channel `b`, selected when `load = 1`), outputting the result on `jumpOrHoldOrIncPC`. This implements the override where `load` takes precedence over `inc` and hold.
- `Mux16(a=jumpOrHoldOrIncPC, b[0..15]=false, sel=reset, out=nextPC);`: The final multiplexer selects between the accumulated result `jumpOrHoldOrIncPC` (channel `a`, selected when `reset = 0`) and a 16-bit constant zero (channel `b`, selected when `reset = 1`), outputting the final result to `nextPC`. This implements the highest priority override where `reset` overrides all other inputs.

#### Priority Routing Analysis

The counter's priority logic (Reset > Load > Increment > Hold) is implemented by cascading three multiplexers in reverse priority order:

```text
currentPC -> inc selector -> load selector -> reset selector -> nextPC
```

Because the output of each multiplexer feeds into the input of the next one, the later stages have the power to discard the decisions made by the earlier ones:
1. **Default State**: If `reset = 0`, `load = 0`, and `inc = 0`, the first Mux outputs `currentPC`, which flows through all subsequent stages to become `nextPC` (Hold).
2. **Increment**: If `inc = 1`, the first Mux outputs `currentPC + 1`, which flows to the end as long as `load = 0` and `reset = 0`.
3. **Load Override**: If `load = 1`, the second Mux discards the output of the first Mux and outputs `in`, which flows to the end as long as `reset = 0`.
4. **Reset Override**: If `reset = 1`, the third Mux discards the output of the second Mux and outputs `0`, overriding all other control bits.

#### Wire Routing and Feedback Loops
In HDL, connections represent physical wires, not sequential execution lines. The wire `nextPC` is calculated by the third Mux and fed back to the register's input pin `in=nextPC`. Because the register is a sequential chip, it introduces a one-cycle delay, breaking any instantaneous combinational feedback loop and ensuring safe state updates..
