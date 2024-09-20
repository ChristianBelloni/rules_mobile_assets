load("@rules_rust//crate_universe:defs.bzl", "crates_vendor")

package(default_visibility = ["//visibility:public"])

crates_vendor(
    name = "crates_vendor",
    cargo_lockfile = "//tools/resizer:Cargo.lock",
    manifests = ["//tools/resizer:Cargo.toml"],
    mode = "remote",
    # Short for 'crate universe index'. Keep this short to reduce the risk to
    # bump into absolute path length issues on Windows. See:
    # https://github.com/bazelbuild/rules_rust/issues/1120
    # tags = ["manual"],
    repository_name = "ucr",
    vendor_path = "crates",
)
