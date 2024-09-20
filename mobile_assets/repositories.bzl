"""
rules_mobile_assets dependencies
"""

load("//3rdparty/crates:defs.bzl", "crate_repositories")

def rules_mobile_assets_dependencies():
    """Load rules_mobile_assets's dependencies"""

    crate_repositories()
