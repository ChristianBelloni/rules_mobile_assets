load(":providers.bzl", "SharedAssetProvider")

COMMON_ATTRS = {
    "resources": attr.label(doc = "shared_assets target", mandatory = True, providers = [SharedAssetProvider]),
    "_resizer": attr.label(default = "@rules_mobile_assets//tools/resizer", executable = True, cfg = "exec"),
}
