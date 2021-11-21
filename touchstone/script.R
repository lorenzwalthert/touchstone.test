# local testing Sys.setenv(GITHUB_BASE_REF = "master", GITHUB_HEAD_REF = "test")
library(touchstone)

refs_install()

benchmark_run_ref(
  expr1 = touchstone.test::wait_long_for_head(4),
  n = 3
)

benchmark_run_ref(
  expr2 = Sys.sleep(1),
  n = 3
)

benchmarks_analyze()

bm_base <- benchmark_read("expr1", touchstone:::ref_get_or_fail("GITHUB_BASE_REF"))
bm_head <- benchmark_read("expr1", touchstone:::ref_get_or_fail("GITHUB_HEAD_REF"))

if (3 * mean(bm_base$elapsed) > mean(bm_head$elapsed)) {
  rlang::abort(paste0(
    "running benchmarks on head should be around 4 times slower.",
    "They are not even 3 times slower. Something is suspicious."
  ))
}
