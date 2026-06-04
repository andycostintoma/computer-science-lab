## Preface

The Preface frames computing as the part of the modern BANG quartet that can be fully understood by construction. The authors argue that modern computer systems hide their essential ideas under many specialized layers, and that the best way to recover a coherent understanding is to build a complete system from first principles.

Nand to Tetris is presented as that construction path: start with the primitive Nand gate, build a hardware platform and software hierarchy, and end with a general-purpose computer capable of running Tetris and other programs. The second edition exists to close gaps between the original book and the evolving online materials, improve clarity, and make the two-part hardware/software structure explicit.

### Scope

The book covers a compact but broad slice of applied computer science through hands-on projects. Its scope includes hardware, architecture, low-level languages, virtual machines, high-level languages, compilers, operating systems, algorithms, data structures, and software engineering.

The unifying constraint is practical: include the minimal set of concepts needed to build a working general-purpose computer that can run programs written in a high-level object-based language. This keeps the material cohesive instead of presenting isolated subfields.

### Courses

Nand to Tetris can fit several course shapes: an early systems-oriented course, a late synthesis course, a combined architecture/compiler course, a short standalone hardware or software course, or a full semester-long experience.

The hardware part requires no prior background, while the software part assumes introductory programming. The course is also positioned as useful beyond computer science majors, especially for learners and developers who want to understand what sits beneath high-level programming.

### Resources

The book is supported by the freely available Nand to Tetris software suite and website. These provide the simulators, emulators, executable tools, tutorials, project materials, test programs, and test scripts needed to build and test the system incrementally on common operating systems.

### Structure

[Part I](#i-hardware) covers hardware in chapters [1](#1-boolean-logic)–[6](The_Elements_of_Computing_Systems_2021.md#6-assembler): Boolean logic, Boolean arithmetic, memory, machine language, computer architecture, and assemblers. Part [II](The_Elements_of_Computing_Systems_2021.md#ii-software) covers software in chapters [7](The_Elements_of_Computing_Systems_2021.md#7-virtual-machine-i-processing)–[12](The_Elements_of_Computing_Systems_2021.md#12-operating-system): virtual machines, a high-level language, compiler construction, and an operating system. Chapter [13](The_Elements_of_Computing_Systems_2021.md#13-more-fun-to-go) and the appendices extend the journey and supply supporting technical material.

Each chapter follows the same abstraction-implementation pattern: introduce the concept, specify the abstraction, discuss an implementation, assign a project, and close with perspective. This makes every layer understandable both as a black-box service and as something that can be built.

### Projects

The projects are the core of the learning method: the computer is meant to be built, not merely read about. Learners implement chips in HDL, write an assembler, virtual machine, and compiler in a language of their choice, write machine-language and Jack programs, and complete a small operating system.

The projects are designed to be focused and manageable. They rely on supplied tools and tests, assume clean inputs where appropriate, and deliberately avoid optimization except where it is central to the lesson.

### The Second Edition

The second edition clarifies the book's two independent arcs: Hardware and Software. It adds new introductions, appendices, figures, examples, and sections that respond to learner questions accumulated from years of course use.

The revision also strengthens the abstraction-versus-implementation theme, making the distinction explicit throughout the chapters and project materials.

### Acknowledgments

The authors credit the students, teaching assistants, editors, course-material contributors, and global Nand to Tetris community who helped build and sustain the book, tools, projects, and forums.

Special attention is given to Mark Armbrust, who supported learners for years through the Q&A forum, fixed bugs, wrote scripts, and became a central figure in the community. The Preface closes by emphasizing the authors' gratitude for the open educational ecosystem that formed around the freely available materials.

## I Hardware

### Introduction

[Part I](#i-hardware) is introduced as a hands-on voyage into how computer systems work, how complex systems are decomposed into modules, and how large hardware and software systems are built. The point is not merely to end with a computer, but to learn systems thinking by constructing one layer at a time.

#### Hello, World Below

The familiar `Hello` `World` program hides a deep stack of abstractions. A high-level text program must be parsed, understood, compiled into machine language, executed by a hardware architecture, implemented by chips, reduced to logic gates, and eventually grounded in physical switching devices.

![](media/figure_wo_caption_I.1.png)

The section argues that most programmers see only the top of the iceberg. Nand to Tetris is about going below that surface and understanding the hidden machinery by building a complete computer system from the ground up.

#### Nand to Tetris

Every general-purpose computer can be understood as a Nand-to-Tetris machine: it is ultimately built from elementary logic gates and can run arbitrary programs. The specific Hack hardware platform and Jack language are chosen because they are small, stable, understandable, and extensible, not because they are industrial standards.

![](media/figure_I.1.png)

The roadmap shows a hardware platform and software hierarchy connected through abstraction and implementation. High-level software is progressively translated downward; hardware is progressively built upward. The same ideas and techniques apply to real hardware and software engineering.

#### Abstraction and Implementation

The central method is modular design. Each module has an abstraction, which describes what it does, and an implementation, which describes how it does it. When using a module, the engineer should depend only on its interface and ignore its internal construction.

This discipline makes large systems manageable. It allows chips, translators, and software services to be built, tested, and reasoned about independently. Good abstractions localize complexity; poor modular design makes the whole system difficult to build and maintain.

#### Methodology

[Part I](#i-hardware) builds roughly thirty gates and chips using HDL and tests them in a software-based hardware simulator. This mirrors real hardware engineering practice, where chip specifications are designed and validated in software before being fabricated.

Part [II](The_Elements_of_Computing_Systems_2021.md#ii-software) later builds the software stack: assembler, virtual machine, compiler, and a small operating system. The projects are made feasible through scaffolding: APIs, skeletons, test scripts, staged guidance, and supplied tools from the Nand to Tetris software suite.

#### The Road Ahead

The full journey contains twelve construction projects. Across projects, the path is bottom-up, starting from Nand gates and rising toward high-level programs. Within each project, the work is top-down: first understand the abstraction, then implement it using lower-level building blocks.

[Part I](#i-hardware) builds elementary gates, an ALU, memory devices, machine language, the CPU/RAM-based hardware platform, and an assembler. That completed Hack platform becomes the starting point for Part [II](The_Elements_of_Computing_Systems_2021.md#ii-software), where the system is extended with a virtual machine, compiler, and operating system.

### 1 Boolean Logic

Digital systems are built from chips that store and process binary information. This chapter begins with one primitive gate, Nand, and uses it to construct the standard logic gates needed later for the Hack computer: basic gates, 16-bit variants, multiplexers, demultiplexers, and multi-way versions.

The main idea is that hardware design separates abstraction from implementation. Boolean algebra specifies what a gate does, HDL describes how gates are composed, and the hardware simulator tests whether the implementation behaves as promised.

#### 1.1 Boolean Algebra

Boolean algebra works with two values, represented here as `0` and `1`. Boolean functions map binary inputs to binary outputs, making them the natural language for specifying hardware behavior.

The familiar operators And, Or, and Not are only one convenient basis for expressing Boolean functions. Their symbolic forms include $x \cdot y$, $x + y$, $\bar{x}$, and $x \land y$, $x \lor y$. More importantly, every Boolean function can be built from Nand alone, which is why Nand can serve as the primitive gate for the whole computer.

![](media/figure_1.1.png)

![](media/figure_1.2.png)

The space of Boolean functions grows quickly: for two variables, the book enumerates all possible functions, and for *n* variables the count is described using $n = 2$ and $2^{2^n}$.

##### Boolean Functions

A Boolean function can be represented either by a truth table or by a Boolean expression. A truth table lists every possible input tuple and the corresponding output; an expression gives a symbolic rule for computing the same result.

The chapter illustrates this equivalence with a three-variable function involving $(x, y, z)$, $2^3 = 8$, $f(x, y, z)$, and an expression like $(x \lor y)$ And Not (`z`).

![](media/figure_1.3.png)

##### Truth Tables and Boolean Expressions

Expressions can always be evaluated into truth tables, and truth tables can also be synthesized into expressions. This translation matters because real design requirements may arrive as truth-table behavior, while implementation typically proceeds through expressions and gates.

Different expressions can represent the same function, so simplification is the first form of hardware optimization: fewer or simpler expressions can lead to fewer gates, lower cost, and faster circuits.

#### 1.2 Logic Gates

A logic gate is a physical realization of a Boolean function. The physical technology can vary, but the abstract behavior remains the same, which lets computer scientists reason in terms of Boolean algebra without depending on transistor-level details.

![](media/figure_1.4.png)

##### Primitive and Composite Gates

Because all gates consume and produce binary values, they can be composed. A three-input And can be built by connecting two two-input And gates, using a result such as $And(a, b, c) = And(And(a, b), c)$.

![](media/figure_1.5.png)

The key distinction is between a gate's interface and its implementation. The interface says what the gate exposes to users; the implementation describes the internal arrangement of lower-level gates.

Xor demonstrates the same idea: its interface is fixed, but it can be implemented in multiple ways. One construction uses Not, And, and Or with the relation $Xor(a, b) = Or(And(a, Not(b)), And(Not(a), b))$.

![](media/figure_1.6.png)

Logic design is therefore the practice of taking a gate specification and finding an efficient implementation from already available gates.

#### 1.3 Hardware Construction

Physical chip construction by hand is impractical: it is hard to verify, hard to debug, and hard to reproduce. Modern hardware construction instead uses formal descriptions and simulation before any physical manufacturing happens.

##### 1.3.1 Hardware Description Language

Hardware Description Language lets designers specify chip architecture as text. An HDL program declares a chip interface and lists the lower-level parts and pin connections that implement it.

![](media/figure_1.7.png)

The Xor example shows how the chip header names the inputs and outputs, while the `PARTS` section wires together existing gates. Internal pins are created by naming intermediate connections, and fan-out is expressed by reusing the same signal in multiple places. The figure also contains the function notation $Xor(a, b) = Or(And(a, Not(b)), And(Not(a), b))$.

##### Testing

Hardware designs are tested with repeatable scripts. A test script loads the HDL file, sets input combinations, evaluates outputs, and compares the results against expected values.

For simple gates, exhaustive testing is possible because all inputs can be enumerated. For larger chips, testing still provides disciplined empirical confidence even when exhaustive proof is unrealistic.

##### 1.3.2 Hardware Simulation

The hardware simulator parses HDL programs and runs them against test scripts. It supports the book's full hardware path, from simple gates to the complete computer.

![](media/figure_1.8.png)

The simulator state, expected compare file, and generated output together make chip behavior inspectable and reproducible. The example also references a simulation step with $(a, b, out) = (1, 1, 0)$.

#### 1.4 Specification

This section specifies the family of gates required to build the later chips. The emphasis is on the interface: what each gate should do, independent of how it will be built.

##### 1.4.1 Nand

Nand is the primitive starting point of the architecture. Its behavior is given externally, and all later gates can be constructed from it.

![](media/figure_wo_caption_1.1.png)

![](media/figure_wo_caption_1.2.png)

##### 1.4.2 Basic Logic Gates

The basic gates include Not, And, Or, Xor, Multiplexer, and Demultiplexer. These become the reusable vocabulary for building more complex chips.

![](media/figure_wo_caption_1.3.png)

![](media/figure_wo_caption_1.4.png)

![](media/figure_wo_caption_1.5.png)

![](media/figure_wo_caption_1.6.png)

A multiplexer selects one of two data inputs according to a selector bit, while a demultiplexer routes one input to one of two outputs and sets the other output to `0`.

![](media/figure_1.9.png)

![](media/figure_1.10.png)

##### 1.4.3 Multi-Bit Versions of Basic Gates

Computer hardware often processes words rather than single bits, so the basic gates are generalized to *n*-bit versions. These apply the same operation independently across corresponding bits. Bit indexing is also introduced, with examples like `out[3] = in[5]`.

![](media/figure_wo_caption_1.7.png)

![](media/figure_wo_caption_1.8.png)

![](media/figure_wo_caption_1.9.png)

![](media/figure_wo_caption_1.10.png)

##### 1.4.4 Multi-Way Versions of Basic Gates

Multi-way gates generalize basic gates across more than two inputs or outputs. The chapter introduces multi-way Or, multi-way multi-bit multiplexers, and multi-way demultiplexers.

![](media/figure_wo_caption_1.11.png)

Selection among multiple inputs is controlled by selector bits, with the number of selector bits expressed using $k = \log_2 m$.

![](media/figure_wo_caption_1.12.png)

![](media/figure_wo_caption_1.13.png)

Demultiplexers apply the same selection idea in the opposite direction, using selector bits as indicated by $k = \log_2 m$.

![](media/figure_wo_caption_1.14.png)

![](media/figure_wo_caption_1.15.png)

#### 1.5 Implementation

After specifying what the gates do, the chapter turns to how they can be implemented. It distinguishes between behavioral simulation, which helps experiment with interfaces, and HDL implementation, which builds the actual hardware logic.

##### 1.5.1 Behavioral Simulation

Behavioral simulation models chip behavior in software without requiring the chip to be implemented in HDL. This is useful for exploration and for allowing progress when lower-level implementations are not yet complete.

The Nand to Tetris simulator includes built-in versions of the project chips. A built-in chip has the same interface as the real HDL version, but its behavior is supplied by the simulator.

![](media/figure_wo_caption_1.16.png)

##### 1.5.2 Hardware Implementation

The implementation path starts from primitive Nand and gradually builds every required gate. Not can be made from one Nand; And, Or, Xor, multiplexers, demultiplexers, multi-bit gates, and multi-way gates are then built from previously completed gates.

The recommended style is incremental: once a gate is implemented, use it as a building block for the next gate instead of repeatedly dropping down to raw Nand.

##### 1.5.3 Built-In Chips

The simulator resolves chip-parts by looking first in the current folder and then in the built-in tools folder. This makes built-ins a safety net: if a chip implementation is missing or temporarily renamed, the simulator can use the built-in version instead.

This behavior is useful during project work because it lets learners continue building higher-level chips even if a lower-level chip is incomplete.

#### 1.6 Project

Project 1 asks the learner to implement the logic gates from the chapter using only primitive Nand and the composite gates built along the way. The required work happens in `nand2tetris/projects/01`, using supplied `.hdl` stubs, `.tst` test scripts, and `.cmp` compare files.

The contract is simple: each completed HDL chip must produce the expected output when run through the supplied test. The recommended workflow is to consult the HDL appendix, use the hardware simulator tutorial as needed, and build/test the chapter's chips in order.

##### General Implementation Tips

- Prefer the simplest correct implementation.
- Reuse composite gates already built instead of implementing every chip directly from Nand.
- Do not invent helper chips outside the chapter's specified chip set.
- Build gates in chapter order, and rely on built-in chips only as a temporary fallback when necessary.

#### 1.7 Perspective

Chapter [1](#1-boolean-logic) establishes the elementary logic gate toolbox used by later processing and memory chips. Although this book uses Nand as the primitive foundation, other complete bases such as Nor or combinations of And, Or, and Not are theoretically equivalent.

The chapter intentionally avoids physical engineering details and low-level efficiency concerns. Its goal is to teach the abstract logic-design layer that sits between Boolean functions and the larger chips built in the next chapters.

### 2 Boolean Arithmetic

Chapter 2 moves from Boolean logic gates to arithmetic chips. The chapter starts with binary number representation, develops adders, and culminates in the Hack Arithmetic Logic Unit, which later becomes the computational core of the CPU.

The main theme is reduction: many machine-level arithmetic and logical operations can be built from binary addition, bitwise operations, and carefully chosen control signals. Two's complement representation is especially important because it lets the same addition hardware handle both nonnegative and signed integers.

#### 2.1 Arithmetic Operations

General-purpose computers need arithmetic operations such as addition, sign conversion, subtraction, comparison, multiplication, and division. This chapter focuses first on addition and sign conversion, because later operations can be implemented from these simpler building blocks.

Addition is treated as a foundational operation. Understanding binary addition explains not only arithmetic circuits but also a large part of how digital hardware reduces complex behavior to simple bit-level processing.

#### 2.2 Binary Numbers

Binary representation works like decimal representation, but with base 2 instead of base 10. Each bit's contribution depends on its position, and a binary code represents the weighted sum of powers of two.

![](media/2-1.png)

![](media/2-2.png)

Computers represent everything internally with binary codes, even when users interact with decimal numbers or screen characters. Decimal notation is a human-facing convention; the machine must convert between human-readable decimal forms and internal binary forms when necessary.

Because computers are finite machines, integer values are represented using a fixed word size. An `n`-bit word can represent `2^n` distinct values. If all values are nonnegative, the range is `0` through `2^n - 1`; representing values outside the fixed range requires larger or multi-word representations.

#### 2.3 Binary Addition

Binary numbers are added from right to left, just like decimal numbers. The least significant bits are added first, and each addition may produce a carry that feeds into the next more significant bit.

![](media/figure_wo_caption_2.1.png)

If the most significant addition produces a carry beyond the fixed word size, the result overflows. The Hack hardware ignores overflow and guarantees only the low `n` bits of an `n`-bit addition result.

#### 2.4 Signed Binary Numbers

Signed binary numbers divide the available code space between nonnegative and negative values. The dominant representation is two's complement, where the `n`-bit representation of `-x` is the code for `2^n - x`.

![](media/figure_2.1.png)

**Figure 2.1** Two's complement representation of signed numbers, in a 4-bit binary system.

In two's complement, an `n`-bit system represents values from `-2^(n-1)` through `2^(n-1) - 1`. Nonnegative numbers begin with `0`, negative numbers begin with `1`, and negating a number can be done by flipping all bits and adding `1`.

The key hardware payoff is that subtraction becomes addition: `x - y` can be computed as `x + (-y)`. This means the same binary adder can handle signed addition and subtraction without special signed-number hardware.

#### 2.5 Specification

The chapter specifies a hierarchy of arithmetic chips. As usual, the specification describes what each chip does before discussing how to build it.

##### 2.5.1 Adders

The adder hierarchy starts with a half-adder, which adds two bits and produces a `sum` and `carry`. A full-adder adds three bits, allowing it to include an incoming carry from a less significant bit.

![](media/figure_2.2.png)

**Figure 2.2** Half-adder, designed to add 2 bits.

![](media/figure_2.3.png)

**Figure 2.3** Full-adder, designed to add 3 bits.

A multi-bit adder chains this idea across a fixed-width word. For Hack, the important version is a 16-bit adder that adds two 16-bit inputs and outputs the low 16 bits of the result.

![](media/figure_2.4.png)

**Figure 2.4** 16-bit adder, designed to add two 16-bit numbers, with an example of addition action (on the left).

The chapter also specifies an incrementer, a special-purpose chip that adds `1` to a 16-bit input. This will later support advancing to the next instruction address.

![](media/figure_wo_caption_2.2.png)

##### 2.5.2 The Arithmetic Logic Unit

The Hack ALU computes a selected arithmetic or logical function over two 16-bit inputs, `x` and `y`. It is controlled by six 1-bit control inputs: `zx`, `nx`, `zy`, `ny`, `f`, and `no`.

![](media/figure_2.5a.png)

**Figure 2.5a** The Hack ALU, designed to compute the eighteen arithmetic-logical functions shown on the right. The symbols `!`, `&`, and `|` represent the 16-bit operations `Not`, `And`, and `Or`. For now, ignore the `zr` and `ng` output bits.

The control bits are interpreted as a sequence of simple micro-actions. The ALU may zero and/or negate each input, then choose between bitwise And and addition, then optionally negate the final output.

![](media/figure_2.5b.png)

**Figure 2.5b** Taken together, the values of the six control bits `zx`, `nx`, `zy`, `ny`, `f`, and `no` cause the ALU to compute one of the functions listed in the rightmost column.

This small control scheme is enough to produce the eighteen documented Hack ALU functions, including constants, identity operations, negation, increment/decrement, addition, subtraction, And, and Or. The six control bits actually encode sixty-four possible operations, but Hack uses only the subset needed by its instruction set.

The ALU also outputs `zr` and `ng`. `zr` reports whether the result is zero, and `ng` reports whether the result is negative. These status bits will later drive CPU branching decisions.

![](media/figure_2.5c.png)

**Figure 2.5c** The Hack ALU API.

#### 2.6 Implementation

The implementation guidance is intentionally sparse. The learner is expected to derive a logic design, write HDL, and test it with the supplied hardware simulator.

The half-adder can be built directly from logic gates already seen in Project 1. The full-adder can be built from two half-adders plus an additional gate. The 16-bit adder is a ripple-style design: each bit position uses the carry from the previous position.

Although the HDL describes all bit positions at once, the carry values conceptually propagate from least significant bit to most significant bit. Timing and synchronization are deferred until the memory chapter.

The ALU implementation follows the pseudocode implied by the control bits. The main work is building reusable patterns for zeroing, negating, selecting between And and Add, optionally negating the output, and deriving the `zr` and `ng` flags.

#### 2.7 Project

Project 2 asks the learner to implement the arithmetic chips from the chapter: adders, incrementer, and ALU. The required building blocks are the Chapter 1 gates and the chips built progressively during the project.

The book recommends using built-in versions of Chapter 1 chips rather than copying Project 1 HDL files into the Project 2 folder. Built-ins are guaranteed to match the specification and make the simulator faster.

The same constraints from Project 1 still apply: use only specified chips, prefer simple correct HDL, and avoid inventing extra helper chips.

#### 2.8 Perspective

The chapter's adder design prioritizes clarity over efficiency. A ripple-carry adder is easy to understand, but it can be slow because each carry must propagate through the word. Faster hardware can use carry-lookahead techniques, but those optimizations are outside this course's main path.

The Hack ALU deliberately provides only a small hardware feature set. Operations like multiplication, division, and square root are left to the operating system, where they can be implemented in software using lower-level ALU operations.

This division of labor is a recurring systems trade-off: hardware implementations are faster but more expensive, while software implementations keep the hardware simple and shift complexity upward into system services.

### 3 Memory

Chapter 3 moves from combinational chips to sequential chips. The core problem is persistence over time: arithmetic chips can transform values, but a computer also needs devices that can remember state across clock cycles.

The chapter introduces discrete time, the clocked Data Flip-Flop, registers, RAM hierarchies, and the program counter. The main systems idea is that memory emerges from feedback plus controlled delay, and that fast random access emerges from putting combinational selection logic on top of large banks of registers.

#### 3.1 Memory Devices

Programs rely on variables, arrays, and objects that persist over time, so the hardware platform must offer stateful memory devices. Classical combinational logic cannot do this by itself because it has no notion of past versus present state.

The chapter therefore introduces the Data Flip-Flop (`DFF`) as the primitive sequential building block. Larger devices like `Bit`, `Register`, RAM, and `PC` are all built on top of it.

![](media/figure_3.1.png)

**Figure 3.1** The memory hierarchy built in this chapter.

#### 3.2 Sequential Logic

Sequential logic extends the earlier Boolean logic model with time. Combinational chips depend only on current inputs; sequential chips depend on current inputs plus state that was committed in previous cycles.

##### 3.2.1 Time Matters

Real chips are not instantaneous: signals take time to travel and gate networks take time to stabilize. The book handles this complexity by modeling time discretely as cycles instead of continuously.

![](media/figure_3.2.png)

**Figure 3.2** Discrete time representation: state changes are observed only during cycle transitions, while within-cycle fluctuations are ignored.

This abstraction solves two problems at once. First, it hides transient propagation delays as long as the clock cycle is longer than the slowest computation. Second, it synchronizes the entire machine so that all stateful elements commit their updates together at cycle boundaries.

##### 3.2.2 Flip-Flops

The `DFF` is the primitive memory element used throughout the chapter. Its behavior is `out(t) = in(t - 1)`: at the end of each cycle, it emits the input from the previous cycle.

![](media/figure_3.3.png)

**Figure 3.3** The data flip-flop and its behavior over time.

This one-cycle delay is what makes memory possible. Because all `DFF`s in the system share the same clock, they act like a synchronized substrate on which higher-level memory chips can be built.

##### 3.2.3 Combinational and Sequential Logic

Combinational chips ignore time and respond only to present input combinations. Sequential chips, by contrast, contain `DFF`s directly or indirectly, which lets them respond to previously stored values.

![](media/figure_3.4.png)

**Figure 3.4** Sequential logic design typically combines `DFF`s with combinational chips and feedback paths.

The crucial design rule is that feedback without delay is problematic in combinational logic, but feedback through a `DFF` is safe because the delay breaks circular self-dependence within the same cycle. This also explains how a whole computer can be synchronized despite different signal travel times across the hardware.

#### 3.3 Specification

The chapter specifies the memory abstractions needed by the Hack platform: `DFF`, `Bit`, `Register`, RAM families, and `PC`. As usual, the focus is first on interface and behavior rather than implementation.

##### 3.3.1 Data Flip-Flop

The `DFF` is specified as the most elementary sequential device. It has one data input, one data output, a clock input, and the behavior `out(t) = in(t - 1)`.

Its importance is architectural rather than glamorous: every memory device later in the chapter relies on this primitive time-delayed state transition.

##### 3.3.2 Registers

The chapter specifies a 1-bit register named `Bit` and a 16-bit `Register`. Both have an `in` input, a `load` control bit, and an `out` output that continuously emits the currently stored value.

![](media/figure_3.5.png)

**Figure 3.5** 1-bit register (`Bit`).

![](media/figure_3.6.png)

**Figure 3.6** 16-bit `Register`.

The behavior is the same in both cases: when `load` is `1`, the device commits the input value and emits it from the next cycle onward; when `load` is `0`, it preserves the previous value.

##### 3.3.3 Random Access Memory

RAM is specified as an addressable collection of `Register` chips. The address selects one register, the output exposes the selected register's current contents, and the `load` bit determines whether the selected register should be updated on the next cycle.

![](media/figure_3.7.png)

**Figure 3.7** A RAM chip as a collection of addressable `Register` chips.

The key property is random access: selection time should be effectively independent of which register is chosen. The abstraction therefore behaves like a direct-access bank of memory words, even though it is implemented from many smaller chips.

##### 3.3.4 Counter

The `PC` chip is a specialized register that can do more than hold a value. It can preserve its value, load a new value, increment by `1`, or reset to `0`.

![](media/figure_3.8.png)

**Figure 3.8** Program Counter (`PC`).

This chip later becomes the program counter in the CPU. Its interface is register-like, but with extra `inc` and `reset` control bits layered on top of ordinary load behavior.

#### 3.4 Implementation

The implementation section explains how to realize the chapter's abstractions from lower-level sequential and combinational building blocks. The recurring strategy is to store state in registers and use selection logic to decide when and where new values should flow.

##### 3.4.1 Data Flip-Flop

Although `DFF`s can be built from feedback loops of primitive logic gates, the chapter treats them as built-in primitives. The simulator supplies a `DFF` implementation directly, which lets the learner focus on higher-level memory design.

##### 3.4.2 Registers

The `Bit` register is built by combining a `DFF` with a multiplexer. The design goal is: if `load` is asserted, feed the new input into the `DFF`; otherwise, feed back the previously stored output.

![](media/figure_3.9.png)

**Figure 3.9** Invalid and correct implementations of the `Bit` register.

The invalid design exposes why the multiplexer is necessary: a register needs both state preservation and conditional overwrite. The correct solution uses the `load` bit as the mux selector, routing either the new `in` value or the old stored value back into the `DFF`. A 16-bit `Register` then follows by instantiating sixteen `Bit` chips in parallel.

##### 3.4.3 RAM

The Hack RAM hierarchy is built recursively. The roadmap begins with `RAM8`, then grows to `RAM64`, `RAM512`, `RAM4K`, and `RAM16K`.

![](media/figure_wo_caption_3.1.png)

To read from RAM, combinational selection logic routes the chosen register's output to the chip's output. To write, the input bus is broadcast to all child registers, while address decoding plus the `load` signal ensures that only the selected register accepts the new value.

The important systems insight is that RAM gets its random-access property from combinational addressing logic. Hierarchical composition scales the memory size, while multiplexers and demultiplexers keep selection fast and direct.

##### 3.4.4 Counter

The counter is implemented by combining a `Register`, an incrementer from Chapter 2, and multiplexing logic that prioritizes `reset`, `load`, and `inc` behaviors.

The same pattern appears again: persistent storage comes from the register, while control flow comes from combinational logic deciding which next-state value should be written back on the next cycle.

#### 3.5 Project

Project 3 asks the learner to implement the memory chips of the chapter using the supplied HDL stubs, tests, and compare files. The permitted building blocks are the primitive `DFF`, the chips built earlier in the project, and gates from previous chapters.

The project uses two RAM subfolders for practical simulator reasons. Lower-level RAM chips live in `projects/03/a`, while higher-level ones live in `projects/03/b`, which encourages the simulator to use built-in versions of certain lower-level parts and prevents huge recursive in-memory constructions.

The recommended path is to consult the HDL appendix and hardware simulator tutorial as needed, then build the chips in the `projects/03` folder in order.

#### 3.6 Perspective

The perspective section notes that real flip-flops are usually built from lower-level combinational gates in carefully designed feedback configurations, but that this physical detail is intentionally abstracted away here.

The chapter also emphasizes that modern memory technologies are not necessarily implemented literally as textbook flip-flops, and that the recursive RAM constructions used in the course are elegant teaching designs rather than guaranteed optimal industrial ones.

Still, the abstractions are fundamental: registers, RAM, and counters are standard building blocks across computer systems. Combined with the ALU from Chapter 2, they provide the remaining hardware pieces needed to build the CPU and the larger machine architecture introduced in Chapter 5.


## Full Book Headings and Images Index

This index is auto-generated from `The_Elements_of_Computing_Systems_2021.md` and includes every heading and image in source order.

## Table of Contents

## Preface

### Scope

### Courses

### Resources

### Structure

### Projects

### The Second Edition

### Acknowledgments

## I Hardware

### Introduction

#### Hello, World Below

![](media/figure_wo_caption_I.1.png)

#### Nand to Tetris

![](media/figure_I.1.png)

#### Abstraction and Implementation

#### Methodology

#### The Road Ahead

### 1 Boolean Logic

#### 1.1 Boolean Algebra

![](media/figure_1.1.png)

![](media/figure_1.2.png)

##### Boolean Functions

![](media/figure_1.3.png)

##### Truth Tables and Boolean Expressions

#### 1.2 Logic Gates

![](media/figure_1.4.png)

##### Primitive and Composite Gates

![](media/figure_1.5.png)

![](media/figure_1.6.png)

#### 1.3 Hardware Construction

##### 1.3.1 Hardware Description Language

![](media/figure_1.7.png)

##### Testing

##### 1.3.2 Hardware Simulation

![](media/figure_1.8.png)

#### 1.4 Specification

##### 1.4.1 Nand

![](media/figure_wo_caption_1.1.png)

![](media/figure_wo_caption_1.2.png)

##### 1.4.2 Basic Logic Gates

![](media/figure_wo_caption_1.3.png)

![](media/figure_wo_caption_1.4.png)

![](media/figure_wo_caption_1.5.png)

![](media/figure_wo_caption_1.6.png)

![](media/figure_1.9.png)

![](media/figure_1.10.png)

##### 1.4.3 Multi-Bit Versions of Basic Gates

![](media/figure_wo_caption_1.7.png)

![](media/figure_wo_caption_1.8.png)

![](media/figure_wo_caption_1.9.png)

![](media/figure_wo_caption_1.10.png)

##### 1.4.4 Multi-Way Versions of Basic Gates

![](media/figure_wo_caption_1.11.png)

![](media/figure_wo_caption_1.12.png)

![](media/figure_wo_caption_1.13.png)

![](media/figure_wo_caption_1.14.png)

![](media/figure_wo_caption_1.15.png)

#### 1.5 Implementation

##### 1.5.1 Behavioral Simulation

![](media/figure_wo_caption_1.16.png)

##### 1.5.2 Hardware Implementation

##### 1.5.3 Built-In Chips

#### 1.6 Project

##### General Implementation Tips

#### 1.7 Perspective

### 2 Boolean Arithmetic

#### 2.1 Arithmetic Operations

#### 2.2 Binary Numbers

![](media/2-1.png)

![](media/2-2.png)

#### 2.3 Binary Addition

![](media/figure_wo_caption_2.1.png)

#### 2.4 Signed Binary Numbers

![](media/figure_2.1.png)

#### 2.5 Specification

##### 2.5.1 Adders

![](media/figure_2.2.png)

![](media/figure_2.3.png)

![](media/figure_2.4.png)

![](media/figure_wo_caption_2.2.png)

##### 2.5.2 The Arithmetic Logic Unit

![](media/figure_2.5a.png)

![](media/figure_2.5b.png)

![](media/figure_2.5c.png)

#### 2.6 Implementation

#### 2.7 Project

#### 2.8 Perspective

### 3 Memory

#### 3.1 Memory Devices

![](media/figure_3.1.png)

#### 3.2 Sequential Logic

##### 3.2.1 Time Matters

![](media/figure_3.2.png)

##### 3.2.2 Flip-Flops

![](media/figure_3.3.png)

##### 3.2.3 Combinational and Sequential Logic

![](media/figure_3.4.png)

#### 3.3 Specification

##### 3.3.1 Data Flip-Flop

##### 3.3.2 Registers

![](media/figure_3.5.png)

![](media/figure_3.6.png)

##### 3.3.3 Random Access Memory

![](media/figure_3.7.png)

##### 3.3.4 Counter

![](media/figure_3.8.png)

#### 3.4 Implementation

##### 3.4.1 Data Flip-Flop

##### 3.4.2 Registers

![](media/figure_3.9.png)

##### 3.4.3 RAM

![](media/figure_wo_caption_3.1.png)

##### 3.4.4 Counter

#### 3.5 Project

#### 3.6 Perspective

### 4 Machine Language

#### 4.1 Machine Language: Overview

##### 4.1.1 Hardware Elements

##### 4.1.2 Languages

##### 4.1.3 Instructions

![](media/figure_wo_caption_4.1.png)

![](media/figure_4.1.png)

#### 4.2 The Hack Machine Language

##### 4.2.1 Background

![](media/figure_4.2.png)

![](media/figure_4.3.png)

##### 4.2.2 Program Example

![](media/figure_4.4.png)

##### 4.2.3 The Hack Language Specification

![](media/figure_4.5.png)

##### The A-instruction

##### The C-instruction

![](media/figure_wo_caption_4.2.png)

##### 4.2.4 Symbols

![](media/figure_wo_caption_4.3.png)

##### 4.2.5 Input/Output Handling

![](media/figure_wo_caption_4.4.png)

##### 4.2.7 Syntax Conventions and File Formats

#### 4.3 Hack Programming

![](media/figure_4.6.png)

![](media/figure_4.7.png)

#### 4.4 Project

![](media/figure_4.8.png)

#### 4.5 Perspective

### 5 Computer Architecture

#### 5.1 Computer Architecture Fundamentals

##### 5.1.1 The Stored Program Concept

##### 5.1.2 The von Neumann Architecture

![](media/figure_5.1.png)

##### 5.1.3 Memory

##### 5.1.4 Central Processing Unit

##### 5.1.5 Input and Output

#### 5.2 The Hack Hardware Platform: Specification

##### 5.2.1 Overview

##### 5.2.2 Central Processing Unit

![](media/figure_5.2.png)

##### 5.2.3 Instruction Memory

![](media/figure_5.3.png)

##### 5.2.4 Input/Output

![](media/figure_5.4.png)

![](media/figure_5.5.png)

##### 5.2.5 Data Memory

![](media/figure_5.6.png)

##### 5.2.6 Computer

![](media/figure_5.7.png)

#### 5.3 Implementation

##### 5.3.1 The Central Processing Unit

![](media/figure_5.8.png)

##### 5.3.2 Memory

##### 5.3.3 Computer

![](media/figure_5.9.png)

#### 5.4 Project

![](media/figure_5.10.png)

#### 5.5 Perspective

### 6 Assembler

#### 6.1 Background

![](media/figure_6.1.png)

#### 6.2 The Hack Machine Language Specification

##### 6.2.1 Programs

![](media/figure_6.2.png)

##### 6.2.2 Symbols

##### 6.2.3 Syntax Conventions

#### 6.3 Assembly-to-Binary Translation

##### 6.3.1 Handling Instructions

##### 6.3.2 Handling Symbols

#### 6.4 Implementation

##### 6.4.1 Developing a Basic Assembler

##### The Parser

![](media/figure_wo_caption_6.1.png)

##### The Code Module

![](media/figure_wo_caption_6.2.png)

##### The Hack Assembler

##### 6.4.2 Completing the Assembler

##### The Symbol Table

![](media/figure_wo_caption_6.3.png)

#### 6.5 Project

![](media/figure_6.3.png)

#### 6.6 Perspective

## II Software

### Introduction

#### A Taste of Jack Programming

![](media/figure_II.1.png)

![](media/figure_II.2.png)

#### Program Compilation

![](media/figure_II.3.png)

### 7 Virtual Machine I: Processing

#### 7.1 The Virtual Machine Paradigm

![](media/figure_7.1.png)

#### 7.2 Stack Machine

##### 7.2.1 Push and Pop

![](media/figure_7.2.png)

##### 7.2.2 Stack Arithmetic

![](media/figure_wo_caption_7.1.png)

![](media/figure_7.3a.png)

![](media/figure_7.3b.png)

##### 7.2.3 Virtual Memory Segments

![](media/figure_7.4.png)

#### 7.3 VM Specification, Part I

##### Push / Pop Commands

![](media/1.png)

##### Arithmetic-Logical Commands

![](media/figure_7.5.png)

#### 7.4 Implementation

##### 7.4.1 Standard VM Mapping on the Hack Platform, Part I

![](media/figure_wo_caption_7.2.png)

![](media/figure_wo_caption_7.3.png)

##### Memory Segments Mapping

##### 7.4.2 The VM Emulator

![](media/figure_7.6.png)

##### 7.4.3 Design Suggestions for the VM Implementation

##### Program Structure

##### The Parser

![](media/figure_wo_caption_7.4.png)

##### The CodeWriter

![](media/figure_wo_caption_7.5.png)

##### The VM Translator

##### Implementation Tips

#### 7.5 Project

##### Testing and Implementation Stages

#### 7.6 Perspective

### 8 Virtual Machine II: Control

#### 8.1 High-Level Magic

#### 8.2 Branching

![](media/figure_8.1.png)

#### 8.3 Functions

![](media/figure_8.2.png)

![](media/figure_8.3.png)

![](media/figure_8.4.png)

#### 8.4 VM Specification, Part II

##### Branching Commands

##### Function Commands

##### VM Program

#### 8.5 Implementation

##### 8.5.1 Function Call and Return

![](media/figure_8.5.png)

##### 8.5.2 Standard VM Mapping on the Hack Platform, Part II

![](media/figure_wo_caption_8.1.png)

![](media/figure_8.6.png)

##### 8.5.3 Design Suggestions for the VM Implementation

##### The VMTranslator

##### The Parser

##### The CodeWriter

![](media/figure_wo_caption_8.2.png)

#### 8.6 Project

##### Testing and Implementation Stages

##### Implementation Tips

#### 8.7 Perspective

### 9 High-Level Language

#### 9.1 Examples

![](media/figure_9.1.png)

![](media/figure_9.2.png)

![](media/figure_9.3a.png)

![](media/figure_9.3b.png)

![](media/figure_9.4.png)

![](media/figure_9.5.png)

#### 9.2 The Jack Language Specification

##### 9.2.1 Syntactic Elements

![](media/figure_9.6.png)

##### 9.2.2 Program Structure

![](media/figure_wo_caption_9.1.png)

![](media/figure_wo_caption_9.2.png)

##### 9.2.3 Data Types

![](media/figure_wo_caption_9.3.png)

![](media/figure_wo_caption_9.4.png)

![](media/figure_wo_caption_9.5.png)

![](media/figure_wo_caption_9.6.png)

![](media/figure_wo_caption_9.7.png)

##### 9.2.4 Variables

![](media/figure_9.7.png)

##### 9.2.5 Statements

![](media/figure_wo_caption_9.8.png)

##### 9.2.6 Expressions

##### 9.2.7 Subroutine Calls

##### Function calls / Constructor calls:

##### Method calls:

![](media/figure_wo_caption_9.9.png)

##### 9.2.8 Object Construction and Disposal

#### 9.3 Writing Jack Applications

![](media/figure_9.8.png)

#### 9.4 Project

##### Compiling and Running a Jack Program

#### 9.5 Perspective

### 10 Compiler I: Syntax Analysis

#### 10.1 Background

![](media/figure_10.1.png)

##### 10.1.1 Lexical Analysis

![](media/figure_10.2.png)

##### 10.1.2 Grammars

![](media/figure_10.3.png)

##### 10.1.3 Parsing

![](media/figure_10.4a.png)

![](media/figure_10.4b.png)

##### 10.1.4 Parser

![](media/figure_wo_caption_10.1.png)

![](media/figure_wo_caption_10.2.png)

#### 10.2 Specification

##### 10.2.1 The Jack Language Grammar

![](media/figure_wo_caption_10.3.png)

![](media/figure_10.5.png)

##### 10.2.2 A Syntax Analyzer for the Jack Language

![](media/figure_wo_caption_10.4.png)

#### 10.3 Implementation

##### The JackTokenizer

![](media/figure_wo_caption_10.7.png)

##### The CompilationEngine

![](media/figure_wo_caption_10.8.png)

##### The JackAnalyzer

#### 10.4 Project

##### 10.4.1 Tokenizer

![](media/figure_wo_caption_10.5.png)

##### Testing Guidelines

##### 10.4.2 Compilation Engine

![](media/figure_wo_caption_10.6.png)

#### 10.5 Perspective

### 11 Compiler II: Code Generation

#### 11.1 Code Generation

![](media/figure_11.1.png)

##### 11.1.1 Handling Variables

![](media/figure_11.2.png)

##### 11.1.2 Compiling Expressions

![](media/figure_11.3.png)

![](media/figure_11.4.png)

![](media/figure_11.5.png)

##### 11.1.3 Compiling Strings

##### 11.1.4 Compiling Statements

![](media/figure_11.6.png)

##### 11.1.5 Handling Objects

##### 11.1.5.1 Compiling Constructors

![](media/figure_11.7.png)

![](media/figure_11.8.png)

##### 11.1.5.2 Compiling Methods

![](media/figure_wo_caption_11.1.png)

![](media/figure_11.9.png)

![](media/figure_wo_caption_11.2.png)

![](media/figure_11.10.png)

##### 11.1.6 Compiling Arrays

![](media/figure_11.11.png)

![](media/figure_11.12.png)

#### 11.2 Specification

#### 11.3 Implementation

##### 11.3.1 Standard Mapping over the Virtual Machine

##### 11.3.2 Implementation Guidelines

##### The Operating System

##### 11.3.3 Software Architecture

##### The JackCompiler

##### The JackTokenizer

##### The SymbolTable

![](media/figure_wo_caption_11.3.png)

##### The VMWriter

![](media/figure_wo_caption_11.4.png)

##### The CompilationEngine

![](media/figure_wo_caption_11.5.png)

#### 11.4 Project

##### Implementation Stages

##### Test Programs

#### 11.5 Perspective

### 12 Operating System

#### 12.1 Background

##### 12.1.1 Mathematical Operations

#### Efficiency First

#### Multiplication

![](media/figure_12.1.png)

#### Division

![](media/figure_12.2.png)

#### Square Root

![](media/figure_12.3.png)

##### 12.1.2 Strings

![](media/figure_wo_caption_12.1.png)

![](media/figure_12.4.png)

##### 12.1.3 Memory Management

![](media/figure_12.5a.png)

![](media/figure_12.5b.png)

##### 12.1.4 Graphical Output

![](media/figure_12.6.png)

![](media/figure_12.7.png)

![](media/figure_12.8.png)

##### 12.1.5 Character Output

![](media/figure_12.9.png)

##### 12.1.6 Keyboard Input

![](media/figure_12.10.png)

#### 12.2 The Jack OS Specification

#### 12.3 Implementation

##### Math

##### String

##### Array

##### Memory

![](media/figure_12.11.png)

![](media/figure_12.12.png)

##### Screen

##### Output

##### Keyboard

##### Sys

#### 12.4 Project

#### Testing Plan

![](media/figure_12.13.png)

![](media/figure_12.14.png)

![](media/figure_12.15.png)

![](media/figure_12.16.png)

##### Sys

#### Complete Test

#### 12.5 Perspective

### 13 More Fun to Go

#### Hardware Realizations

#### Hardware Improvements

#### High-Level Languages

#### Optimization

#### Communications

## Appendix 1: Boolean Function Synthesis

### A1.1 Boolean Algebra

![](media/figure_wo_caption_A1.1.png)

![](media/figure_wo_caption_A1.2.png)

### A1.2 Synthesizing Boolean Functions

![](media/figure_A1.1.png)

### A1.3 The Expressive Power of Nand

## Appendix 2: Hardware Description Language

### A2.1 HDL Basics

![](media/figure_A2.1.png)

![](media/figure_wo_caption_A2.1.png)

![](media/figure_wo_caption_A2.2.png)

![](media/figure_wo_caption_A2.3.png)

![](media/figure_wo_caption_A2.4.png)

### A2.2 Multi-Bit Buses

![](media/figure_wo_caption_A2.5.png)

![](media/figure_wo_caption_A2.6.png)

![](media/figure_A2.2.png)

### A2.3 Built-In Chips

![](media/figure_A2.3.png)

### A2.4 Sequential Chips

![](media/figure_wo_caption_A2.7.png)

![](media/figure_A2.4.png)

![](media/figure_wo_caption_A2.8.png)

### A2.5 Visualizing Chips

![](media/figure_A2.5.png)

![](media/figure_A2.6.png)

### A2.6 HDL Survival Guide

![](media/figure_wo_caption_A2.9.png)

![](media/figure_wo_caption_A2.10.png)

![](media/figure_wo_caption_A2.11.png)

![](media/figure_wo_caption_A2.12.png)

## Appendix 3: Test Description Language

### A3.1 General Guidelines

![](media/figure_wo_caption_A3.1.png)

### A3.2 Testing Chips on the Hardware Simulator

![](media/figure_A3.1.png)

![](media/figure_wo_caption_A3.2.png)

![](media/figure_A3.2.png)

#### Setup Commands

![](media/figure_wo_caption_A3.3.png)

![](media/figure_wo_caption_A3.4.png)

#### Simulation Commands

![](media/figure_A3.3.png)

![](media/figure_wo_caption_A3.5.png)

### A3.3 Testing Machine Language Programs on the CPU Emulator

![](media/figure_A3.4.png)

![](media/2.png)

#### Default Test Script

![](media/figure_wo_caption_A3.6.png)

### A3.4 Testing VM Programs on the VM Emulator

![](media/figure_A3.5.png)

![](media/3.png)

![](media/4.png)

![](media/5.png)

#### Default Script

![](media/figure_wo_caption_A3.7.png)

## Appendix 4: The Hack Chip Set

![](media/figure_wo_caption_A4.1.png)

## Appendix 5: The Hack Character Set

![](media/figure_wo_caption_A5.1.png)

## Appendix 6: The Jack OS API

### Math

### String

### Array

### Output

### Screen

### Keyboard

### Memory

### Sys
