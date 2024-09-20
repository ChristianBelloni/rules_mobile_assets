load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_mobile_assets_dependencies():
    maybe(
        http_archive,
        name = "imagemagick",
        build_file = "@rules_mobile_assets//tools/imagemagick:BUILD.bazel",
        integrity = "sha256-gvKtLQ0nhk/Qje1QEfvWRPvbykgT5fe3K/ST5sXR4I0=",
        strip_prefix = "ImageMagick-7.1.1-38",
        urls = ["https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.1.1-38.zip"],
    )
