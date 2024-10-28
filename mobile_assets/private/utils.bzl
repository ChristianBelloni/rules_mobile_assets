load(":providers.bzl", "ColorResourceProvider")

def _define_colors(ctx):
  return []

define_colors = rule(
  implementation = _define_colors
)
