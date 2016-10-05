import Debug.Trace

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
          
          -- represents a variable
          | Var String
          
          -- integer multiplication
          | Expr :*: Expr 

          -- integer addition and string concatenation
          | Expr :+: Expr 
          
          -- equality test. Defined for all Val except FunVal
          | Expr :==: Expr 
         
          -- semantically equivalent to a Haskell `if`
          | If Expr Expr Expr
         
          -- binds a Var (the first `Expr`) to a value (the second `Expr`), 
          -- and makes that binding available in the third expression
          | Let String Expr Expr
         
          -- similar to Let but allows for recursive definitions. You can also make
          -- the above Let support this, and simply remove this expression. But since
          -- implementing a recursive definition of Let is a bit trickier, you will want
          -- at least implement a non-recursive Let.
          | Letrec String Expr Expr
         
          -- creates an anonymous function with an arbitrary number of parameters
          | Lambda [String] Expr 
         
          -- calls a function with an arbitrary number values for parameters
          | Apply Expr [Expr]
     deriving (Show, Eq)

-----------------------------------------------------------

--you can replace this with whatever you think will solve your problem. 
--e.g. with a Map data structure (or a stack of maps) from the standard 
--Haskell library, and so on.
data Env = EmptyEnv
         | ExtendEnv String Val Env
     deriving (Show, Eq)

-----------------------------------------------------------

-- the evaluate function takes an environment, which holds variable
-- bindings; i.e. it stores information like `x = 42`
-- the trace there will print out the values with which the function was called,
-- you can easily uncomment it if you don't need it for debugging anymore.
evaluate:: Expr -> Env -> Val
evaluate expr env = 
  trace("expr= " ++ (show expr) ++ "\n env= " ++ (show env)) $
  case expr of
  Const v -> v
  lhs :+: rhs -> 
    let valLhs = evaluate lhs env
        valRhs = evaluate rhs env
    in (IntV $ (valToInteger valRhs) + (valToInteger valLhs))
  _ -> error $ "unimplemented expression: " ++ (show expr)

-----------------------------------------------------------
valError s v = error $ "expected: " ++ s ++ "; got: " ++ (show v)

-- helper function to remove some of the clutter in the evaluate function
valToInteger:: Val -> Integer
valToInteger (IntV n) = n
valToInteger v = valError "IntV" v

-----------------------------------------------------------
-- the function that we test. since we always start out with an EmptyEnv.
interpret :: Expr -> Val
interpret expr = evaluate expr EmptyEnv














---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------- Tests ----------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
testConstant = 
  assert result (IntV 2) "testConstant"
  where result = interpret expr
        expr = Const (IntV 2)

---------------------------------------------------------------------

testAddition = 
  assert result (IntV 2) "testAddition"
  where result = interpret expr
        expr = (Const (IntV 1)) :+: (Const (IntV 1))

---------------------------------------------------------------------

-- MORE TESTS HERE!

---------------------------------------------------------------------

testAll = 
  if (allPassed) 
    then "All tests passed."
    else error "Failed tests."
  where allPassed = testConstant &&
                    testAddition

---------------------------------------------------------------------
assert :: Val -> Val -> String -> Bool
assert expected received message = 
  if (expected == received) 
    then True
    else error $ message ++ " -> expected: `" ++ (show expected) ++ "`; received: `" ++ (show received) ++ "`"