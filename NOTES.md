# Notes

- https://tour.gleam.run/
  - "Gleam code is organized into units called _modules_. A module is a bunch of definitions (of types, functions, etc.) that seem to belong together."
    - "All gleam code is in some module or other, whose name comes from the name of the file it's in. For example, `gleam/io` is in a file called `io.gleam` in a directory called `gleam`."
  - "Gleam has no `null`, no implicit conversions, no exceptions, and always performs full type checking."
  - "Gleam's numerical operators are not overloaded, so there are dedicated operators for working with floats."
    - `echo 1.0 +. 1.5`
  - "Underscores can be added to numbers for clarity."
  - "Gleam has the `==` and `!=` operators for checking equality."
    - "The operators can be used with values of any type, but both sides of the operator must be of the same type."
    - "Equality is checked structurally, meaning that two values are equal if they have the same structure rather than if they are at the same memory location."
  - `// String concatenation` + `io.println("One " <> "Two")`
  - "A value can be assigned to a variable using `let`."
  - "In Gleam variable and function names are written in `snake_case`."
  - "Unlike functions, Gleam types are commonly imported in an unqualified way."
    - `import gleam/string_tree.{type StringTree}`
  - "A type's name always starts with a capital letter, contrasting to variables and functions, which start with a lowercase letter."
  - "When the `pub` keyword is used the type alias is public and can be referred to by other modules."
  - "Type aliases should be used rarely."
  - "Blocks are one or more expressions grouped together with curly braces. Each expression is evaluated in order and the value of the last expression is returned."
    - "Any variables assigned within the block can only be used within the block."
    - "(...) `{ 1 + 2 } * 3`. This is similar to grouping with parentheses in some other languages."
  - "Lists are immutable single-linked lists, meaning they are very efficient to add and remove elements from the front of the list."
    - "Counting the length of a list or getting elements from other positions in the list is expensive and rarely done. It is rare to write algorithms that index into sequences in Gleam, but when they are written a list is not the right choice of data structure."
  - "As well as let assignments Gleam also has constants, which are defined at the top level of a module."
    - `const ints: List(Int) = [1, 2, 3]`
    - "Constants must be literal values, functions cannot be used in their definitions."
    - "Using a constant may be more efficient than creating the same value in multiple functions, though the exact performance characteristics will depend on the runtime and whether compiling to Erlang or JavaScript."
  - "The `fn` keyword is used to define new functions."
  - "Gleam is an expression based language so there is no `return` operator, but there are ways to conditionally return early from a function (...)"
  - "The `double` and `multiply` functions are defined without the `pub` keyword. This makes them private functions, they can only be used within this module."
  - "It is considered good practice to use type annotations for functions (...)"
  - "In Gleam functions are values. They can be assigned to variables, passed to other functions, and anything else you can do with values."
    - `fn twice(argument: Int, passed_function: fn(Int) -> Int) -> Int {`
  - "Gleam has anonymous function literals, written with the `fn() { ... }` syntax."
    - "Anonymous functions can reference variables that were in scope when they were defined, making them _closures_."
  - Generic functions:
    - "(...) Gleam supports generics, also known as parametric polymorphism."
    - "This works by using a type variable instead of specifying a concrete type. It stands in for whatever specific type is being used when the function is called. These type variables are written with a lowercase name."
    - `fn twice(argument: value, my_function: fn(value) -> value) -> value {`
  - Pipelines:
    - "It's common to want to call a series of functions, passing the result of one to the next. (...) pipe operator `|>` helps with this problem by allowing you to write code top-to-bottom."
    - "It will first check to see if the left-hand value could be used as the first argument to the call. For example, `a |> b(1, 2)` would become `b(a, 1, 2)`. If not, it falls back to calling the result of the right-hand side as a function, e.g., `b(1, 2)(a)`"
    - "If you need to debug print a value in the middle of a pipeline you can use `|> echo` to do it."
- https://gleam.run/install/
  - https://gleam.run/install/macos/gleam/asdf/
- https://gleam.run/install/macos/editor/
- https://gleam.run/writing-gleam/
- https://mise-tools.jdx.dev/tools/gleam
- https://github.com/gleam-lang/gleam/releases
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Closures: "A closure is the combination of a function bundled together (enclosed) with references to its surrounding state (the lexical environment). In other words, a closure gives a function access to its outer scope. In JavaScript, closures are created every time a function is created, at function creation time."
- https://github.com/gleam-lang/httpc
- https://github.com/lpil/gleescript
- https://documentation.ubuntu.com/snapcraft/stable/tutorials/craft-a-snap/
- https://github.com/lpil/envoy: "(...) Gleam package for reading environment variables."
- https://gleam.run/command-line-reference/
  - `gleam export erlang-shipment`: "Precompiled Erlang, suitable for deployment"

## Commands

```bash
mise uninstall --all
```
