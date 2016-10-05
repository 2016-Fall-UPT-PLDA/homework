Homework 01 - Functional Expression Language Interpreter
===============================================================================

Don't forget to check everything else within this repository as a reference. The [cheat-sheet](https://github.com/2016-Fall-UPT-PLDA/labs/blob/master/haskell-cheat-sheet.md) is always a good thing to use.  

For ease of reference we'll call the language we're developing here FELI.

Homework submission guidelines, and due date
-------------------------------------------------------------
You should show either the TA, or the Instructor a working implementation of the interpreter by **__Sunday 23:59 October 30th 2016__**. This can be done either in person or via e-mail(`lsz@lorandszakacs.com`). Although, preferably, it should be done by email.

The submission is deemed correct *_iff_* the list of submitted tests, plus your implementation of the interpreter compiles, and all test cases pass.

*_If you think that you found an error in the test cases, or in the definitions of the data-types please don't hesitate to notify us, so that we can correct them asap! Thank you._*  

*_Late submissions_:* may or may not be allowed. Stay tuned.

The task at hand
-------------------------------------------------------------

Your task is to implement an interpreter for the programming language who's structure is dictated by the abstract-syntax-tree listed bellow; and who's semantics are described by the test cases found at the bottom of this file. And provide comprehensive, illuminating tests for programs that can be written in the language. As an starting point, you should focus on really interesting things, like: 
 - what happens when you reuse variables names in two nested contexts(e.g. function definitions, and let expressions)
 - and so on, and so on. You're clever kids, you can define reasonable semantics for your language.

```Haskell
data Val = IntV Integer
         | FloatV Float
         | CharV Char
         | StringV String
         | BooleanV Bool
         -- since we are implementing a Functional language, functions are
         -- first class citizens.
         | LambdaV [String] Expr Env
     deriving (Show, Eq)

-----------------------------------------------------------
data Expr = 
            Const Val
          | Var String
          | Expr :*: Expr 
          | Expr :+: Expr 
          | Expr :==: Expr 
          | If Expr Expr Expr
          | Let String Expr Expr
          | Letrec String Expr Expr
          | Lambda [String] Expr 
          | Apply Expr [Expr]
     deriving (Show, Eq)

data Env = EmptyEnv
         | ExtendEnv String Val Env
     deriving (Show, Eq)
```


As you can see we define three data-types:
  * `Expr` - during the lab we called it `AST`. But `Expr`(Expression) is a bit more appropriate given the semantics of the language
  * `Val` - the values that can be expressed in our language
  * `Env` (environment) - this is a glorified key-value pair list, that, when used properly takes care of the scoping properties of our language.  



More on the `Env` data-type
-------------------------------------------------------------

To learn more about environments consult [Essentials of Programming Languages, Friedman et. al](https://karczmarczuk.users.greyc.fr/TEACH/Doc/EssProgLan.pdf) downloadable from the provided link. Specifically look at section `3.2.3`, which in turns points to section `2.2`. Also, chapter 3 discusses the implementation of an extremely similar interpreter, but it's written in Scheme :). It shouldn't be too hard to figure out. All the source code from the book can also be found in this [github repo](https://github.com/mwand/eopl3).  



General Tips
-------------------------------------------------------------

You will need to evaluate expressions in the appropriate environment (that's why the `evaluate` function takes an `Env` as a parameter). When evaluating a function in environment `env` you must evaluate its argument(s) in `env` but evaluate the function body (specifically, its free variables) in the environment of the function definition (this is why `FunVal` contains an `Env` value). Essentially, you are implementing the concept of `closures`.


Testing
-------------------------------------------------------------

You should add tests for your new implemented language semantics. You should be able to figure out how to ensure that when running the `testAll` expression in `ghci` your tests also run.

The tests aren't written with any of the standard Haskell unit testing libraries because that would have required explicit installation of these modules in the lab, which, at this point is a total pain.  

The test cases aren't exaustive. You should write some of your own.


Other references
-------------------------------------------------------------

Taken straight from [previous years' description](http://bigfoot.cs.upt.ro/~marius/curs/plda/2013/hw1.html):

The [PLAI book](http://cs.brown.edu/~sk/Publications/Books/ProgLangs/) has an in-depth discussion (sec. II-IV) of building an interpreter.Here's an example of [an SML interpreter](http://www.cs.cornell.edu/courses/cs312/2005sp/lectures/lec17.asp) (with more features) from a course at Cornell.