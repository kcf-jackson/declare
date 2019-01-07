## R package "declare"

Allows user to add optional type annotation to a function via comments. The package uses a simple mechanism, and it is designed such that the annotation may be "switched on and off" as one pleases. This is an experiment of programming in R with stronger type. 
    
[![Coverage Status](https://img.shields.io/codecov/c/github/<USERNAME>/<REPO>/master.svg)](https://codecov.io/github/<USERNAME>/<REPO>?branch=master)
    
## Usage

### examples.R
```
# Add one to a number
#$ add_one <- declare::type(add_one, x = "numeric")  # names on LHS and RHS must match
add_one <- function(x) { x + 1 }


# Column-bind two rows together
#$ cbind_rows <- declare::type(cbind_rows, r1 = "matrix", r2 = "matrix")
cbind_rows <- function(r1, r2) { cbind(r1, r2) }


# Multiply the first 3 rows of an object by a constant
#$ f <- declare::type(f, y = "numeric")  # partial specification
f <- function(x, y) { x[1:3, ] * y }
```

### main.R
```
declare::source_with_type_annotation("examples.R")
add_one(10)          # Runs fine
add_one(nrow(1:10))  # Expect type error since nrow of a vector returns NULL.


X <- matrix(1:9, 3, 3)
Y <- matrix(1:3, ncol = 3)
cbind_rows(Y, Y)     # Runs fine
cbind_rows(X[1,], Y) # Expect type error since X[1,] is converted to vector implicitly.


x <- matrix(1:9, 3, 3)
x2 <- as.data.frame(x)
k <- 5
f(x, k)     # runs fine
f(x2, k)    # runs fine
f(x2, "A")  # type error
```


## Notes

- An addin named "Source file with type annotation" is provided; it lets you source the active file in RStudio with type annotation. One may consider binding that to the hotkey 'ctrl-t' or 'cmd-t'.

- `declare::type` is just an usual R function call which takes a function and a type specification, and returns a procedure that calls a checker before the function. 

- `source_with_type_annotation` is also a R function call (really, what else can it be ;p) that parses the file and makes sure the type call is evaluated *immediately after* the definition. (This means if you combine `examples.R` and `main.R` above into one file, it will still run fine.)
