# choices and loops are the two primary tools of control flow
# if statements and switch() calls are choices that depend on input
# loops (for, while) run code repeatedly with potentially changing options

# basic if statement syntax
# if (condition) true_action
# if (condition) true_action else false_action

grade <- function(x){
  if (x > 90){
    "A"
  }
  else if (x > 80){
    "B"
  }
  else if (x > 50){
    "C"
  }
  else{
    "F"
  }
}

# if returns a value, can be used in assignment
# not recommended for complex conditions that do not fit on a single line
x1 <- if (TRUE) 1 else 2
x2 <- if (FALSE) 1 else 2
c(x1, x2)

# using if statement without else returns NULL if condition is FALSE
greet <- function(name, birthday = FALSE){
  paste0(
    "Hi ", name,
    if (birthday) " and HAPPY BIRTHDAY"
  )
}

greet("Maria", FALSE)
greet("Jaime", TRUE)

# invalid inputs (e.g. missing values) for if condition will generate an error
# argument must be interpretable as logical and cannot have length 0
if ("x") 1
if (logical()) 1
if (NA) 1

# logical vector with length greater than 1 is also invalid
if (c(TRUE, FALSE)) 1

# ifelse() is vectorized if function, handles vectors of logical values
# ifelse(test, yes, no) evaluates test and outputs corresponding values
# resulting output has same length as test vector with values from yes or no
# missing values in test will be propagated into output
x <- 1:10
ifelse(x %% 5 == 0, "XXX", as.character(x))
ifelse(x %% 2 == 0, "even", "odd")

# dplyr::case_when() allows any number of condition-value pairs
dplyr::case_when(
  x %% 35 == 0 ~ "fizz buzz",
  x %% 5 == 0 ~ "fizz",
  x %% 7 == 0 ~ "buzz",
  is.na(x) ~ "???",
  TRUE ~ as.character(x)
)

# switch() allows for more succinct representation of many if-else blocks
x_option <- function(x){
  if (x == "a"){
    "option 1"
  }
  else if (x == "b"){
    "option 2"
  }
  else if (x == "c"){
    "option 3"
  }
  else{
    stop("Invalid `x` value")
  }
}

x_option2 <- function(x){
  switch(x,
    a = "option 1",
    b = "option 2",
    c = "option 3",
    stop("Invalid `x` value")
  )
}

# last component of switch() should return an error
# otherwise mismatched inputs will return NULL
(switch("c", a = 1, b = 2))
