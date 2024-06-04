load(":providers.bzl", "SharedAssetProvider", "ImageResourceProvider", "ColorProvider", "ColorResourceProvider", "LocalizationResourceProvider", "LocalizationProvider")

def _shared_assets_impl(ctx):
    return SharedAssetProvider(
        app_icon = ctx.attr.app_icon,
        # icons = ctx.attr.icons,
        images = ctx.attr.images,
        strings = ctx.attr.strings,
        colors = ctx.attr.colors,
        others = ctx.attr.others
    )


shared_assets = rule(
    implementation = _shared_assets_impl,
    attrs = {
        "app_icon": attr.label(allow_single_file = True, mandatory = True),
        # "icons": attr.label_list(allow_files = True),
        "images": attr.label_list(allow_files = True, providers= [ImageResourceProvider]),
        "strings": attr.label(),
        "colors": attr.label_list(),
        "others": attr.label_list(allow_files = True)
    },
)

def _image_resource_impl(ctx):
    return ImageResourceProvider(
        base_image = ctx.attr.base_image,
        dark_theme = ctx.attr.dark_theme
    )

image_resource = rule(
    implementation = _image_resource_impl,
    attrs = {
        "base_image": attr.label(mandatory = True, allow_single_file = True),
        "dark_theme": attr.label(allow_single_file = True),
    },
)

def _color_asset_impl(ctx):
    return ColorProvider(
            alpha = ctx.attr.alpha,
            red = ctx.attr.red,
            green = ctx.attr.green,
            blue = ctx.attr.blue,
    )

color_asset = rule(
    implementation = _color_asset_impl,
    attrs = {
        "alpha": attr.int(mandatory = True),
        "red": attr.int(mandatory = True),
        "green": attr.int(mandatory = True),
        "blue": attr.int(mandatory = True),
    }
)

def _color_resource_impl(ctx):
    return ColorResourceProvider(
        name = ctx.attr.name,
        base = ctx.attr.base_color,
        dark = ctx.attr.dark_theme,
    )

color_resource = rule(
    implementation = _color_resource_impl,
    attrs = {
        "base_color": attr.label(mandatory = True),
        "dark_theme": attr.label()
    },
)

def _string_resource(ctx):
    return LocalizationResourceProvider(
        key = ctx.attr.name,
        values = ctx.attr.values
    )

string_resource = rule(
    implementation = _string_resource,
    attrs = {
        "values": attr.string_dict(mandatory = True)
    }
)

def _string_collection_impl(ctx):
    return LocalizationProvider(
        base_language = ctx.attr.base_language,
        localizations = ctx.attr.localizations
    )

string_collection = rule(
    implementation = _string_collection_impl,
    attrs = {
        "base_language": attr.string(default = "en"),
        "localizations": attr.label_list(),
    }
)
