workspace(name = "rules_mobile_assets")

load("@rules_mobile_assets//mobile_assets:repositories.bzl", "rules_mobile_assets_dependencies")

rules_mobile_assets_dependencies()

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

local_repository(
    name = "rules_homebrew",
    path = "/Users/christianbelloni/work/oss/rules_homebrew",
)

# git_repository(
#     name = "rules_homebrew",
#     branch = "master",
#     remote = "https://github.com/tmc/rules_homebrew.git",
# )

load("@rules_homebrew//rules:def.bzl", "homebrew_repository")

homebrew_repository(
    name = "brew",
    homebrew_core_commit = "86b2565d8ebf77b1c685e530b051ae1df0aefac0",
    homebrew_core_sha256 = "b766ebf16cbad6f8ca4af74d71be73ea263f873d9d3c43cd88e9ec76d624553c",
    homebrew_sha256 = "9cc234bda4e3a66d9bf1e2d0fca177ace321b6ed473b16d09aa9e48a52d0cf5c",
    homebrew_tag = "4.3.23",
    packages = ["imagemagick"],
    verbose = True,
)
