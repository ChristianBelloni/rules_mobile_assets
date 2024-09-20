load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
load("@rules_rust//rust:repositories.bzl", "rules_rust_dependencies", "rust_register_toolchains")
load("//3rdparty/crates:defs.bzl", "crate_repositories")

def rules_mobile_assets_setup():
    bazel_skylib_workspace()
    rules_rust_dependencies()

    rust_register_toolchains()
    crate_repositories()
