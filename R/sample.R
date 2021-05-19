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

install_use_push <- function() {
  if (nrow(gert::git_status()) > 0) {
    rlang::abort("must have clean git dir to start process")
  }
  remotes::install_github("lorenzwalthert/touchstone")
  fs::file_delete(
    fs::dir_ls(".github/workflows/", regexp = "(touchstone|cancel).*\\.yaml")
  )
  touchstone::use_touchstone()
  gert::git_commit_all("use latest scripts")
  gert::git_push()
}
