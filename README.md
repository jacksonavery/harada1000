HARADA-1000 is a befunge-like language/interpreter. It's self modifying, written two-dimensionally, and (naïvely) supports threading.
You can find the full list of commands in `_todo.text`.

Individual "operators" (threaded function pointers) move and then perform whatever function they're on top of, and posses a personal stack.
Functions *generally* pop every variable they work on—you will often have to duplicate the top of the stack with `:`.

There's a lot of small quirks with the language. It's impossible to set a cell to value 32 because spaces are implicitly treated as 0s, for example. These may or may not be tackled anytime soon.

I've added a screenshots folder so you can get an idea of the language, but keep in mind it's in flux and older code may be broken with new updates. For example, the power calculator screenshot no longer functions appropriately as the precise behavior of `(` and `)` has been changed.
