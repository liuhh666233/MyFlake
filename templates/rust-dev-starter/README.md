# RustDemo
This repository is a demo for Rust

## 1.Setup development environment
```
1.基于direnv + rust-overlay 构建nix开发环境

	direnv 环境切换工具，主要用于在进入特定目录时自动加载和卸载环境变量, 便于配合vscode相关插件.
	需要安装direnv、rust-analyzer插件,direnv插件能保证其他插件也能使用到direnv生成到环境变量,nix中安装direnv只能保证进入到当前shell中运行的程序.
	基于nix shell 实现的开发环境, 相应的环境变量仅在nix shell中使用, 无法影响到vscode插件, 因此需要通过direnv实现转换.(尝试一下python相关插件是否可行, 验证可行)

2.初始化rust项目
cargo new my_project 

cargo init 

cargo build

cargo run

cargo run --release
```
## 2. 使用 `nix flake template` 初始化项目

```bash
nix flake init -t "git+ssh://git@github.com/liuhh666233/MyFlake#rust-dev-starter" --refresh  
nix flake lock --override-input nixpkgs "github:NixOS/nixpkgs?rev=cdd2ef009676ac92b715ff26630164bb88fec4e0"    
```