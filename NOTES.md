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
- https://gleam.run/install/
  - https://gleam.run/install/macos/gleam/asdf/
- https://gleam.run/install/macos/editor/
- https://gleam.run/writing-gleam/
- https://mise-tools.jdx.dev/tools/gleam
- https://github.com/gleam-lang/gleam/releases

## Commands

```bash
mise uninstall --all
```
