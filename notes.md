# Haskell

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


