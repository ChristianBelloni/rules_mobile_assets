load("@rules_rust//crate_universe:defs.bzl", "crates_vendor")

package(default_visibility = ["//visibility:public"])

crates_vendor(
    name = "crates_vendor",
    cargo_lockfile = "//tools/resizer:Cargo.lock",
    manifests = ["//tools/resizer:Cargo.toml"],
    mode = "remote",
    # Short for internal deps
    repository_name = "id",
    vendor_path = "crates",
)
