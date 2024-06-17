
load("@build_bazel_rules_apple//apple:resources.bzl", "apple_resource_group")
load(":providers.bzl", "SharedAssetProvider", "ImageResourceProvider", "ColorResourceProvider", "ColorProvider", "LocalizationResourceProvider", "LocalizationProvider")
load(":apple.bzl", "generate_images", "generate_colors", "generate_strings", "generate_other")

def _macos_assets_impl(ctx):
    resources = ctx.attr.resources[SharedAssetProvider]
    resource_path = "%s/Resources.xcassets" % ctx.attr.name
    root_contents = ctx.actions.declare_file("%s/Contents.json" % resource_path)

    ctx.actions.write(output = root_contents, content = EMPTY_CONTENTS)

    icon = _generate_macos_app_icon(ctx, resources.app_icon, resource_path)

    images = generate_images(ctx, resources.images, resource_path)

    colors = generate_colors(ctx, resources.colors, resource_path)
    
    strings = generate_strings(ctx, resources.strings, "%s/Localizations" % ctx.attr.name)
    others = []
    if resources.others != None:
        for dep in resources.others:
            others.append(generate_other(ctx, dep))
    
    return DefaultInfo(
        files = depset(images + icon + [root_contents] + colors + strings + others),
    )

macos_assets = rule(
    implementation = _macos_assets_impl,
    attrs = {
        "resources": attr.label(mandatory = True, providers = [SharedAssetProvider])
    },
)

EMPTY_CONTENTS = """
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""

APP_ICON_CONTENTS = """
{
  "images" : [
    {
      "filename" : "16.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "filename" : "16x2.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "filename" : "32.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "filename" : "32x2.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "filename" : "128.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "filename" : "128x2.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "filename" : "256.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "filename" : "256x2.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "filename" : "512.png",
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
      "filename" : "512x2.png",
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "512x512"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}

"""

SIZES = {
    "16.png": "16x16",
    "16x2.png": "16x16",
    "32.png": "32x32",
    "32x2.png": "32x32",
    "128.png": "128x128",
    "128x2.png": "128x128",
    "256.png": "256x256",
    "256x2.png": "256x256",
    "512.png": "512x512",
    "512x2.png": "512x512"
}

def _generate_macos_app_icon(ctx, app_icon, common_directory):
    base_directory = "%s/AppIcon.appiconset" % common_directory

    contents_json = ctx.actions.declare_file("%s/Contents.json" % base_directory)

    ctx.actions.write(output = contents_json, content = APP_ICON_CONTENTS)

    icons = []
    icons.append(contents_json)
    
    for f in SIZES:
        filename = f
        size = SIZES[f].split("x")[0]


        icon = ctx.actions.declare_file("{}/{}".format(base_directory, filename))
        
        cmd = "magick {app_icon} -alpha off -resize {size} -background none {out}".format(
            app_icon = app_icon[DefaultInfo].files.to_list()[0].path, 
            size = size,
            out = icon.path
        )

        ctx.actions.run_shell(
            outputs = [icon], 
            command = cmd, 
            inputs = app_icon.files,
            mnemonic = "GenerateIcon",
            use_default_shell_env = True,
        )
        icons.append(icon)

    return icons


