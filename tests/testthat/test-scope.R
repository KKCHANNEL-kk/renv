context("Scope")

test_that(".libPaths() scoping works as expected", {

  libpaths <- .libPaths()

  local({
    dir <- normalizePath(tempdir(), winslash = "/")
    renv_scope_libpaths(dir)
    expect_true(.libPaths()[1] == dir)
  })

  expect_true(.libPaths()[1] == libpaths[1])

})

test_that("options() scoping works as expected", {

  opts <- list(
    download.file.method = "curl",
    download.file.extra  = NULL
  )

  old <- options("download.file.method", "download.file.extra")
  local({
    do.call(renv_scope_options, opts)
    expect_equal(opts, options("download.file.method", "download.file.extra"))
  })

  expect_equal(old, options("download.file.method", "download.file.extra"))

})

test_that("environment variable scoping works as expected", {

  Sys.unsetenv("A")
  Sys.setenv(B = "0")

  local({
    renv_scope_envvars(A = "1")
    expect_identical(Sys.getenv("A"), "1")
  })
  expect_identical(Sys.getenv("A", unset = NA), NA_character_)

  local({
    renv_scope_envvars(A = "1", B = "2")
    expect_identical(Sys.getenv("A"), "1")
    expect_identical(Sys.getenv("B"), "2")
  })

  expect_identical(Sys.getenv("B"), "0")
  expect_identical(Sys.getenv("A", unset = NA), NA_character_)

})