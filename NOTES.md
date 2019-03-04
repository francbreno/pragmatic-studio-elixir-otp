## 3. High Level Transformations

- conventions
- Thinking in terms of transforming data with functions
- Use the pipe operator instead of nested functions

## 4. Parse Request Line

- Maps: `%{ method: "GET", status: 200 }`
- `String` module
- `h` function in *IEX*
- Function arity: number of args the function receives
- `List` module
- Presenting **Pattern Matching**
- the *match* operator, `=`
- The *pin* operator, `^`: match without binding
- List *destructuring*
- A *term*: a value of any data type
- Map shortcut using *atoms*
  
  ## 5. Route and Response

  - Acessing map items
    - `my_map[:my_key]` or `my_map.my_key`
      - Dot notation is only valid for *atom* keys
    - if key doesn't exists?
      - `my_map[:my_key]` -> nil
      - `my_map.my_key` -> Error!
  - Assignments are invalid
    - All data structures are `immutable`
    - So, a bind cannot be performed
    - How to change values
      - Returning new Structures
      - `Map.put/3`
      - `%{ original_map | key_to_change: "Key Value" }`
        - Only for keys that already exists
  - String Lengths
    - *Sequence of bytes* in ELixir: a *binary*
    - Double-quoted strings, "", are internally represented as binaries. More precisely **UTF-8 encoded** binaries
    - So:
      - String.length("Joao e Maria") -> 12
      - byte_size("Joao e Maria") -> 12
      - String.length("João e Maria") -> 12
      - byte_size("João e Maria") -> 13
        - *ã* is represented with 2 bytes
 
 ## 6. Function Clauses

  - Plugging functions to the ppeline
  - Using `IO.inspect/1` to write values to the device
  - One line function definition:
    - `def f(arg), do: IO.inspect(arg)`
  - Using `if` statements
    - Not elixir *idiomatic*
    - Preffer *pattern matching* and *functions*
  - Functions with *same name* and *same number of args* -> *function clauses*
    - Elixir try each clause until one of them matches the pattern
      - So **declaration order is important**
    - If no match is possible, an error is thrown: `FunctionClauseError`
  - Function Clauses allow us to write a more declarative code with no conditional structures
    - More readable
    - Easy to follow along
  - Tips:
    - It's possible to call functions without parentheses, `()`
      - But recommendation is to use
        - Avoid possible ambiguities
      - Pipe operator doesn't allow function calls without parentheses

## 7. Request Params and Status Codes

 - Matching functions with pattern matching
 - Functions are avalied for the pattern in order
 - Munctions with the same signature must be together
 - New map from a previous one changing multiple keys at the same time
   - `%{ my_map | key_a: 10, key_b: "Test" }`
 - Private functions
   - Can only be called in the module that defined it
   - `defp my_private_funtion(arg), do: ...`
 - String concatenation: `<>` operator: `"A" <> " Big" <> " Test!"`
   - Its possible to pattern match a string using the `<>` operator as a String destructor
     - `"users/" <> id = "users/4357"` -> id = 4357
     - But:
       - pet_type <> "/" <> id = "dogs/99" -> Error: *the left argument of <> operator inside a match should be always a literal binary as its size can't be verified*

## 8. Rewrite Paths and Track 404s

  Defining specialized functions to transform requests
  and even responses: Plugins

  - Matching map keys:
    - `%{ age: 18 } = %{ name: "John Doe", age: 18, city: "New York" }`
      - It matches even if the left side doesn't have all keys
      - But cannot match if a key on the left side doesn't exists on the right side
      - Obviously, it doesn't matches inexistent keys on the right side
    - It's also possible to bind values on the right side
      - `%{ age: age } = %{ name: "John Doe", age: 18, city: "New York" }`
  - When pattern matching Strings, you can't use a variable on the left side on the operator `<>`
    - Solution: **Regular Expressions**
  - Regular Expressions
    - `~r{regex}`
    - `~r` is a *sigil* and `{}` are delimiters to the *regex*
    - Use the `Regex` module to work with regular expressions
  - Using the `Logger` module
    - Tip: To log data structures like Maps, it's necessary to convert it first into a binary (?: need to confirm)

## 9. Serve Static Files

Reading files

- `File` module
  - `read` function
    - success: `{:ok, binary}`
    - error: `{:error, reason}`
- Pattern matching to check the response
  - Using a `case` expression
  - Or function clauses
- Paths
  - Using the `Path` module
    - `expand` function
      - To read a file on a path relative to another path
  - `__DIR__`: Absolute path of the directory of the current file
    - `join`: joina list of paths into a new path usign the proper file separator
  
## 10. Module Attributes

Modules can have attributes

- `@moduledoc`: Documents the module
- `@doc`: Documents a function
- personalized modules attributes:
  - `@something "a value"`: defines a module attribute
    - The **value** of the attribute is **set** at **compile time**

## 11. Organizing Code

Grouping functions that have similar concerns

- When everything is on the same modules, we start to see clusters of similar functions
- We need to organize them in appropriate modules
- importing modules
  - `import`: Imports content into the current namespace
    - By default, imports module functions and macros
- Changing module attributes
  - From: `@pages_path Path.expand("pages", __DIR___)`
  - To: `@pages_path Path.expand("pages", File.cwd!)`
  - **Mix** *always* runs the app from the top-level directory
    - `File.cwd!` will always return the top-level directory

## 12. Modeling with Structs

 Maps are generic data structures. We need some constraints to represent our app concepts

- *structs* are special kinds of maps, with **fixed keys** and **default values**
- A *struct* needs to live in it's own module
- The name of teh struct is the name of the module
- Only one struct per module is allowed
- Doesn't allows dynamic access using square brackets
  - Structs doesn't implement `Access` *Behaviour*
  - Only dot notation is permited
- Can be pattern matched where a map is expected (left side is a *map* and right side is a *struct*)
- But doesn't match when the left side is a *struct* and the right side is a *map*
- To change a key value we use the same notation used with maps: `%{ my_struct | name: "Testing" }`
  - If `my_struct` is a *struct*, the operation will return a new *struct*
- Work with *structs* makes our application more robust
  - **Type Safety**
- We can use a *struct* inside another module using the *full module name* or using an `alias`:
  - `alias ShoppingApp.Accounts.Client`
    - And inside the module we can use just `Client`
    - or we could give it another name:
      - `alias ShoppingApp.Accounts.Client, as: Buyer`
- Normally you put the functions that operates on a *struct* in the same module
- **Keyword lists**:
  - Just *syntactic sugar* using a **list of tuples**
  - `[ name: "John Doe", age: 44, city: "Rome" ]`
    - It's the same as: `[{:name, "John Doe"}, {:age, 44}, {:city, "Rome"}]`
  - Keyword list are normally used as a list of options
  - Use maps for storing key/value pairs

## 13. Handle POST requests

Creating POST request to create new things

- Destructuring lists
  - *head* and *tail*
  - Lists in Elixir are implemented as a series of *linked lists*
  - `[head | tail] = [1,2,3,4,5]`
    - head: 1
    - tail: [2,3,4,5]
  - It's possible to use the `Kernel` functions `hd` & `tl`
  - The tail of the final element in a list is an empty list
    - If the list doesn't end with an empty list its called an *improper list*
  - Pattern matching using head and tails with an empty list result in an error
- Decoding a querystring from a request with `URI.decode_query`
  - Tip: `URI.decode_query` returns a map with keys as strings
    - Convert those keys to atoms is **dangerous**:
      - They come from *outside* of our application
      - Atoms **are not** *garbage collected*
      - The app can run **out of memory**
  - 