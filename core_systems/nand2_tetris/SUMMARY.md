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

Computers represent everything internally with binary codes, even when users interact with decimal numbers or screen characters. Decimal notation is a human-facing convention; the machine must convert between human-readable decimal forms and internal binary forms when necessary.

Because computers are finite machines, integer values are represented using a fixed word size. An `n`-bit word can represent `2^n` distinct values. If all values are nonnegative, the range is `0` through `2^n - 1`; representing values outside the fixed range requires larger or multi-word representations.

#### 2.3 Binary Addition

Binary numbers are added from right to left, just like decimal numbers. The least significant bits are added first, and each addition may produce a carry that feeds into the next more significant bit.

If the most significant addition produces a carry beyond the fixed word size, the result overflows. The Hack hardware ignores overflow and guarantees only the low `n` bits of an `n`-bit addition result.

#### 2.4 Signed Binary Numbers

Signed binary numbers divide the available code space between nonnegative and negative values. The dominant representation is two's complement, where the `n`-bit representation of `-x` is the code for `2^n - x`.

In two's complement, an `n`-bit system represents values from `-2^(n-1)` through `2^(n-1) - 1`. Nonnegative numbers begin with `0`, negative numbers begin with `1`, and negating a number can be done by flipping all bits and adding `1`.

The key hardware payoff is that subtraction becomes addition: `x - y` can be computed as `x + (-y)`. This means the same binary adder can handle signed addition and subtraction without special signed-number hardware.

#### 2.5 Specification

The chapter specifies a hierarchy of arithmetic chips. As usual, the specification describes what each chip does before discussing how to build it.

##### 2.5.1 Adders

The adder hierarchy starts with a half-adder, which adds two bits and produces a `sum` and `carry`. A full-adder adds three bits, allowing it to include an incoming carry from a less significant bit.

A multi-bit adder chains this idea across a fixed-width word. For Hack, the important version is a 16-bit adder that adds two 16-bit inputs and outputs the low 16 bits of the result.

The chapter also specifies an incrementer, a special-purpose chip that adds `1` to a 16-bit input. This will later support advancing to the next instruction address.

##### 2.5.2 The Arithmetic Logic Unit

The Hack ALU computes a selected arithmetic or logical function over two 16-bit inputs, `x` and `y`. It is controlled by six 1-bit control inputs: `zx`, `nx`, `zy`, `ny`, `f`, and `no`.

The control bits are interpreted as a sequence of simple micro-actions. The ALU may zero and/or negate each input, then choose between bitwise And and addition, then optionally negate the final output.

This small control scheme is enough to produce the eighteen documented Hack ALU functions, including constants, identity operations, negation, increment/decrement, addition, subtraction, And, and Or. The six control bits actually encode sixty-four possible operations, but Hack uses only the subset needed by its instruction set.

The ALU also outputs `zr` and `ng`. `zr` reports whether the result is zero, and `ng` reports whether the result is negative. These status bits will later drive CPU branching decisions.

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
