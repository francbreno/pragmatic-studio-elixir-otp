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