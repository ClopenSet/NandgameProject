# Nandgame项目指南

## 项目介绍
NandgameProjects 是基于 Nandgame [Nandgame 官网](https://nandgame.com/) 开发的项目，Nandgame 通过游戏化的方式让用户深入理解数字逻辑门和电路设计，从而掌握计算机硬件知识。本项目旨在通过提供等价和严谨的Verilog 代码，帮助用户更系统地学习计算机基础技术。

## 项目结构和特性

NandgameProjects 包含以下主要目录和文件：

- **Gamesave**：包含游戏的存档文件。
  - `state.json`：游戏存档，可以导入游戏官网界面查看图形化界面（未完成）。

- **Hardware**（此部分已完成）：包含所有硬件组件的 Verilog 描述文件。
  - `ALU.v`：算术逻辑单元
  - 以及更多相关的 Verilog 文件

- **Software**（此部分未完成）：将包含软件实现的相关文件。

- **Optional_Levels**（此部分未完成）：包含可选挑战的 Verilog 文件。
  - `CMOS.v`：CMOS 电路描述。
  - 以及更多相关的 Verilog 文件
## 快速开始
### 硬件部分和选修部分
为了方便测试每个 Verilog 文件，我在每个文件中都包含了与文件同名的测试宏。您可以按照以下步骤运行测试：

1. **编译 Verilog 文件：**
   使用以下命令来编译每个文件，其中 $fileNameWithoutExt 是去掉扩展名的文件名：
    ```bash
    iverilog -g2012 -D`echo TB_$fileNameWithoutExt | tr '[a-z]' '[A-Z]'` -o $fileNameWithoutExt.vvp $fileName
    ```
2. **执行编译产生的程序：**
    执行以下命令以运行产生的VVP ：
    ```bash
    vvp $fileNameWithoutExt.vvp
    ```
3. **查看波形文件：**
    如果测试生成了波形文件，使用 GTKWave 查看波形：
    ```bash
    gtkwave $fileNameWithoutExt.vcd
    ```
### 软件部分
待完成

## 从零开始
### 运行环境准备

#### 对于 Mac 和 Linux 用户：
- **安装 Icarus Verilog 和 GTKWave**：
  - 在 macOS 上，你可以通过 Homebrew 安装这些工具：
    ```bash
    brew install iverilog gtkwave
    ```
  - 对于 ARM 架构的 macOS（如 M1/M2 Mac），可能需要安装 GTKWave 的头版本：
    ```bash
    brew install --HEAD gtkwave
    ```
  - 对于 x86 架构的 Linux，可以使用系统的包管理器进行安装，例如在 Ubuntu 上：
    ```bash
    sudo apt-get install iverilog gtkwave
    ```

#### 对于 Windows 用户：
- Windows 平台上安装 Icarus Verilog 和 GTKWave 可以通过如下方式：
  - 下载并安装 Icarus Verilog 和 GTKWave 的 Windows 版本。官方网站通常提供了安装程序。
  - 或使用 WSL (Windows Subsystem for Linux) 在 Windows 上运行 Linux 环境，并按照 Linux 的指导安装这些工具。

### 知识准备
在开始之前，建议了解以下基础知识：
- **布尔代数**：
  - 真值表
  - 一元布尔运算和二元布尔运算
  - 合取范式 析取范式 卡诺图
  - 常见的布尔恒等式（尤其是De Morgan律）

- **模块化和层次思想**：
  - 理解如何将复杂系统分解为简单模块
  - 学习如何组织模块以构建复杂的系统

为了深入理解这些概念并有效地应用于项目中，我们提供了一个详细的技术文档，您可以在其中找到更多关于这些基础知识的讲解和示例。

- [阅读详细的技术指南](Technical_Guide.md)

### 零基础，建议从玩 Nandgame 开始
- 在 [Nandgame 官网](https://nandgame.com/) 按网站提示进行游戏。
- 如果在某个关卡遇到难题，可以查看同名的 Verilog 代码，并尝试将其转换为等价的电路连线。
- 在 Verilog 代码中，我提供了详细的实现思路，帮助你理解每个电路的工作原理。

### 使用建议
- 比较 Verilog 的门级描述和电路连线，加深对电路的理解；
- 比较门级描述和行为描述，加深对 Verilog 语法的理解。

### 观看顺序
#### Verilog 文件观看顺序
本项目的 Verilog 文件按照 Nandgame中相同的顺序，请按此顺序观看
##### 软件部分
- **逻辑门（Logic Gates）**
  - `Nand.v`：基础 NAND 门
  - `Invert.v`：反相器
  - `And.v`：与门
  - `Or.v`：或门
  - `Xor.v`：异或门

- **算术运算（Arithmetics）**
  - `HalfAdder.v`：半加器
  - `FullAdder.v`：全加器
  - `Multi-bitAdder.v`：多位加器
  - `Increment.v`：增量器
  - `Subtraction.v`：减法器
  - `EqualToZero.v`：等于零检测
  - `LessThanZero.v`：小于零检测

- **开关（Switching）**
  - `Selector.v`：选择器
  - `Switch.v`：开关

- **算术逻辑单元（Arithmetic Logic Unit）**
  - `LogicUnit.v`：逻辑单元
  - `ArithmeticUnit.v`：算术单元
  - `ALU.v`：算术逻辑单元
  - `Condition.v`：条件判断

- **存储器（Memory）**
  - `SR Latch.v`：SR 锁存器
  - `D Latch.v`：D 锁存器
  - `DataFlip-Flop.v`：数据触发器
  - `Register.v`：寄存器
  - `Counter.v`：计数器
  - `RAM.v`：随机访问存储器

- **处理器（Processor）**
  - `Combined Memory.v`：组合存储器
  - `Instruction.v`：指令单元
  - `Control Unit.v`：控制单元
  - `Computer.v`：计算机整体
##### 选修部分
未完成
#### 软件观看顺序
未完成
### 推荐阅读
有了 Nandgame 的经验，你将能够更顺畅且快速地通过以下两本书系统地了解计算机的软硬件：
- **《逻辑与计算机设计基础》** — 本书提供了计算机硬件设计的基础知识。
- **《深入理解计算机系统（CSAPP）》** — 本书深入讲解了计算机系统的每个层次。

## 致谢
特别感谢 Nandgame 提供的灵感和基础资源。支持原项目请访问 [Nandgame 官网](https://nandgame.com/)。

## 欢迎你进入计算机底层的世界！