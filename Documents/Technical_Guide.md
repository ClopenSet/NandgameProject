# Technical Guide

## Language Versions
- [中文文档](Technical_Guide_zh.md)

# Knowledge Preparation
## Boolean Algebra
- **Boolean Functions**: A Boolean function takes several Boolean variables and produces a definite Boolean output. $ F(a_1, a_2, \ldots) = A $

### Truth Tables
A truth table is a tabular method for representing the results of logical operations. It lists all possible combinations of inputs and their corresponding outputs. For example, a basic AND operation's truth table is as follows:

| A | B | A AND B |
|---|---|---------|
| 0 | 0 |    0    |
| 0 | 1 |    0    |
| 1 | 0 |    0    |
| 1 | 1 |    1    |

### Unary and Binary Boolean Operations
- **Unary Boolean Operations**: These operations involve only one variable, denoted as $ F(a) = A $. The most common unary Boolean operation is the NOT operation, which reverses the logic value of the input (i.e., converts 1 to 0 and 0 to 1). For example, the truth table for NOT A (commonly written as $ \neg A $ or $ A' $) is as follows:

  | A | ¬A  |
  |---|-----|
  | 0 |  1  |
  | 1 |  0  |

- **Binary Boolean Operations**: These operations involve two variables, denoted as $ F(a, b) = A $. In addition to the previously mentioned AND operation, this includes OR and XOR (exclusive OR) operations. The truth table for the OR operation is as follows:

  | A | B | A OR B |
  |---|---|--------|
  | 0 | 0 |   0    |
  | 0 | 1 |   1    |
  | 1 | 0 |   1    |
  | 1 | 1 |   1    |

  Here, if at least one of A or B is 1, then the result of A OR B is 1.

### Common Techniques
#### De Morgan's Laws
- **First Law**: NOT (A AND B) is equivalent to (NOT A) OR (NOT B), symbolically represented as $ \neg(A \land B) = \neg A \lor \neg B $.
- **Second Law**: NOT (A OR B) is equivalent to (NOT A) AND (NOT B), symbolically represented as $ \neg(A \lor B) = \neg A \land \neg B $.

#### Elimination Law
- The essence of the elimination law lies in the removal of inverters from logical expressions. If a logical variable is inverted and then immediately processed by another inverter, these two inverters can cancel each other out, simplifying the entire logical expression.
- Mathematically, it can be expressed as: $ \neg(\neg A) = A $

#### CNF and DNF
- **CNF**: A Boolean function composed by conjoining (AND) several disjunctive clauses.
- **DNF**: A Boolean function composed by disjoining (OR) several conjunctive clauses.

#### How to Derive CNF and DNF from Truth Tables
Extracting CNF and DNF from truth tables is an important process in Boolean algebra, primarily used to simplify logical expressions. Here are the steps:

1. **Identify rows where the output is true (for DNF)**:
   - For each row where the output is true, record the corresponding combination of input variables.
   - For variables that are 1, write the variable name; for variables that are 0, write the negation of that variable.
   - Connect these variables with AND to form a product term.
   - Connect all such product terms with OR to form the final DNF.

2. **Identify rows where the output is false (for CNF)**:
   - For each row where the output is false, record the corresponding combination of input variables.
   - For variables that are 1, write the negation of that variable; for variables that are 0, write the variable name.
   - Connect these variables with OR to form a sum term.
   - Connect all such sum terms with AND to form the final CNF.

It can be easily proven that CNF and DNF are equivalent to the truth table.

### Karnaugh Map
A Karnaugh Map (K-map) is a graphical tool used for minimizing Boolean functions. Similar to finding and simplifying DNF or CNF, so further details are not elaborated here.

### Complete Introduction to Boolean Operations
#### Unary Operations

The truth table for unary operations includes two rows, as the variable can take values 0 or 1. Theoretically, there are $2^2 = 4$ possible operations for a single variable, denoted as $a$:

1. **Constant 0**: Typically represented as 0, $F$, or $False$. In Verilog, it's commonly represented as `1'b0`. (This actually degenerates into a nullary operation.)
2. **Constant 1**: Typically represented as 1, $T$, or $True$. In Verilog, it's commonly represented as `1'b1`. (This actually degenerates into a nullary operation.)
3. **Same as $a$**: The result is simply the original value of $a$.
4. **Opposite of $a$**: This operation is represented in various ways:
   - **NOT**: In Verilog and C, it is denoted as `~`.
   - **Negation**: Commonly represented as $ \neg $ in mathematical logic.
   - **Negation**: Logically referred to as negation, often represented as `!`.
   - **Complement**: In Boolean algebra, it is called the complement, represented as $ \overline{a} $.

#### Binary Operations
Binary operations involve two variables and determine the result based on the values of these two variables. For binary operations, the truth table has four rows, each representing one possible combination of input values (i.e., each variable can take the values 0 or 1). Theoretically, there are $2^4 = 16$ possible outcomes for these operations.

##### Six Degenerate Cases
Among these 16 possible operations, six cases degenerate into simpler nullary or unary operations:
1. **Constant 0** and **Constant 1**: These operations do not depend on the values of input variables $a$ or $b$, always producing an output of 0 or 1, thus degenerating to nullary operations.
2. **Output equals $a$**, **Output equals $b$**, **Output equals $\neg a$** (the logical NOT of $a$), **Output equals $\neg b$** (the logical NOT of $b$): These operations result only from the value of a single input variable or its logical negation, thereby degenerating to unary operations.

##### Non-Degenerate Cases
7. **AND**:
   - Symbolically represented as $a \& b$ (in C and Verilog), $a \wedge b$ (in mathematics), and known as conjunction in logic.
   - In programming, the logical AND is represented by `&&`.
   - Often described as addition or sum.

8. **OR**:
   - Symbolically represented as $a | b$ (in C and Verilog), $a \vee b$ (in mathematics), and known as disjunction in logic.
   - In programming, the logical OR is represented by `||`.
   - Often described as multiplication or product.

9. **NAND (Not AND)**:
   - Represented in Verilog as `a ~& b`, commonly known as NAND.
   - This operation is an AND followed by a NOT, expressed as $ \neg (a \wedge b) $.

10. **NOR (Not OR)**:
    - Represented in Verilog as `a ~| b`, commonly known as NOR.
    - This operation is an OR followed by a NOT, expressed as $ \neg (a \vee b) $.

11. **XOR (Exclusive OR)**:
    - Represented as `xor`, $ a \oplus b $ (mathematical symbol), or `a ^ b` (in C and Verilog).
    - XOR produces a true output when the two operands are different, and can be expressed through its CNF (Conjunctive Normal Form) and DNF (Disjunctive Normal Form):

    - **Disjunctive Normal Form (DNF)**:
      $$
      a \oplus b = (a \wedge \neg b) \vee (\neg a \wedge b)
      $$
      This means the output is true when $ a $ is true and $ b $ is false, or $ a $ is false and $ b $ is true.

    - **Conjunctive Normal Form (CNF)**:
      $$
      a \oplus b = (a \vee b) \wedge (\neg a \vee \neg b)
      $$
      This means the output is true when at least one of $ a $ or $ b $ is true, and at least one is false.

12. **XNOR (Exclusive NOR)**:
    - Also known as the logical negation of XOR, represented as `xnor` or `a ~^ b` (Verilog).
    - XNOR produces a true output when both operands are the same, and its CNF and DNF can be derived from those of XOR.

13. **Implication**:
    - **a implies b**: This operation is well-known in logic, often represented as $ a \rightarrow b $, and can be expressed as $ \neg a \lor b $. Familiarity with this conversion is essential in circuit design: $ \neg a \lor b = a ~\text{NAND}~ b ~\text{NAND}~ a $.

14. **b implies a**:
    - Similar to the thirteenth case.

15. **Non-implication**:
    - **a does not imply b**: Logically represented as $ a \not\rightarrow b $, which can be expressed as $ a \land \neg b $. This operation is also common in circuits, with an equivalent NOR circuit implementation: $ a \wedge \neg b = a ~\text{NOR}~ b ~\text{NOR}~ a $.

16. **b does not imply a**:
    - Similar to the fifteenth case.

## Conceptual Preparation
### Modular Design Philosophy
#### Modules
Modules function like black boxes, producing a specific behavior and output for each valid input. The advantage of this design is that users do not need to understand the intricate details within the module; they only need to know its function to use it effectively.

#### Modularization
Modularization is a design strategy that involves breaking down a complex system into multiple independent, freely combinable modules. The benefit of this approach is the creation of a logically organized system architecture that is easier to manage and expand.

#### Top-Down Design
Top-down design starts at the highest level of the system and progressively breaks it down into smaller, simpler components. This method allows designers to address the larger problems first and then gradually refine the details of implementation.

#### Bottom-Up Design
Contrasting with top-down, the bottom-up approach starts with the most fundamental units and gradually combines them to build a complex system. This strategy ensures that each building block is thoroughly tested and optimized before it is integrated into the larger system.

#### Pipelining
Pipelining decomposes a complex process into several sequential steps, each handling a part of the task. This method can optimize performance and resource utilization, particularly in applications involving data processing and instruction execution.

#### Hierarchies
One or several modules that segment the entire system form a hierarchy; modules above and below this level must communicate up and down with modules within this hierarchy. The advantage of this design is that since a hierarchy is segmented, modules above and below a given level do not affect each other; developers at different levels can focus on their areas of expertise, only needing to consider the adjacent levels, without dealing with the entire complex system as a whole.

### Design and Implementation Concepts
#### Design
Design involves planning and defining the behavior and structure of a system or product, without addressing how it is specifically constructed.

#### Implementation
Implementation is the process of actually constructing the system or product based on the design plan.

#### Standards
Standards define how a product or system should perform and are a set of rules and guidelines that all relevant parties are expected to follow. Standards ensure compatibility and interchangeability among different implementations. They do not dictate specific methods of implementation.

#### Relationship Between Design and Implementation
A single design can have multiple different implementations, each of which may vary in performance, efficiency, and cost, but should appear consistent externally. This separation ensures the diversity and flexibility of design while minimizing the impact on the end user.

#### Separation of Design and Implementation
- **Code**: Code is a means to describe a design, adhering to specific syntax rules to ensure clarity and consistency. It does not specify the exact methods of implementation.
- **Compilation**: The compilation process is the transformation of the design in the code into an implementation.
- **Compiler**: A compiler is an automated tool that creates a specific implementation from a given design (code).

### Abstraction

#### Definition
Abstraction involves hiding several more basic elements (often concrete operations and implementation details) and exposing only the necessary interfaces and behaviors to form a more complex concept.

In practice, computers do not understand high-level concepts such as modules, hierarchies, or files; they merely execute machine code in sequence. Abstraction allows developers not to deal with the low-level machine language each time but to operate higher-level constructs such as files, databases, or user interfaces. For example, when we talk about "processing a file," we are actually referring to a series of complex underlying operations that are encapsulated under the abstract concept of a "file."

#### Managing Complexity
Abstraction is a crucial tool for managing complexity. It allows us to focus on the issues at the current level without being overwhelmed by details from other levels. By defining clear interfaces and separating concerns, abstraction helps us gradually build up complex systems, each step based on the foundation laid by the previous one.

Abstraction is the cornerstone of modern computing technology, making the management of complex systems feasible. It is through this incremental progress that the world of computing has evolved.
