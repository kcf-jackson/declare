#' Source file with type annotation
source_addin <- function() {
  print("Active document sourced.")
  temp_file <- tempfile()
  writeLines(rstudioapi::getSourceEditorContext()$contents, temp_file)
  source_with_type_annotation(fpath = temp_file, local = FALSE, show_order = F)
}
