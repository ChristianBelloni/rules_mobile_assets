load(":providers.bzl", "SharedAssetProvider", "ImageResourceProvider", "ColorProvider", "ColorResourceProvider")

def _shared_assets_impl(ctx):
    return SharedAssetProvider(
        app_icon = ctx.attr.app_icon,
        icons = ctx.attr.icons,
        images = ctx.attr.images,
        colors = ctx.attr.colors,
    )


shared_assets = rule(
    implementation = _shared_assets_impl,
    attrs = {
        "app_icon": attr.label(allow_single_file = True, mandatory = True),
        "icons": attr.label_list(allow_files = True),
        "images": attr.label_list(allow_files = True, providers= [ImageResourceProvider]),
        "colors": attr.label_list()
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

def _color_resource_impl(ctx):
    base = ColorProvider(
            alpha = ctx.attr.alpha,
            red = ctx.attr.red,
            green = ctx.attr.green,
            blue = ctx.attr.blue,
    )
    dark = base
    if ctx.attr.dark_alpha != None and ctx.attr.dark_red != None and ctx.attr.dark_green != None and ctx.attr.dark_blue != None:
        dark = ColorProvider(
            alpha = ctx.attr.dark_alpha,
            red = ctx.attr.dark_red,
            green = ctx.attr.dark_green,
            blue = ctx.attr.dark_blue,
        )
    return ColorResourceProvider(
        name = ctx.attr.name,
        base = ColorProvider(
            alpha = ctx.attr.alpha,
            red = ctx.attr.red,
            green = ctx.attr.green,
            blue = ctx.attr.blue,
        ),
        dark = dark,
    )

color_resource = rule(
    implementation = _color_resource_impl,
    attrs = {
        "alpha": attr.int(mandatory = True),
        "red": attr.int(mandatory = True),
        "green": attr.int(mandatory = True),
        "blue": attr.int(mandatory = True),
        "dark_alpha": attr.int(mandatory = True),
        "dark_red": attr.int(mandatory = True),
        "dark_green": attr.int(mandatory = True),
        "dark_blue": attr.int(mandatory = True),
    },
)
