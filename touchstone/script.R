timer <- purrr::partial(touchstone::benchmark_run_ref,
  refs = refs, n = 2
)

timer(
  expr_before_benchmark = c("print(4)"),
  expr1 = "tail(mtcars)"
)

timer(
  expr_before_benchmark = c("print(4)"),
  expr2 = "head(mtcars)"
)

touchstone::benchmarks_analyse()
