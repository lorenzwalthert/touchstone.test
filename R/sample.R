#' This function brings a big speed improvement for the PR
#' @export
wait_long_for_head <- function(wait) {
  base <- touchstone:::ref_get_or_fail("GITHUB_BASE_REF")
  head <- touchstone:::ref_get_or_fail("GITHUB_HEAD_REF")
  if (gert::git_branch() == head) {
    Sys.sleep(wait)
  } else if (gert::git_branch() == base) {
    Sys.sleep(0)
  } else {
    rlang::abort(
      "Currently branch must be either `GITHUB_BASE_REF` or `GITHUB_HEAD_REF`."
    )
  }
}

# Convenience function to run full testing
install_use_push <- function(ref = "main") {
  if (nrow(gert::git_status()) > 0) {
    rlang::abort("must have clean git dir to start process")
  }
  remotes::install_github(paste0("lorenzwalthert/touchstone@", ref), upgrade = "never")
  fs::file_delete(
    fs::dir_ls(".github/workflows/", regexp = "(touchstone|cancel).*\\.yaml")
  )
  # old version might be loaded
  callr::r(function() touchstone::use_touchstone())
  system2(
    "sed", c(
      "-i", "''", "-e",
      '"s/remotes::install_github(\\\"lorenzwalthert\\/touchstone.*\\\").*/remotes::install_github(\\\"lorenzwalthert\\/touchstone@$R_TOUCHSTONE_TEST_REF\\\")/g"',
      ".github/workflows/touchstone-receive.yaml"
    ),
    env = paste0("R_TOUCHSTONE_TEST_REF=", ref, ";")
  )
  system2("git", c("add", "."))
  system2("git", c("commit", "-m", "'use latest scripts'", "--allow-empty"))
  gert::git_push()
  usethis::ui_done("Pushed new changes")
}
