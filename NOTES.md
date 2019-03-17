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

  - Plugging functions to the pipeline
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

## 14. Recursion

Defining funtions to "consume" lists

- Using the pattern `[head | tail]`
- It's necessary to define as function clause for the pattern `[]`. Otherwise, an error is thrown
- **Tail call optimization**
  - recursive call is the last instruction of the function

## 15. Slicing and Dicing with Enum

- Using `Enum` module functions
  - *Transform* a list in another list
    - we'll use the `map` function
  - *Filter* only certain items in a list
    - we'll use the `filter` function
  - *Search* for an item in a list
    - we'll use the `find` function
  - *Reduce* a list to a single value
    - we'll use the `reduce` function
- Capture Operator: `&`
  - A shortcut for defining anonymous functions
  - `&` wraps the named function in an anonymous function
  - args are passed as &1, &2, ...
  - It's a more concise way to declare anonymous functions
  - Needs to be used with caution:
    - Avoid to obscure code
    - Use when make sense, with parsimony
    - *Clear code* is better than *Clever code*
  - We can use the capture operator to capture expressions to generate an anonymous function
    - `&(&1 * 3)` is the same as `fn(x) -> x * 3 end`

## 16. Comprehensions

- **.eex** extensions: embedded elixir
- The `EEx` module
  - `eval_file` function: evaluates the file (filename) using *bindings*
- The *Generator* operator: `<-`:
  - `for x <- [1,2,3], do: x * 2`
  - A sucint way to transform a list in another one
- A comprehension can receive more than one generator
  - `for size <- ["S", "M", "L"], color <- [:red, :green], do: {size, color} `
  - Works as a nested loop
- Filtering expressions:
  - `for {name, :dog} <- [{"Rufus", :dog}, {"Max", :cat}, {"Lester", :dog}], do: name`
  - or using *filter expressions*
    - `for {name, pet_choice} <- [{"Rufus", :dog}, {"Max", :cat}, {"Lester", :dog}], pet_choice: :dog, do: name`
    - a filter can be any *predicate*:
      - `for {name, pet_choice} <- [{"Rufus", :dog}, {"Max", :cat}, {"Lester", :dog}], its_a_dog?(pet_choice), do: name`
- Default parameters:
  - `def sum(a, b \\ 10), do: a + b`
- Atomize Keys:
  - It's more confortable to work with atoms when dealing with maps keys
  - how to convert a string key into a atom
  - Using `Map.new` function:
    - `Map.new(original_map, fn({k, v}) -> {String.to_atom(k), v} end)`
  - Using a *Comprehension*:
    - observe the `:into` option
    - `for {k, v} <- original_map, into: %{} do: {String.to_atom(k), v}`
  - Some others `Enum` functions
    - `random`: returns a random element
    - `take_random`: take a group of n random elements
    - `shuffle`: Shuffle the *enumerable* elements  
    - `take`: take the first n elements of a list
    - `chunk_every`: chunk in groups of n elements

## 17. A Peek at Phoenix

Just a sneak peek at the Phoenix Framework

## 18. Test Automation

How to write automated tests in Elixir

- `mix` generates some king of basic structure for testing
- Tests are scrips `.exs`, so they don't need to be compiled to execute
- **ExUnit**: The Elixir built in test framework
- `ExUnit.Case`: The basic test module
- test macros:
  - `test`
  - `assert`
  - `refute`
  - `doctest`
- How to run the tests:
  - `mix test` or `mix test path/to/file.exs`
- **Doctests**:
  - Elixir docs are writen in **Markdown**
  - It's useful to include **examples** abount **how to use** the function
  - By convention, the examples are writen as a **iex** session
  - The examples are called the *doctests*
    - The are expetations about how the code needs to work
  - `doctest` is a *macro* that looks for doctests ina module. If it founds any, it creates some tests for them
  - On the test report, they are accounted as *doctests*
- Tip: Speeding Up Tests
  - Execute tests concurrently
    - `use ExUnit.Case, async: true`
    - Caution: Beware that you won't be able to use this trick if a test case accesses shared state or resources with another test cases
- Tip: Organizing doctests
  - Aggregate all doctests into a new test case 

## 19. Rendering JSON

Using an external JSON library (**Poison**) to parse render JSON data

- Using the [https://hex.pm](Hex) package manager
- Add dependencies in the `deps` function inside
- the `mix.ex` file
- `mix deps`: list all the dependencies
- `mix deps.get`: download pending dependencies
- All the dependencies are inside the directory *deps*
- Tip: To see the dependencies version patterns, use `h Version` in an `iex` session

## 20. Web Server Sockets

Time to create a real server

- How *Client - Server* systems works
  - *listen socket*: to accept connection requests
  - *client socket*: 
- *Socket* Layer and *Request Handler* Layer
  - **Socker Layer**: Communicating with HTTP Clients
  - **Request Handler Layer**: Transforms the request string into a response string
- Using **Erlang** socket library `gen_tcp`
- **Erlang** rich library: If you need something that's not available in Elixir, look for it in the Erlang libraries
- Starting the server using `mix`: `mix run -e "Servy.HttpServer.start(4000)"`
  
## 21. Concurrent, Isolated Processes
  - `spawn` function: executes some code on a different process
    - `spawn(fn -> IO.puts "I'm Running... not for too long" end)`
      - Returns the `pid` of the process
      - The `pid` is a process identifier. It's unique for each process
        - It's an address to send messages toa `process`
  - MFA (Module, Function, Args)
    - `spawn(MyApp.Server, :start, [8080])`
  - Functions in Elixir are Closures
    - Values are *deep copied* since **process shares no memory** inside the **BEAM VM**
  - `self` function: returns the **current process** `pid`
    - It's **not a string**. It's **a data structure**
  - Getting System Info
    - `Process` module
      - `Process.list`
    - `:erlang` module
      - `:erlang.system_info(:process_count)`: returns the number of processes runninng at the moment. Same as `Process.list |> Enum.count`
    - `:observer` module
      - `:observer.start`: A *GUI interface* to inspect the current state of the BEAM VM
  - In case of an error in a spawned process, the parent process stay running
  - Elixir and Erlang process are prefixed with the name `Elixir.`

## 22. Sending and Receiving Messages

  - *Parent* and *Child* Processes
    - How they communicate with each other?
      - As any process do: **Sending asynchronous messages**
  - **Processes mailboxes**:
    - Each process has a mailbox to receive other processes messages
    - Only one message is read 
    - The mail box is a *queue*
    - The *mailbox address* is the `pid` of the process
    - How to send a message:
      - using the function `send`
        - `send(destiny_pid, message)`
        - A *message* can be any elixir *term*
          - `send(pid, "hi there!")` 
          - `send(pid, {:response, "yes, we can be friends"})`
          - `send(pid, {:ok, %Product{ name: "Laptop", price: 900.00, maker: "Fantasy Tech" }})`
    - An how a process read messages from his mailbox?
      - Using a `receive do` block
      - It's like a `case` expression
      - We pattern match the message content
      - `receive do` is *blocking*
  - It's possible to see all the messages in the mailbox without consuming them
    - `Process.info(pid, :messages)`
  - Messages stay in the queue until they are *received* or the process ends
  - The **Actor Model** of Concurrency
    - Each process is an *actor*
      - Isolated
      - Independent
      - Doesn't share anything

## 23. Asynchronous Tasks

- `Task` module
  - Execute async operations
  - functions:
    - `async`: async execution of a function returning the `pid` on where the function is running
      - It doesn't returns a pid, but a `Task` *struct*
    - `await`: has a `receive` block to receive the response message from a task execution
  - The `Task` *struct* has all the data necessary to deal sending and receiving async tasks, like the parent pid, the task process pid, response struct, etc
  - Abstract operations, simplifying code
  - Operations can take too long to respond
    - It's possible to define an `after` expression inside a `receive` expression
    - So, it's also possible to define a timeout in a `Task`
      - In fact, `Task` defines a **default timeout** of **5 seconds**
      - That value can be overriden passing **another value**, **in milliseconds**, to the `await` function
        - `Task.await(task, 10000)`
        - It's possible to wait indefinitely passing the atom `:infinity`
        - `Task.await(task, :infinity)`
  - Checking if a long-running task has finished
    - `await` can only be called **once** for any task
    - Use the function `yield` from the `Task` module
    - `yield` will wait for the timeout. If the response has arrived, it will responds with `{:ok, response}`. Otherwise, it will responds with `nil`
    - You can shutdown a task using the function `shutdown` from the module `Task`. It avoids long running tasks to wait for too long
  - **When to use?**:
    - When you need to run a function *asynchronously* in a short-live process
  - Making code more expressive using `:timer.seconds`
    - `Task.await(task, :timer.seconds(7))`
  
## 24. Stateful Server Processes

- **Modules** can't hold state
- But **Processes** can
  - Executing the function in a *recursive loop*
  - The *inicial state* e providade as a *function arg*
  - Processes can handle different messages
    - Just pattern match each one and handle accordingly
- Sending a message is **always** an async operation
- Abstract the Server interaction inside a module
- Registering a process under an arbitrary name
  - When you only need one process executing
  - Avoids the necessity to send the pid on all the server operations
  - The name must be an `atom`
  - `Process.register(pid, :server_name)`
  - It's possible to *unregister*
    - `Process.unregister(:server_name)`
- How to deal with invalid/unexpected messages?
  - If a message is not handled on the `receive` expression it will stay hanging around the process mailbox
    - It can be problematic
    - Processing can be slow
    - mailbox might get full of invalid messages
    - Process can stop dealing with valid messages
  - The solution is to use a pattern to match all the other messages on the `receive` expression
    - They can be simply discarded
- Message handling is **always** serialized
  - So, the server process is a *synchronization point* in the application
  - Preserves the integrity of the state
- If you need the server pid when you define it with a unique name
  - `Process.whereis(:server_name)`
- **Agents**
  - A simple *wrapper* around a server process
    - to store state
    - to offer a simple API to access the state
  - No need to define a module
  - No need to write a `receive` expression
  - No need to define a recursive loop
  - `Agents` are great when you only need a process to store state
    - but:
      - It's all an `Agent` can do
      - It can't run computations or asynchronous operations
    - Because of those things, `Agents` are not used very often in the "real world"
      - A *more complete abstration* elixir offers is a **GenServer**
  
## 25. Refactoring Toward GenServer

- Just code changes

## 26. OTP GenServer

- OTP Behaviours
  - Encapsulation of *design patterns*
  - Conventions
- GenServer
  - an *OTP Behaviour*
  - Long duration Processes
  - expect **6 callback functions**
    - minimum: `handle_call` &/or `handle_cast`
  - The `use` macro
    - Injects **default implementations** from the *callback module*
    - `use GenServer`
  - `GenServer` has some specs
    - handle_cast return: `{:noreply, new_state}`
      - `:noreply`: the most common
    - handle_cast return: `{:reply, response, new_state}`
  - GenServer state
    - If state is getting more complex
      - Encapsulate it into a *struct*
  - `call` & `cast`
    - Use `call` when you need to execute the operation in a *synchronous way* to get back *response*
    - Use `cast` when you need to execute the operation *asynchronous* and you don't want an immediate answer
  - `init` callback
    - Used to initialize the state
      - ex.: Fetch some data to put in the state
    -  it's a *blocking* operation
       -  start will block and wait for init to comoplete
       -  It's necessary caution when performing operations on `init`
       -  Server process can only be used after being successfully initialized
  - `handle_info`
    - handles messages not sent using `call` or `cast`
      - messages sent using `send`
    - It has other practical uses
  - `Task`, `Agent` or `GenServer`?
    - To perform a one-off computation or query asynchronously -> `Task`
    - To simply hold a state in a process -> `Agent`
    - For a long running process, storing state a performing operations -> `GenServer`
    - To serialize access to a shared resource or service used by multiple concurrent processes -> `GenServer`
    - For background operations to be executed periodically -> `GenServer`
    - You can start with a `Task` or an `Agent` and, if necessary, migrate to a `GenServer`
  - How to **stop the server**?
    - Handling a message returning a tuple with the following pattern: `{:stop, reason, new_state}`
  - Initialization
    - typically `init` returns {:ok, state}
    - If something goes wrong, you can return `{:stop, reason}`, so start will return `{:error, reason}`
  - `terminate(reason, state)` callback
    - to execute some *cleanup code* after handling a message returning a *stop* tuple
    - In some cases, `terminate` is not called
      - So, it's not a reliable way to clean up after a process. Use a `Supervisor`, instead
  - `code_change` callback
    - for hot code-swapping
    - normally **you doesn't need to implement** this callback
  - Call Timeouts
    - *default* timeout value: 5000
    - can be set as the third argument to `call`
      - `GenServer.call(@name, :last_notifications, 3000)`
  - Debuging and Tracing
    - The `sys` module from **Erlang**

## 27. Another GenServer

- Code development only

## 28. Linking Processes

- Making processes resilient to failures
  - We need something to *start*, *monitor* and *start a new process* to replace he failured one.
  - **OTP Supervisor Behavior**
    - For *OTP compliant* processes only
  - For *non OTP* Processes
    - We need an *OTP compliant* monitor process like a `GenServer`
      - And `link` the processes
  - Monitoring processes
    - We need to `link` them together
      - `Process.link(pid)`
      - or directly  when spawning the process
        - `spawn_link`
          - `spawn` and `link` are executed in one operation
          - It avoids potencial *race conditions*
      - Listing a process links
        - `Process.info(pid, :links)`
      - Linking is *bidirectional*
      - And their fates are tied together
        - Image processes *a* and *b* are linked
        - if we kill the process *a*, process *b* is also killed and vice-versa
    - Once death, *a process cannot be respawned*
      - we need to start a new one
    - Trapping exits
      - To catch/trap an *exit signal* from a linked process
        - `Process.flag(:trap_exit, true)`
        - If process *a* traps exit and is linked to a process *b*, if *b* exits *a* doesn't exists anymore
        - The process that traps the exit transforms the exit signal into a message that needs to be handled in a `handle_info` function
          - the message pattern: `{:EXIT, #PID<>, kill_reason}`
      - Normal vs Abnormal process termination
        - normal termination
          - reason is **always** `:normal`
            - the **linked process doesn't terminate**
        - abnormal termination
          - anything but `:normal`
            - the **linked process terminates** with the **same reason** 
              - Unless the process is trapping exit
      - Monitoring process
        - It's possible to be aware of a process termination without tying their fates together
        - Instead of linking the processes using `Process.link(pid)`, we just monitor the process with `Processo.monitor(pid)`
        - Unlike links, monitors are *unidirectional*
        - `Process.monitor` returns a *reference*. It can stop monitoring the process with the function `Process.demonitor(reference)`
      - Tasks and links
        - Processes spwaned by a Task are **automatically linked** to the calling process

## 29. Fault Recovery with OTP Supervisors

- **Supervisors**
    - OTP *Behavior*
    - Are *special types* of **GenServers**
    - starts, monitors and "restart" processes under *supervision*
    - Supervised processes are called *children*
  - Restart strategies
    - :one_for_all
      - if on child process dies, all the other children are terminated by the supervisor and new processes are spawned to replace them
      - Use it when child processes are dependent on each other
    - :one_for_one
      - if a child process die, the supervisor spawn a new process to replace the terminated one. All the other children stay untouched
      - Use it when children are independent on each other
  - A supervisor is a process like any other
  - `Supervisor` **doesn't have** a `start` function, just a `start_link` function
  - Supervisor behavior expects a `init` function`to be implemented
  - It's on the `init` function that we tell the Supervisor wich process it needs to start and supervise as it's children
    - We need to call the `Supervision.init` function passing a list of modules to spawn process for supervision and the *strategy* to be used.
  - The `Supervisor` behavior assumes some conventions:
    - We a process child starts it needs to be linked to the supervisor, so `Supervisor` assumes that the modules to be used to start child processes need to define a function `start_link` receiving an arg
  - We can list all the supervised processes from a supervisor calling `Supervisor.which_children(pid)`
  - We can also count the children calling `Supervisor.count_children(pid)`, returning a *map* with the counting of each kind of process under supervision
  - If you need to pass an arg to a child when starting the supervision, you need to pass a *tuple* instead of a module in the children list
    - {ModuleName, arg_value}
    - the arg can be any Elixir *term*
  - **Child Specs**
    - The GenServer behavior defines a function called `child_spec`
    - By default, supervisors call this function passing an empty list as an arg when initializing the chidren processes
      - This function returns a *child specification*, an map with information about how the supervisors should start a supervise the child processes from this GenServer
    - We can *override* default child spec values from GenServers implementing a `child_spec` function or passing args on the `use` expression 
  - Supervising other supervisors
    - Supervisors can supervises other supervisors too
    - It creates a **supervision tree**
      - A hierarchy of supervisors and *workers*
        -  workers are processes other than supervisors
    - **Supervisors traps exits signals**
      - So the exit signals only propagate to the immediate supervisor
    - **Errors are isolated to specific subtrees**

