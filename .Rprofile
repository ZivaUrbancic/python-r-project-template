# Set white background for graphics devices in Jupyter
setHook(
  packageEvent("grDevices", "onLoad"),
  function(...) {
    grDevices::pdf.options(bg = "white")
  }
)
