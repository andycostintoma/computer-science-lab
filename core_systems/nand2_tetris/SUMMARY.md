## Preface

The book's promise is simple:

```text
Start with one primitive logic gate.
Build a complete computer system.
Run real programs on it.
```

The point is not only to learn hardware or software separately. The point is to understand how the whole stack fits together.

Modern computers feel mysterious because each layer hides the layer below it. The book reverses that experience. Instead of accepting the machine as magic, we build each layer from the previous one.

The construction path is:

```text
Nand gate
  -> logic gates
  -> arithmetic chips
  -> memory chips
  -> CPU and computer architecture
  -> assembler
  -> virtual machine
  -> compiler
  -> operating system
  -> applications
```

The second edition clarifies this path and aligns the book more closely with the online course materials.

### Scope

The book covers the minimal set of ideas needed to build a working general-purpose computer.

That includes:

- Boolean logic
- Boolean arithmetic
- memory
- machine language
- computer architecture
- assemblers
- virtual machines
- high-level languages
- compilers
- operating systems
- algorithms, data structures, and software engineering ideas

The key word is minimal. The book does not try to cover every industrial detail. It keeps only what is needed to make the whole system understandable and buildable.

### Courses

The material can serve different kinds of courses.

It can be used as:

- an early systems course
- a late synthesis course
- a hardware-focused course
- a software-focused course
- a full semester-long build-the-computer experience

The hardware half assumes almost no background. The software half assumes basic programming.

The reason the course works for many audiences is that the main skill is systems thinking:

```text
understand an abstraction
implement it from simpler parts
use it as a building block for the next layer
```

### Resources

The book is supported by the Nand to Tetris software suite and website.

These provide:

- hardware simulator
- CPU emulator
- VM emulator
- assembler and compiler tools
- tutorials
- project files
- test scripts
- comparison files

The tools matter because they make construction concrete. You do not only read that a chip should work. You implement it, run the supplied tests, and see whether it behaves correctly.

### Structure

[Part I](#i-hardware) covers hardware in chapters [1](#1-boolean-logic)–[6](The_Elements_of_Computing_Systems_2021.md#6-assembler): Boolean logic, Boolean arithmetic, memory, machine language, computer architecture, and assemblers. Part [II](The_Elements_of_Computing_Systems_2021.md#ii-software) covers software in chapters [7](The_Elements_of_Computing_Systems_2021.md#7-virtual-machine-i-processing)–[12](The_Elements_of_Computing_Systems_2021.md#12-operating-system): virtual machines, a high-level language, compiler construction, and an operating system. Chapter [13](The_Elements_of_Computing_Systems_2021.md#13-more-fun-to-go) and the appendices extend the journey and supply supporting technical material.

Each chapter follows the same pattern:

```text
concept
  -> abstraction
  -> implementation
  -> project
  -> perspective
```

That pattern is important. Every layer is first treated as a black box that has a clear public behavior. Then the chapter opens the box and shows how to build it.

### Projects

The projects are the main learning method.

The book is not asking you to memorize the computer stack. It is asking you to construct it.

The work includes:

- implementing chips in HDL
- building arithmetic and memory devices
- writing an assembler
- writing a virtual machine translator
- writing a compiler
- writing parts of an operating system
- running programs on the completed machine

The projects are intentionally constrained. Inputs are usually clean. Optimization is usually ignored. The goal is correctness and understanding, not industrial performance.

### The Second Edition

The second edition makes the two arcs clearer:

```text
Part I  -> hardware
Part II -> software
```

It also improves explanations, figures, examples, appendices, and project alignment with the online materials.

The main improvement is conceptual clarity: the book keeps returning to the difference between abstraction and implementation.

### Acknowledgments

The authors credit the students, teaching assistants, editors, tool builders, and course-material contributors who shaped the project over many years.

Special attention is given to Mark Armbrust, who supported learners through the Q&A forum, fixed bugs, wrote scripts, and became central to the community.

The larger point is that Nand to Tetris became more than a book. It became an open educational ecosystem around the idea that the computer can be understood by building it.

## I Hardware

### Introduction

Part I begins the bottom-up hardware path.

The goal is to build a working hardware platform from simple logic gates.

The deeper goal is to learn how complex systems are made from modules:

```text
small parts
  -> named interfaces
  -> tested implementations
  -> larger parts
```

#### Hello, World Below

A simple program like `Hello World` hides a large machine underneath it.

At the top, you see text in a high-level language.

Below that, many transformations happen:

```text
high-level program
  -> parsed and compiled
  -> translated into machine language
  -> executed by a CPU
  -> implemented by chips
  -> built from logic gates
  -> grounded in physical switching devices
```

![](media/figure_wo_caption_I.1.png)

The important idea is that programmers usually see only the top layer. This book goes below the surface and rebuilds the hidden layers one by one.

#### Nand to Tetris

The phrase Nand to Tetris means:

```text
from the primitive Nand gate
to a computer that can run an application like Tetris
```

The specific computer is called Hack. The specific high-level language is called Jack.

They are not meant to be industrial standards. They are small enough to understand completely.

![](media/figure_I.1.png)

The roadmap has two directions:

```text
hardware builds upward
software translates downward
```

Hardware starts with gates and rises toward a machine. Software starts with high-level programs and is translated down into machine instructions.

#### Abstraction and Implementation

Every module has two views.

The abstraction is:

```text
what the module does
```

The implementation is:

```text
how the module does it
```

Example:

```text
Abstraction: Xor outputs 1 when its inputs differ.
Implementation: Xor can be built from Not, And, and Or gates.
```

When you use a module, you should depend on its abstraction. When you build a module, you must understand its implementation.

This separation is how large systems stay manageable.

#### Methodology

Part I builds about thirty gates and chips using HDL.

HDL is not a programming language in the usual sense. It describes hardware structure:

```text
which lower-level chips exist
how their pins are connected
```

The hardware simulator then tests the design before any physical hardware exists.

Part II later uses the completed hardware platform to build the software stack: assembler, virtual machine, compiler, and operating system.

#### The Road Ahead

The full journey contains twelve construction projects.

The course has two directions at once:

```text
Across projects: bottom-up
Within each project: top-down
```

Across projects, we start from Nand and build toward applications.

Within each project, we first understand the desired abstraction, then implement it using already available parts.

Part I builds:

```text
logic gates
  -> ALU
  -> memory
  -> machine language
  -> CPU and computer architecture
  -> assembler
```

That completed hardware/software boundary becomes the foundation for the higher-level software stack in Part II.

### 1 Boolean Logic

Digital hardware stores and processes binary values.

Chapter 1 builds the basic vocabulary of hardware:

```text
Nand
  -> Not, And, Or, Xor
  -> multiplexers and demultiplexers
  -> 16-bit versions
  -> multi-way versions
```

The main idea is:

```text
Boolean algebra specifies behavior.
Logic gates implement behavior.
HDL wires gates together.
Tests verify the implementation.
```

#### 1.1 Boolean Algebra

Boolean algebra works with two values:

```text
0
1
```

A Boolean function maps binary inputs to a binary output.

Example:

```text
And(0, 0) = 0
And(0, 1) = 0
And(1, 0) = 0
And(1, 1) = 1
```

The common Boolean operators are:

```text
And
Or
Not
```

They can be written mathematically as $x \cdot y$, $x + y$, and $\bar{x}$, or as $x \land y$, $x \lor y$, and Not(`x`).

![](media/figure_1.1.png)

![](media/figure_1.2.png)

The key theoretical fact is that every Boolean function can be built from Nand alone.

That is why Nand can be the primitive starting point for the whole computer.

The number of possible Boolean functions grows very quickly. With *n* input variables, there are $2^{2^n}$ possible Boolean functions.

##### Boolean Functions

A Boolean function can be represented in two main ways.

Truth table:

```text
list every possible input
show the output for each input
```

Boolean expression:

```text
write a formula that computes the output
```

For three inputs `(x, y, z)`, there are `2^3 = 8` possible input combinations.

![](media/figure_1.3.png)

The figure shows that the same function can be described by a table or by an expression such as:

```text
(x OR y) AND NOT(z)
```

##### Truth Tables and Boolean Expressions

Truth tables and expressions are two views of the same thing.

You can go from expression to truth table by evaluating the expression for every input combination.

You can go from truth table to expression by finding the rows where the output is `1` and writing logic that detects those rows.

This matters because hardware design often starts with desired behavior and ends with gates.

The practical path is:

```text
desired behavior
  -> truth table
  -> Boolean expression
  -> simpler expression
  -> gate implementation
```

Simplification matters because simpler expressions usually mean fewer gates.

#### 1.2 Logic Gates

A logic gate is a physical or simulated device that implements a Boolean function.

The physical details can vary, but the abstraction stays the same.

For example, an And gate means:

```text
out = 1 only when both inputs are 1
```

![](media/figure_1.4.png)

This lets us reason at the gate level without thinking about transistors every time.

##### Primitive and Composite Gates

A primitive gate is given to us.

A composite gate is built from other gates.

Example:

```text
And(a, b, c) = And(And(a, b), c)
```

![](media/figure_1.5.png)

The interface says what the gate looks like from the outside:

```text
inputs
outputs
behavior
```

The implementation says what is inside:

```text
which smaller gates are used
how they are connected
```

Xor is a good example. Its behavior is:

```text
out = 1 when a and b are different
```

One implementation is:

```text
Xor(a, b) = Or(And(a, Not(b)), And(Not(a), b))
```

![](media/figure_1.6.png)

So logic design means:

```text
given a desired behavior
build it from gates that already exist
```

#### 1.3 Hardware Construction

Building physical chips by hand would be too slow and error-prone.

Modern hardware design therefore uses descriptions and simulations first.

The workflow is:

```text
write HDL
run simulator
compare against expected behavior
fix the design
```

Only after the design is correct would real manufacturing matter.

##### 1.3.1 Hardware Description Language

HDL describes chip structure.

It says:

```text
this chip has these inputs and outputs
this chip is built from these parts
these pins are connected to those pins
```

![](media/figure_1.7.png)

For Xor, the HDL header defines the public interface. The `PARTS` section builds the implementation from lower-level gates.

Internal pins name intermediate values.

Example mental model:

```text
notA = Not(a)
notB = Not(b)
aAndNotB = And(a, notB)
notAAndB = And(notA, b)
out = Or(aAndNotB, notAAndB)
```

##### Testing

Testing checks whether the implementation matches the specification.

A test script usually does this:

```text
load chip
set inputs
evaluate output
compare with expected output
repeat
```

For small gates, every input combination can be tested.

For larger chips, tests still provide strong confidence even when exhaustive testing is too large.

##### 1.3.2 Hardware Simulation

The hardware simulator executes HDL designs.

It lets you inspect:

```text
current input values
internal behavior
actual output
expected output
```

![](media/figure_1.8.png)

This makes hardware design feel like programming with tests, but the thing being described is a circuit, not a sequence of instructions.

#### 1.4 Specification

This section specifies the chips needed for Project 1.

The specification answers:

```text
What should each chip do?
```

It does not yet answer:

```text
How should each chip be built?
```

That separation is the core discipline of the course.

##### 1.4.1 Nand

Nand is the primitive gate.

Its behavior is:

```text
Nand(a, b) = NOT(a AND b)
```

So it outputs `0` only when both inputs are `1`.

![](media/figure_wo_caption_1.1.png)

![](media/figure_wo_caption_1.2.png)

Everything else in Chapter 1 can be built from this gate.

##### 1.4.2 Basic Logic Gates

The basic gates are:

```text
Not
And
Or
Xor
Mux
DMux
```

![](media/figure_wo_caption_1.3.png)

![](media/figure_wo_caption_1.4.png)

![](media/figure_wo_caption_1.5.png)

![](media/figure_wo_caption_1.6.png)

The multiplexer chooses one of two inputs:

```text
if sel = 0: out = a
if sel = 1: out = b
```
![[figure_1.9.png]]

The demultiplexer routes one input to one of two outputs:

```text
if sel = 0: a = in, b = 0
if sel = 1: a = 0,  b = in
```

![](media/figure_1.10.png)

Mental model:

```text
Mux chooses a value.
DMux chooses a destination.
```

##### 1.4.3 Multi-Bit Versions of Basic Gates

Computers usually process words, not isolated bits.

A 16-bit gate applies the same operation to each bit position.

Example:

```text
And16(a[16], b[16], out[16])

out[0]  = And(a[0],  b[0])
out[1]  = And(a[1],  b[1])
...
out[15] = And(a[15], b[15])
```

![](media/figure_wo_caption_1.7.png)

![](media/figure_wo_caption_1.8.png)

![](media/figure_wo_caption_1.9.png)

![](media/figure_wo_caption_1.10.png)

The operation is not new. Only the width changes.

##### 1.4.4 Multi-Way Versions of Basic Gates

Multi-way gates generalize selection to more inputs or outputs.

Examples:

```text
Or8Way    -> OR together 8 inputs
Mux4Way16 -> choose 1 of 4 16-bit inputs
DMux8Way  -> route input to 1 of 8 outputs
```

![](media/figure_wo_caption_1.11.png)

To choose among `m` inputs, you need enough selector bits to name each choice:

```text
number of selector bits = log2(m)
```

For example:

```text
4 choices -> 2 selector bits
8 choices -> 3 selector bits
```

![](media/figure_wo_caption_1.12.png)

![](media/figure_wo_caption_1.13.png)

Demultiplexers use the same idea in reverse: the selector chooses where the input goes.

![](media/figure_wo_caption_1.14.png)

![](media/figure_wo_caption_1.15.png)

#### 1.5 Implementation

After specifying the chips, the chapter explains how to build them.

The practical rule is:

```text
build small gates first
test them
reuse them to build larger gates
```

##### 1.5.1 Behavioral Simulation

Behavioral simulation means the simulator provides a chip's behavior directly.

This is useful when:

```text
you want to test a higher-level design
but a lower-level chip is not implemented yet
```

![](media/figure_wo_caption_1.16.png)

The built-in chip has the same interface as the HDL chip. The difference is only where the behavior comes from.

##### 1.5.2 Hardware Implementation

The implementation path starts from Nand.

Example ladder:

```text
Nand
  -> Not
  -> And
  -> Or
  -> Xor
  -> Mux and DMux
  -> 16-bit and multi-way chips
```

Once a chip works, use it as a building block. Do not keep rebuilding everything from raw Nand unless the project requires it.

##### 1.5.3 Built-In Chips

The simulator looks for chip implementations in two places:

```text
current project folder
built-in tools folder
```

If your HDL file is missing, the simulator may use a built-in version.

This is useful as a fallback, but the project goal is still to implement the specified chips yourself.

#### 1.6 Project

Project 1 asks you to implement the chapter's logic gates using HDL.

The work happens in `nand2tetris/projects/01`.

The pattern for every chip is:

```text
read the specification
write the HDL implementation
run the supplied test script
compare against the expected output
fix until it passes
```

The important constraint is that you should build the chips from Nand and from previously completed chips.

##### General Implementation Tips

- Prefer the simplest correct implementation.
- Reuse composite gates already built instead of implementing every chip directly from Nand.
- Do not invent helper chips outside the chapter's specified chip set.
- Build gates in chapter order, and rely on built-in chips only as a temporary fallback when necessary.

#### 1.7 Perspective

Chapter [1](#1-boolean-logic) builds the elementary logic toolbox.

The book uses Nand as the primitive, but Nand is not magical. Nor can also serve as a complete basis, and combinations like And/Or/Not are also complete.

The chapter intentionally ignores transistor-level physics and optimization.

The goal is to understand this layer:

```text
Boolean functions
  -> logic gates
  -> HDL implementations
```

That toolbox is enough to build arithmetic in the next chapter.

### 2 Boolean Arithmetic

Chapter 2 moves from logic to arithmetic.

The construction path is:

```text
binary numbers
  -> binary addition
  -> half-adder
  -> full-adder
  -> 16-bit adder
  -> incrementer
  -> ALU
```

The main idea is that many computer operations reduce to simple bit-level operations controlled by a small number of signals.

#### 2.1 Arithmetic Operations

Computers need operations such as:

```text
addition
subtraction
negation
comparison
multiplication
division
```

This chapter focuses on the operations needed to build the Hack ALU.

The most important operation is addition.

Why addition first?

```text
subtraction can be reduced to addition
incrementing is addition by 1
many higher operations can be built in software from simpler arithmetic
```

#### 2.2 Binary Numbers

Binary numbers use base 2.

Decimal uses powers of 10:

```text
345 = 3*100 + 4*10 + 5*1
```

Binary uses powers of 2:

```text
1011 = 1*8 + 0*4 + 1*2 + 1*1 = 11
```

![](media/2-1.png)

![](media/2-2.png)

Computers store fixed-width binary words.

With `n` bits, there are:

```text
2^n possible bit patterns
```

If all values are nonnegative, the range is:

```text
0 through 2^n - 1
```

Example:

```text
4 bits -> 16 values -> 0 through 15
```

#### 2.3 Binary Addition

Binary addition works like decimal addition, but each digit is a bit.

You add from right to left:

```text
add current bit pair
include carry from previous position
produce sum bit
send carry to next position
```

![](media/figure_wo_caption_2.1.png)

The basic cases are:

```text
0 + 0 = 0
0 + 1 = 1
1 + 0 = 1
1 + 1 = 10  meaning sum 0, carry 1
```

In fixed-width hardware, overflow is ignored.

For Hack:

```text
16-bit addition returns the low 16 bits
extra carry beyond bit 15 is discarded
```

#### 2.4 Signed Binary Numbers

To represent negative numbers, the computer must assign meanings to bit patterns.

The standard representation used here is two's complement.

![](media/figure_2.1.png)

**Figure 2.1** Two's complement representation of signed numbers, in a 4-bit binary system.

In an `n`-bit two's complement system, the range is:

```text
-2^(n-1) through 2^(n-1) - 1
```

Example with 4 bits:

```text
1000 -> -8
1001 -> -7
...
1111 -> -1
0000 -> 0
0001 -> 1
...
0111 -> 7
```

The most significant bit indicates the sign:

```text
0 at the left -> nonnegative
1 at the left -> negative
```

To negate a number:

```text
flip all bits
add 1
```

The hardware payoff is huge:

```text
x - y = x + (-y)
```

So the same adder can support both addition and subtraction.

#### 2.5 Specification

The chapter specifies the arithmetic chips before building them.

The desired ladder is:

```text
HalfAdder
  -> FullAdder
  -> Add16
  -> Inc16
  -> ALU
```

##### 2.5.1 Adders

A half-adder adds two bits.

Interface:

```text
HalfAdder(a, b, sum, carry)
```

Behavior:

```text
sum   = low bit of a + b
carry = high bit of a + b
```

![](media/figure_2.2.png)

**Figure 2.2** Half-adder, designed to add 2 bits.

A full-adder adds three bits: two data bits plus an incoming carry.

Interface:

```text
FullAdder(a, b, c, sum, carry)
```

![](media/figure_2.3.png)

**Figure 2.3** Full-adder, designed to add 3 bits.

A 16-bit adder chains full-adders across all bit positions.

![](media/figure_2.4.png)

**Figure 2.4** 16-bit adder, designed to add two 16-bit numbers, with an example of addition action (on the left).

Mental model:

```text
bit 0 produces carry into bit 1
bit 1 produces carry into bit 2
...
bit 15 produces overflow, which Hack ignores
```

The incrementer is a special adder:

```text
Inc16(in) = in + 1
```

![](media/figure_wo_caption_2.2.png)

It will later help the program counter move to the next instruction.

##### 2.5.2 The Arithmetic Logic Unit

The ALU is the main computation chip of the Hack computer.

Inputs:

```text
x[16]
y[16]
```

Control bits:

```text
zx nx zy ny f no
```

Outputs:

```text
out[16]
zr
ng
```

![](media/figure_2.5a.png)

**Figure 2.5a** The Hack ALU, designed to compute the eighteen arithmetic-logical functions shown on the right. The symbols `!`, `&`, and `|` represent the 16-bit operations `Not`, `And`, and `Or`. For now, ignore the `zr` and `ng` output bits.

The six control bits describe a small processing pipeline:

```text
maybe zero x
maybe negate x
maybe zero y
maybe negate y
choose Add or And
maybe negate output
```

![](media/figure_2.5b.png)

**Figure 2.5b** Taken together, the values of the six control bits `zx`, `nx`, `zy`, `ny`, `f`, and `no` cause the ALU to compute one of the functions listed in the rightmost column.

This tiny control scheme can produce the Hack machine's needed arithmetic and logical functions:

```text
0, 1, -1
x, y
!x, !y
-x, -y
x+1, y+1
x-1, y-1
x+y
x-y, y-x
x&y
x|y
```

The status outputs summarize the result:

```text
zr = 1 if out is zero
ng = 1 if out is negative
```

![](media/figure_2.5c.png)

**Figure 2.5c** The Hack ALU API.

These flags later help the CPU decide whether to jump.

#### 2.6 Implementation

The chapter gives sparse implementation guidance on purpose.

The learner must derive the HDL designs.

The adder path is:

```text
HalfAdder from basic gates
FullAdder from HalfAdders
Add16 from FullAdders
Inc16 from Add16 or equivalent logic
```

The 16-bit adder is a ripple-carry design:

```text
carry ripples from low bit to high bit
```

Conceptually the bits depend on each other in order, even though HDL describes the chip structurally.

The ALU implementation follows the control-bit pipeline:

```text
preprocess x
preprocess y
compute x+y or x&y
optionally negate output
compute zr and ng
```

#### 2.7 Project

Project 2 asks you to implement:

```text
HalfAdder
FullAdder
Add16
Inc16
ALU
```

The building blocks are Chapter 1 gates and the chips completed earlier in the project.

The book recommends using built-in versions of Chapter 1 chips instead of copying Project 1 HDL files. This makes Project 2 faster and keeps the focus on arithmetic.

The same rules still apply:

- use only specified chips
- prefer simple correct HDL
- do not invent unnecessary helper chips
- test each chip with the supplied scripts

#### 2.8 Perspective

The adder design prioritizes clarity.

A ripple-carry adder is easy to understand:

```text
each bit waits for carry from the previous bit
```

But it can be slow because carry may need to travel through many positions.

Real hardware can use faster designs such as carry-lookahead adders, but those optimizations are outside the book's main path.

The Hack ALU is also intentionally small. Expensive operations like multiplication, division, and square root are not built directly into the hardware.

Instead:

```text
simple hardware
more work in software
```

This is a recurring systems trade-off.

### 3 Memory

Chapter 3 moves from combinational logic to sequential logic.

Combinational chips compute outputs from current inputs:

```text
current inputs -> logic -> current output
```

Memory chips must also remember previous values:

```text
current inputs + previous state -> next state/output
```

The construction ladder is:

```text
DFF
  -> Bit
  -> Register
  -> RAM8
  -> RAM64
  -> RAM512
  -> RAM4K
  -> RAM16K
  -> PC
```

The main idea is:

```text
DFF gives one bit of time-delayed state.
Registers group bits into words.
RAM groups registers and adds addressing.
PC is a controlled register for instruction flow.
```

#### 3.1 Memory Devices

Programs need values that persist.

Examples:

```text
variables
arrays
objects
current instruction address
temporary computation results
```

Combinational logic cannot store these values because it has no memory. If its inputs disappear or change, its output changes too.

The chapter introduces a primitive sequential chip:

```text
DFF = Data Flip-Flop
```

The book treats `DFF` as a built-in building block.

From that one primitive, the chapter builds the useful memory hierarchy:

![](media/figure_3.1.png)

**Figure 3.1** The memory hierarchy built in this chapter.

Mental model:

```text
DFF stores one delayed bit.
Everything else is structure and control around many DFFs.
```

#### 3.2 Sequential Logic

Sequential logic adds time to Boolean logic.

Combinational logic:

```text
out = function(current inputs)
```

Sequential logic:

```text
out = function(current inputs, stored state)
```

That stored state comes from earlier clock cycles.

##### 3.2.1 Time Matters

Real gates do not update instantly.

Signals need time to travel, and gate outputs need time to stabilize.

Instead of modeling every tiny delay, the book uses discrete time:

```text
cycle 0
cycle 1
cycle 2
...
```

![](media/figure_3.2.png)

**Figure 3.2** Discrete time representation: state changes are observed only during cycle transitions, while within-cycle fluctuations are ignored.

The clock gives the machine a shared rhythm.

During a cycle:

```text
combinational logic computes
```

At the cycle boundary:

```text
stateful chips commit their next values
```

This works as long as the clock cycle is long enough for the slowest needed computation to settle.

##### 3.2.2 Flip-Flops

The `DFF` is the primitive one-bit memory device.

Its behavior is:

```text
out(t) = in(t - 1)
```

Meaning:

```text
the input from the previous time step becomes the output now
```

![](media/figure_3.3.png)

**Figure 3.3** The data flip-flop and its behavior over time.

This one-cycle delay is the key.

It lets the computer separate:

```text
old state used during this cycle
new state committed for the next cycle
```

##### 3.2.3 Combinational and Sequential Logic

Combinational chips contain no memory.

Sequential chips contain `DFF`s directly or indirectly.

![](media/figure_3.4.png)

**Figure 3.4** Sequential logic design typically combines `DFF`s with combinational chips and feedback paths.

The safe pattern is:

```text
old state -> combinational logic -> DFF -> next state
```

Feedback without delay can create circular dependency inside the same moment.

Feedback through a `DFF` is safe because the `DFF` delays the value until the next cycle.

#### 3.3 Specification

The chapter specifies the memory chips needed by the Hack platform.

The abstractions are:

```text
DFF       -> primitive one-bit delay
Bit       -> controlled 1-bit register
Register  -> controlled 16-bit register
RAM       -> addressable collection of registers
PC        -> register with reset/load/increment behavior
```

##### 3.3.1 Data Flip-Flop

The `DFF` has one data input and one data output.

Its rule is:

```text
out(t) = in(t - 1)
```

In plain language:

```text
whatever was at input last cycle appears at output this cycle
```

The `DFF` is small, but architecturally important. It is the source of all persistent state in the chapter.

##### 3.3.2 Registers

The chapter defines two register abstractions:

```text
Bit       -> stores 1 bit
Register  -> stores 16 bits
```

Both use a `load` control bit.

For the 1-bit register:

```text
Bit(in, load, out)
```

![](media/figure_3.5.png)

**Figure 3.5** 1-bit register (`Bit`).

Behavior:

```text
if load = 0:
    keep old value

if load = 1:
    store in on the next clock cycle
```

For the 16-bit register:

```text
Register(in[16], load, out[16])
```

![](media/figure_3.6.png)

**Figure 3.6** 16-bit `Register`.

Behavior:

```text
if load = 0:
    keep the old 16-bit word

if load = 1:
    store the new 16-bit input on the next clock cycle
```

Mental model:

```text
Bit stores one bit.
Register is sixteen Bit chips in parallel.
```

##### 3.3.3 Random Access Memory

RAM is many registers plus addressing.

The address chooses which register you are talking to.

Generic RAM behavior:

```text
in      = value you may want to store
load    = whether to write
address = where to read/write
out     = value currently stored at that address
```

![](media/figure_3.7.png)

**Figure 3.7** A RAM chip as a collection of addressable `Register` chips.

Reading:

```text
address selects which stored word appears at out
```

Writing:

```text
if load = 1:
    store in into the selected address on the next clock cycle
```

Random access means the address can select any location directly. You do not have to scan through earlier locations first.

##### 3.3.4 Counter

The `PC`, or Program Counter, is a special register.

It stores the address of the instruction that should run next.

It must support four behaviors:

```text
reset to 0
load a specific value
increment by 1
hold current value
```

![](media/figure_3.8.png)

**Figure 3.8** Program Counter (`PC`).

The `PC` is still a register underneath. The extra control bits decide what value should be stored next.

#### 3.4 Implementation

The implementation strategy is the same throughout the chapter:

```text
store state in DFFs/registers
use combinational logic to choose the next value
commit the chosen value on the next clock cycle
```

##### 3.4.1 Data Flip-Flop

The book does not ask you to build `DFF` from gates.

It treats `DFF` as primitive.

Reason:

```text
DFF implementation requires lower-level timing details
Chapter 3 wants to focus on memory architecture
```

So the simulator provides `DFF` as a built-in chip.

##### 3.4.2 Registers

A raw `DFF` stores its input every cycle.

A useful 1-bit register needs a choice:

```text
store the new input
or
keep the old value
```

The `Bit` chip gets this behavior by placing a `Mux` before the `DFF`.

![](media/figure_3.9.png)

**Figure 3.9** Invalid and correct implementations of the `Bit` register.

Conceptually:

```text
                 +-----+
old out -------->|     |
in ------------->| Mux |----> DFF ----> out
load ----------->|     |
                 +-----+
```

If `load = 0`:

```text
Mux selects old out
DFF receives old out
Bit keeps its value
```

If `load = 1`:

```text
Mux selects in
DFF receives in
Bit updates on the next clock cycle
```

A 16-bit `Register` is then built from sixteen `Bit` chips:

```text
Bit 0  stores in[0]
Bit 1  stores in[1]
...
Bit 15 stores in[15]
```

All sixteen share the same `load` signal, so the whole word updates together.

##### 3.4.3 RAM

RAM is built recursively.

The hierarchy is:

```text
RAM8
  -> RAM64
  -> RAM512
  -> RAM4K
  -> RAM16K
```

![](media/figure_wo_caption_3.1.png)

The basic idea for `RAM8` is:

```text
8 registers
one address selects one register
```

Reading uses a multiplexer:

```text
all register outputs go into a Mux
address chooses which output appears at RAM out
```

Writing uses a demultiplexer:

```text
global load goes into a DMux
address chooses which register receives load = 1
```

All registers can receive the same input bus, but only the selected register is told to load it.

For larger RAM, the same pattern repeats.

Example:

```text
RAM64 = 8 RAM8 chips
```

The address is split conceptually:

```text
low bits  -> select inside a small block
high bits -> select which block
```

Mental model:

```text
RAM = registers + read selection + write selection
```

##### 3.4.4 Counter

The counter is implemented from:

```text
Register
Incrementer
Mux/control logic
```

The combinational logic chooses the next value.

Possible next values:

```text
0              for reset
in             for load
current + 1    for increment
current        for hold
```

The register stores whichever value the control logic selects.

The general pattern is:

```text
current state -> combinational next-state logic -> register -> next state
```

#### 3.5 Project

Project 3 asks you to implement the memory chips.

The chips include:

```text
Bit
Register
RAM8
RAM64
RAM512
RAM4K
RAM16K
PC
```

The allowed building blocks are:

```text
DFF
chips built earlier in Project 3
gates from Chapters 1 and 2
```

The project is split into two folders for simulator performance:

```text
projects/03/a -> smaller memory chips
projects/03/b -> larger memory chips
```

The recommended workflow is the same as before:

```text
read specification
implement in HDL
run supplied test
fix until the compare file matches
```

#### 3.6 Perspective

Real flip-flops can be built from lower-level gates using carefully designed feedback circuits.

The book hides that detail because Chapter 3 is about the architectural use of memory, not transistor-level timing.

Modern memory technologies are also not always built literally as textbook flip-flops. Real systems use many optimized memory technologies.

But the abstractions remain fundamental:

```text
registers store words
RAM stores addressable words
counters store and update control positions
```

Together with the ALU from Chapter 2, these memory devices provide the remaining hardware pieces needed to build the CPU and the larger Hack computer.
