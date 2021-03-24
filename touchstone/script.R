timer(
  expr_before_benchmark = c("print(4)"),
  expr1 = "tail(mtcars)",
  n = 2
)

timer(
  expr_before_benchmark = c("print(4)"),
  expr2 = "head(mtcars)",
  n = 2
)

touchstone::benchmarks_analyse()
