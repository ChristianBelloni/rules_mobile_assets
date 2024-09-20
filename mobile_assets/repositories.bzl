"""
rules_mobile_assets dependencies
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_mobile_assets_dependencies():
    """Load rules_mobile_assets's dependencies"""
    maybe(
        http_archive,
        name = "platforms",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/platforms/releases/download/0.0.10/platforms-0.0.10.tar.gz",
            "https://github.com/bazelbuild/platforms/releases/download/0.0.10/platforms-0.0.10.tar.gz",
        ],
        sha256 = "218efe8ee736d26a3572663b374a253c012b716d8af0c07e842e82f238a0a7ee",
    )
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "bc283cdfcd526a52c3201279cda4bc298652efa898b10b4db0837dc51652756f",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.1/bazel-skylib-1.7.1.tar.gz",
        ],
    )
    maybe(
        http_archive,
        name = "aspect_bazel_lib",
        sha256 = "da67c6a785cdc10faf960a22c44501fe6be357a6ebd2bd6101560f9c2a9e06b3",
        strip_prefix = "bazel-lib-2.9.0",
        url = "https://github.com/bazel-contrib/bazel-lib/releases/download/v2.9.0/bazel-lib-v2.9.0.tar.gz",
    )
    maybe(
        http_archive,
        name = "rules_rust",
        integrity = "sha256-BCrPtzRpstGEj+FI2Bw0IsYepHqeGQDxyew29R6OcZM=",
        urls = ["https://github.com/bazelbuild/rules_rust/releases/download/0.51.0/rules_rust-v0.51.0.tar.gz"],
    )
