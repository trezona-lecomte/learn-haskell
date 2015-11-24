-- -- | 

-- module  where

string1 = "hello"
string2 = "world"
greeting = string1 ++ ", " ++ string2 ++ "!"

square x = x * x

multMax a b x = (max a b) * x

posOrNeg x =
  if x >= 0
  then "Positive"
  else "Negative"


-- recursive functions:

pow2 n =
  if n == 0
  then 1                  -- base case, almost all recursive functions need them
  else 2 * (pow2 (n - 1))

repeatString str n =
  if n == 0
  then ""
  else str ++ (repeatString str (n - 1))


-- Pattern matching:

firstElement (a,b) = a
