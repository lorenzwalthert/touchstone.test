library(touchstone)

refs_install()

benchmark_run_ref(
  expr_before_benchmark = c("print(4)"),
  expr1 = "tail(mtcars)",
  n = 3
)

benchmark_run_ref(
  expr_before_benchmark = c("print(4)"),
  expr2 = "head(mtcars)",
  n = 3
)

benchmarks_analyze()
