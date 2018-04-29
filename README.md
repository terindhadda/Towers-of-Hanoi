# Towers of Hanoi

This is a simple implementation of the famous [Towers of Hanoi](https://en.wikipedia.org/wiki/Tower_of_Hanoi) game created using [NASM](https://www.nasm.us/), [x86](https://en.wikipedia.org/wiki/X86) and [gcc](https://gcc.gnu.org/).

## Installing

To download the repo and make the program:

```
git clone https://github.com/terindhadda/Towers-of-Hanoi.git
cd Towers\ on\ Hanoi/src/
make hantow
```

If the program was made successfully, you should see the following output:

```
nasm -f elf32 -o hantow.o hantow.asm
nasm -f elf32 -d ELF_TYPE asm_io.asm
gcc -m32 -o hantow hantow.o driver.c asm_io.o
```

Then to run the program:
```
./hantow 3
```

## Demo

![Demo](https://media.giphy.com/media/2skWAyM98GxGR1BxMs/giphy.gif)
