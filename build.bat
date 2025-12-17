@echo off
nasm bootloader/stage1.asm -f bin -o stage1.bin
nasm bootloader/stage2.asm -f bin -o stage2.bin

cd kernel
cargo build --release
cd ..

copy /b stage1.bin+stage2.bin+kernel\target\x86_64-unknown-none\release\kernel disk.img

qemu-system-x86_64 ^
  -drive format=raw,file=disk.img ^
  -m 512M
