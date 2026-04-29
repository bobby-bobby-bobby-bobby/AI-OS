# langmgr — AI-OS Language Runtime Manager

`langmgr` manages installation and execution of programming language runtimes
for AI-OS. It supports modern, legacy, esoteric, academic, retro, and VM-based
languages.

## Commands

```sh
lang install <language>   Install a language runtime
lang remove  <language>   Remove a language runtime
lang list                 List all supported languages
lang list --installed     List installed languages
lang info <language>      Show language information
lang update               Update language registry

run <file>                Auto-detect language and run a file
run --lang <name> <file>  Run with a specific language
```

## Examples

```sh
lang install python
lang install rust
lang install brainfuck
run hello.py
run main.rs
run hello.bf
```
