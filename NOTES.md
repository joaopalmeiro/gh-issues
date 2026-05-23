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
  - "To help with this Gleam supports labelled arguments, where function arguments are given an external label in addition to their internal name. These labels are written before the argument name in the function definition."
    - `fn calculate(value: Int, add addend: Int, multiply multiplier: Int) {`
    - ` echo calculate(1, add: 2, multiply: 3)`
    - "(...) all unlabelled arguments must come before labelled arguments."
    - "There is no performance cost to using labelled arguments, it does not allocate a dictionary or perform any other runtime work."
    - Label shorthand syntax ("When local variables have the same names as a function's labelled arguments (...)"): `echo calculate_total_cost(quantity:, unit_price:, discount:)`
  - "The case expression is the most common kind of flow control in Gleam code. It is similar to `switch` in some other languages (...)"
    - "Gleam performs _exhaustiveness checking_ to ensure that the patterns in a case expression cover all possible values."
    - "When pattern matching on strings the `<>` operator can be used to match on strings with a specific prefix."
      - "The pattern `"Hello, " <> name` matches any string that starts with `"Hello, "` and assigns the rest of the string to the variable `name`."
    - "Lists and the values they contain can be pattern matched on in case expressions."
      - "The list append pattern `..` can be used to match the rest of the list."
    - "(...) you can give multiple subjects and multiple patterns, separated by commas."
    - "Alternative patterns can be given for a case clause using the `|` operator. If any of the patterns match then the clause matches."
    - "The `as` operator can be used to assign sub patterns to variables."
    - "The `if` keyword can be used with case expressions to add a _guard_ to a pattern. A guard is an expression that must evaluate to `True` for the pattern to match."
      - "Guard expressions _cannot_ contain function calls, case expressions, or blocks."
  - "Gleam doesn't have loops, instead iteration is done through recursion, that is through top-level functions calling themselves with different arguments."
  - "Lists are good for when we want a collection of one type, but sometimes we want to combine multiple values of different types. In this case tuples are a quick and convenient option."
  - "Tuples are most commonly used to return 2 or 3 values from a function. Often it is clearer to use a _custom type_ where a tuple could be used."
  - "A variant of a custom type can hold other data within it. In this case the variant is called a record."
    - "It is common to have a custom type with one variant that holds data, this is the Gleam equivalent of a struct or object in other languages."
  - "The accessor syntax can always be used for fields with the same name that are in the same position and have the same type for all variants of the custom type. Other fields can only be accessed when the compiler can tell which variant the value is, such as after pattern matching in a `case` expression."
  - "The record update syntax can be used to create a new record from an existing one of the same type, but with some fields changed."
    - `let teacher2 = Teacher(..teacher1, subject: "PE", room: 6)`
    - "Gleam is an immutable language, so using the record update syntax does not mutate or otherwise change the original record."
  - https://hexdocs.pm/gleam_stdlib/gleam/option.html
  - "`Nil` is Gleam's unit type. It is a value that is returned by functions that have nothing else to return, as all functions must return something."
  - "Gleam doesn't use exceptions, instead computations that can either succeed or fail return a value of the built-in `Result(value, error)` type."
    - "`Ok`, which contains the return value of a successful computation."
    - "`Error`, which contains the reason for a failed computation."
  - "Commonly a Gleam program or library will define a custom type with a variant for each possible problem that can arise, along with any error information that would be useful to the programmer."
  - "Gleam code commonly uses the `gleam/result` standard library module and `use` expressions when working with results (...)"
  - "`fold` combines all the elements in a list into a single value by running a function left-to-right on each element, passing the result of the previous call to the next call."
  - "Result functions are often used with pipelines to chain together multiple calls to result-returning functions."
  - https://hexdocs.pm/gleam_stdlib/gleam/result.html
  - "(...) Gleam's `Dict` type and functions for working with it. A dict is a collection of keys and values which other languages may call a hashmap or table."
    - "Dicts are unordered! If it appears that the items in a dict are in a certain order, it is incidental and should not be relied upon."
  - https://hexdocs.pm/gleam_stdlib/gleam/option.html
  - "The option type is very similar to the result type, but it does not have an error value."
  - "(...) types with _smart constructors_. A smart constructor is a function that constructs a value of a type, but is more restrictive than if the programmer were to use one of the type's constructors directly."
  - "For example, this `PositiveInt` custom type is opaque. If other modules want to construct one they have to use the `new` function, which ensures that the integer is positive."
    - `pub opaque type PositiveInt {`
  - "Gleam lacks exceptions, macros, type classes, early returns, and a variety of other features, instead going all-in with just first-class-functions and pattern matching. This makes Gleam code easier to understand, but it can sometimes result in excessive indentation."
  - "The `panic` keyword (...) is used to crash the program when the program has reached a point that should never be reached."
    - "This keyword should almost never be used!"
    - "`let assert` is another way to intentionally crash your Gleam program."
    - "Bool `assert` is the final way to cause a panic in Gleam, used for writing test assertions."
  - "Sometimes in our projects we want to use code written in other languages, most commonly Erlang and JavaScript, depending on which runtime is being used. Gleam's external functions and external types allow us to import and use this non-Gleam code."
    - "Multiple external implementations can be specified for the same function, enabling the function to work on both Erlang and JavaScript."
    - "It's possible for a function to have both a Gleam implementation and an external implementation."
- https://gleam.run/install/
  - https://gleam.run/install/macos/gleam/asdf/
  - https://github.com/Homebrew/homebrew-core/blob/a275516112bbff26ff5c4d6a99fcf261290ade70/Formula/g/gleam.rb
  - https://www.erlang.org/
- https://gleam.run/install/macos/editor/
- https://gleam.run/writing-gleam/
  - https://hexdocs.pm/gleescript/index.html
  - "As we're using the Erlang target we can do this using `escript`, which is part of the Erlang runtime."
  - "(...) an escript is BEAM bytecode wrapped in a shell script. It's platform-independent, unlike a native binary."
  - "The escript can run on any computer that has the Erlang VM installed."
- https://mise-tools.jdx.dev/tools/gleam
- https://github.com/gleam-lang/gleam/releases
- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Closures: "A closure is the combination of a function bundled together (enclosed) with references to its surrounding state (the lexical environment). In other words, a closure gives a function access to its outer scope. In JavaScript, closures are created every time a function is created, at function creation time."
- https://github.com/gleam-lang/httpc
- https://github.com/lpil/gleescript
- https://documentation.ubuntu.com/snapcraft/stable/tutorials/craft-a-snap/
- https://github.com/lpil/envoy: "(...) Gleam package for reading environment variables."
- https://gleam.run/command-line-reference/
  - `gleam export erlang-shipment`: "Precompiled Erlang, suitable for deployment"
- https://hex.pm/
- https://gleam.run/writing-gleam/gleam-toml/
  - https://hexdocs.pm/elixir/Version.html#module-requirements
- https://github.com/catppuccin/gleam
- https://docs.github.com/en/rest/repos/repos?apiVersion=2026-03-10#list-repositories-for-the-authenticated-user
- https://docs.github.com/en/rest/issues/issues?apiVersion=2026-03-10#list-repository-issues
- https://github.com/gleam-lang/erlang
  - https://github.com/gleam-lang/erlang/blob/v1.3.0/CHANGELOG.md#v100-rc1---2025-04-24: "The `gleam/erlang/os` module has been removed. The `input` and `envoy` packages may be a suitable replacement."
- https://github.com/drewolson/clip
  - https://hex.pm/packages/clip
- https://www.gleambits.co/guide/essentials/error.html
  - https://github.com/lpil/snag
  - https://hexdocs.pm/gleam_stdlib/gleam/dict.html#get
- https://hexdocs.pm/gleam_http/4.3.0/gleam/http/request.html#new
- https://github.com/renatillas/gleam/blob/78df2fa64a68783f5f80645117e28e6348bc5384/rules/coding-standards.md
- https://github.com/gleam-lang/json
  - https://hexdocs.pm/gleam_json/gleam/json.html
- https://hexdocs.pm/gleam_stdlib/gleam/list.html#filter_map
- https://www.danielbark.com/blog/http-in-gleam/
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Link#pagination_through_links
- https://hexdocs.pm/gleam_stdlib/gleam/option.html#from_result
- https://hexdocs.pm/gleam_stdlib/gleam/int.html#range
- https://josh.is-cool.dev/a-brief-interlude-into-gleam-concurrency/
- https://olano.dev/blog/gleam-coming-from-erlang/
- https://hexdocs.pm/gleam_erlang/gleam/erlang/process.html#spawn_unlinked:
  - https://hexdocs.pm/gleam_erlang/gleam/erlang/process.html#spawn
  - "Create a new Erlang process that runs concurrently to the creator. In other languages this might be called a fibre, a green thread, or a coroutine."
- https://hexdocs.pm/gleam_erlang/gleam/erlang/process.html#send
- https://hexdocs.pm/gleam_erlang/gleam/erlang/process.html#receive
  - "The `within` parameter specifies the timeout duration in milliseconds."
- https://isaac.zone/articles/simplifile_gleam
- `io.println(string.inspect(string.split_once(part, "; ")))`
- `io.println(int.to_string(resp.status))`
- `io.println(resp.body)`
- `io.println(string.inspect(first_page))`
- https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2026-03-10#about-secondary-rate-limits
- https://github.com/lpil/tom
- https://cli.github.com/manual/
  - "Run `gh auth login` to authenticate with your GitHub account. Alternatively, gh will respect the `GITHUB_TOKEN` environment variable."
  - https://cli.github.com/manual/gh_release_create
    - "If a matching git tag does not yet exist, one will automatically get created from the latest state of the default branch."

## Commands

```bash
mise uninstall --all
```

```bash
gleam new gh_issues
```

```bash
mkdir -p ~/Documents/kiro-gh-issues && rsync -a --delete --exclude={'.git','.DS_Store','NOTES.md'} ~/Documents/GitHub/gh-issues/ ~/Documents/kiro-gh-issues
```

```bash
kiro ~/Documents/kiro-gh-issues
```

## Snippets

```gleam
pub fn main() {
  echo factorial(5)
  echo factorial(7)
}

// A recursive functions that calculates factorial
pub fn factorial(x: Int) -> Int {
  case x {
    // Base case
    0 -> 1
    1 -> 1

    // Recursive case
    _ -> x * factorial(step_towards_zero(x))
  }
}

fn step_towards_zero(x: Int) -> Int {
  case x >= 0 {
    True -> x - 1
    False -> x + 1
  }
}
```

vs.

```gleam
pub fn main() {
  echo factorial(5)
  echo factorial(7)
}

pub fn factorial(x: Int) -> Int {
  // The public function calls the private tail recursive function
  factorial_loop(x, 1)
}

fn factorial_loop(x: Int, accumulator: Int) -> Int {
  case x {
    0 -> accumulator
    1 -> accumulator

    // The last thing this function does is call itself
    // In the previous lesson the last thing it did was multiply two ints
    _ -> factorial_loop(x - 1, accumulator * x)
  }
}
```

```gleam
pub fn with_use() -> Result(String, Nil) {
  use username <- result.try(get_username())
  use password <- result.try(get_password())
  use greeting <- result.map(log_in(username, password))
  greeting <> ", " <> username
}
```

- https://hexdocs.pm/outil/index.html

```gleam
import gleam/erlang
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import outil.{command, print_usage_and_exit}
import outil/arg
import outil/opt

fn say_hello(args) {
 use cmd <- command("hello", "Say hello to someone", args)
 use name, cmd <- arg.string(cmd, "name")
 use enthusiasm, cmd <- opt.int(cmd, "enthusiasm", "How enthusiastic?", 1)

 use name <- name(cmd)
 use enthusiasm <- enthusiasm(cmd)

 let message = "Hello, " <> name <> string.repeat("!", enthusiasm)

 Ok(io.println(message))
}

pub fn main() {
 // Erlang is not required, this example just uses it for getting ARGV
 let args = erlang.start_arguments()

 say_hello(args)
 |> result.map_error(print_usage_and_exit)
}
```
