load("//3rdparty/crates:defs.bzl", "crate_repositories")

def _internal_deps_impl(_):
    crate_repositories()

i = module_extension(
    implementation = _internal_deps_impl,
)
