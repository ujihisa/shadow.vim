# shadow.vim

> "Nobody knows the Java code you committed is originally written in Scheme."

## Usage

Assuming the product is `a.pl`, create `a.pl.shd` first.

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

## Use Case

Here there are three examples, but you can use more general purposes.

* Commit JavaScript files which was written in CoffeeScript

    * before

                ## coffee -cs --no-wrap
                f = (x) -> x + 1
                print f 10

                # vim: set ft=coffee :

    * after

                var f;
                f = function(x) {
                  return x + 1;
                };
                print(f(10));


* Use `cpp` command before commiting Java files.
* Markdown, Haml or something else to HTML

## Limitation

The pair of a shadow file and the actual file is always 1-to-1 pair. That makes everything simple.

## Author

Tatsuhiro Ujihisa

