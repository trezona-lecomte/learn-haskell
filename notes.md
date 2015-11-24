# Haskell Notes

## Functional Programming

What do we mean by pure? Referential Transparency:

* No mutation! Variables, data structures etc are immutable.

* Expressions don't have side-effects like updating global state or
  printing to the screen.

* Calling a function multiple times with the same arguments results
  in the same output.

## Data types

* `type` can be used to declare (unenforced) type aliases, such as:
    `type GearCount = Int`

* `newtype` can be used to declare enforced types, such as:
    `newtype Make = Make Text`

* `data` can be used to declare ADTs, such as:
    `data Vehicle = Bicycle GearCount | Car Make Model`

* The `String` type is defined as `type String = [char]`, but there
  are a few limitations with this: it's inefficient as we need to
  allocate fresh memory for each cons cell, and the characters
  themselves take up a full machine word; also we sometimes need
  string-like data that's not actually text such as ByteStrings and
  HTML. To work around this, there is a language extension called
  `OverloadedStrings` which defines string literals with the type:
    `IsString a -> a`
  There are `IsString` instances available for a number of types in
  haskell, such as `Text`, `ByteString` and `Html`.

## Actions

While actions can result in values that are used by the program, they
do not take any arguments. Consider `putStrLn`. It has the following
type:

    putStrLn :: String -> IO ()

`PutStrLn` takes an argument, but it is not an action. It is a
function that takes one argument (a string) and returns an action of
type `IO ()`.

So `putStrLn` is not an action, but `putStrLn "hello"` is. The
distinction is subtle but important. All `IO` actions are of type `IO`
a for some type `a`. They will never require additional arguments,
although a function which makes the action (such as `putStrLn`) may.

* IO actions are used to affect the world outside of the program.
* Actions take no arguments but have a result value.
* Actions are inert until run. Only one IO action in a Haskell program
  is run (main).
* Do-blocks combine multiple actions together into a single action.
* Combined IO actions are executed sequentially with observable
  side-effects.
* Arrows are used to bind action results in a do-block.
* Return is a function that builds actions. It is not a form of
  control flow!


## WTF mate?

 - Purely functional
   * functions are values
   * values never change

 - lazy (non-strict)

 - statically typed

## Pure functions

*All* Haskell functions are pure. They can't modify state (e.g. write
to a file) or depend on state (e.g. read from a file). Given the same
arguments, they will always return the same value.

In Haskell, recursion replaces loops.

## Lists

`x = [1, 2, 3]`

`empty = []`

`y = 0 : x  -- [0, 1, 2, 3]` this is called the cons operator

The square bracket notation is actually just shorthand for this:
`x = 1 : (2 : (3 : []))`

Strings are just lists of characters:

`str = "abcde"` is the same as: `str = 'a' : 'b' : 'c' : 'd' : 'e' : []`

The concatenation operator can be used to concatenate lists: `[0, 1] ++ [2, 3]  -- [0, 1, 2, 3]`

Lists in haskell are homogeneous - can't mix types.

`head` return the first element of a list.

`tail` returns everything except the first element.

`null` tests whether the list is empty.

This example takes a list and returns a new list with every element doubled:

    double nums =
      if null nums
      then []
      else (2 * (head nums)) : (double (tail nums))

This (very ugly) example takes a list and returns a new list without the odd elements:

    removeOdd =
      if null nums
      then []
      else
        if (mod (head nums) 2) == 0
        then (head nums) : (removeOdd (tail nums))
        else removeOdd (tail nums)

## Tuples

`x = (1, "hello")` Tuples can hold different types unlike lists.

`y = (1.0234, "world", [9, 8, 7], 3)` Tuples can also hold more than 2 elements.

Tuples do have a fixed length, while lists have unbounded length.

Tuple elements are normally accessed using pattern matching, but the
`fst` and `snd` functions access the first and second elements of a
pair tuple.

*Warning:* Big tuples can get unwieldy very easily. Also tuples
spanning different parts of a program can be a bit shit (use an ADT).

## Pattern Matching

This custom function is a replica of the `fst` fuction, and
demonstrates pattern matching:

    fst' (a,b) = a

### Pattern Matching Lists

    null' [] = True
    null' (x : xs) = False

The first defintion of null handles the case when the list is empty,
or more specifically that it matches the pattern of an empty list
`[]`.

The second definition of null handles the case when the list is not
empty, by matching the case where an element `x` is added to the front
of the list `xs` with the cons operator.

    head' (x : xs) = x
    head' [] = ?   -- How do we handle the case where the list is empty?

We can just leave off the problematic case, in which case the program
will compile, but with a warning, and if head is ever called on an
empty list then the program will explode.

The second option is to specifically raise an error:

    head' [] = error "head of empty list"

You can actually avoid using functions like head and tail, and just
rely on pattern matching.

## Using Pattern Matching instead of head & tail

Here is the not-so-robust version using head & tail

    double nums =
      if null nums
      then []
      else (2 * (head nums)) : (double (tail nums))

And here is the robust version using pattern matching:

    double [] = []
    double (x : xs) = (2 * x) : (double xs)

Here we recursively call the double function on the remaining list,
and will simply return an empty list once the list has been fully
traversed (thus providing the base case & avoiding the use of the
nasty tail function).

## Guards

While pattern matching looks only at the structure of data, guards
look at the values:

    pow2 n
      | n == 0    = 1
      | otherwise = 2 * (pow2 (n -1))

Guards are formed by replacing the equals sign of a function with
pipes preceeding a number of conditional expressions, each followed by
an equals sign dictating the value to return if they evaluate true.

`otherwise` is useful when you use guard as the catch-all. It just
evaluates true.

Remember the ugly version of removeOdd?

    removeOdd =
      if null nums
      then []
      else
        if (mod (head nums) 2) == 0
        then (head nums) : (removeOdd (tail nums))
        else removeOdd (tail nums)

This version uses a combination of pattern matching and guards:

    removeOdd [] = []
    removeOdd (x : xs)
      | mod x 2 == 0 = x : (removeOdd xs)
      | otherwise    = removeOdd xs

Here we again use pattern matching to replace the base case & ensure
we can recursively call our function safely, but in addition we use
guards to check if `x` is even, and if so we return `x` `cons`'d with
the result of calling removeOdd on the remaining list, otherwise if
it's odd we just return the result of calling removeOdd on the
remaining list.


## Case Expressions

What if we want to pattern match somewhere other than a function
definition?

Here is a semantically identical `double` function that uses case
expressions for exactly that purpose:

    double nums = case nums of
      []       -> []
      (x : xs) -> (2 * x) : (double xs)

Here's another example of a case expression, but this time it can't be
easily rewritten using pattern matching:

    anyEven nums = case (removeOdd nums) of
      []       -> False
      (x : xs) -> True

Instead of pattern matching on the argument of the function, here we
pattern match on the result of the removeOdd function.

Remember: you can't use guards in a case expression, so you'll have to
use an if expression if you need to do that.

## Let Bindings

`let` defines a local variable:

    fancyNine =
      let x = 4
          y = 5
      in x + y

    numEven nums =
      let evenNums = removeOdd nums
      in length evenNums

## Where Bindings

`where` bindings come after the function that uses them:

    fancyNine = x + y
      where x = 4
            y = 5

Where bindings always go with a function definition, so we can't use
them inside other expressions. We can use let in other expressions
though:

Not allowed: `fancyTen = 2 * (a + 1 where a = 4)`

Allowed: `fancyTen = 2 * (let a = 4 in a + 1)`

## Whitespace

- Whitespace can have meaning

- Indent further when breaking expression onto following line

- Line up variable bindings

## Lazy Function Evalutation

This can have an impact of performance. A bizzare consequence is that
we can create infinite lists:

    intsFrom n = n : (intsFrom (n+1))
    intsToInfinity = intsFrom 1

Here ints is defined as all possible integers from 1 up!

Note that haskell is so lazy, it only every evaluates a function as
much as it needs for the calling functions requirements. This means we
can do crazy stuff like:

    > let evenIntsToInfinity = removeOdd intsToInfinity
    > Take 10 evenIntsToInfinity
    >> [2,4,6,8,10,12,14,16,18,20]


