# shashd.vim

"Nobody knows the Java code you committed is originally written in Scheme."

## Usage

Assuming the product is `a.pl`, create `a.pl.shd`.

a.pl (in Vim):

    ## ruby -e 'puts $<.read.gsub(/$/, ";")'
    $a = 1
    print($a)


Open `a.pl` in Vim. The Vim actually shows the contents of `a.pl.shd`. When you save the file, the command in the first line without `##` runs, then the actual `a.pl` will be the result.

a.pl (actually):

    $a = 1;
    print($a);

## Commands

There's no commands or functions you have to use explicitly.

## Limitation

The pair of a shashd file and the actual file is always 1-to-1 pair. That makes everything simple.

## Author

Tatsuhiro Ujihisa

