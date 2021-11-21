#' This function brings a big speed improvement for the PR
#' @export
wait_long_for_head <- function(wait) {
  base <- touchstone:::ref_get_or_fail("GITHUB_BASE_REF")
  head <- touchstone:::ref_get_or_fail("GITHUB_HEAD_REF")
  if (gert::git_branch() == head) {
    print(paste0("on branch ", head, ", sleeping for ", wait, " seconds."))
    Sys.sleep(wait)
  } else if (gert::git_branch() == base) {
    print(paste0("on branch ", base, ", sleeping for ", "0 seconds."))
    Sys.sleep(0)
  } else {
    rlang::abort(
      "Currently branch must be either `GITHUB_BASE_REF` or `GITHUB_HEAD_REF`."
    )
  }
}

#' Convenience function to run full testing
#' @importFrom magrittr %>%
#' @keywords internal
install_use_push <- function(ref = "main") {
  if (nrow(gert::git_status()) > 0) {
    rlang::abort("must have clean git dir to start process")
  }
  remotes::install_github(paste0("lorenzwalthert/touchstone", ref), upgrade = "never")
  fs::file_delete(
    fs::dir_ls(".github/workflows/", regexp = "(touchstone|cancel).*\\.yaml")
  )
  # old version might be loaded
  callr::r(function() touchstone::use_touchstone())
  system2(
    "sed", c(
      "-e",
      '"s/lorenzwalthert\\/touchstone.*/lorenzwalthert\\/touchstone$R_TOUCHSTONE_TEST_REF/g"',
      ".github/workflows/touchstone-receive.yaml"
    ),
    env = paste0("R_TOUCHSTONE_TEST_REF=", ref, ";")
  )
  fs::file_delete(".github/workflows/touchstone-receive.yaml-e")
  system2("git", c("add", "."))
  system2("git", c("commit", "-m", "'use latest scripts'", "--allow-empty"))
  gert::git_push()
  usethis::ui_done("Pushed new changes")
}
