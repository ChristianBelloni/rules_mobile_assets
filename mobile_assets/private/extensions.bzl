load("@rules_mobile_assets//mobile_assets:repositories.bzl", "rules_mobile_assets_dependencies")

def _internal_deps_impl(ctx):
    rules_mobile_assets_dependencies()

i = module_extension(
    implementation = _internal_deps_impl,
)
