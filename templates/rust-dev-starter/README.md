# RustDemo
This repository is a demo for Rust

## 1.Setup development environment
```
1.基于direnv + rust-overlay 构建nix开发环境

	direnv 环境切换工具，主要用于在进入特定目录时自动加载和卸载环境变量, 便于配合vscode相关插件.
	基于nix shell 实现的开发环境, 相应的环境变量仅在nix shell中使用, 无法影响到vscode插件, 因此需要通过direnv实现转换.

2.初始化rust项目
cargo new my_project 

cargo init 

cargo build

cargo run
```