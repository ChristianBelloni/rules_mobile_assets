load("@build_bazel_rules_apple//apple:resources.bzl", "apple_resource_group")
load(":providers.bzl", "SharedAssetProvider", "ImageResourceProvider", "ColorResourceProvider", "ColorProvider", "LocalizationResourceProvider", "LocalizationProvider")
load(":apple.bzl", "generate_images", "generate_colors", "generate_strings", "generate_other")

def _ios_assets_impl(ctx):
    resources = ctx.attr.resources[SharedAssetProvider]
    resource_path = "%s/Resources.xcassets" % ctx.attr.name
    root_contents = ctx.actions.declare_file("%s/Contents.json" % resource_path)

    ctx.actions.write(output = root_contents, content = EMPTY_CONTENTS)

    icon = _generate_ios_app_icon(ctx, resources.app_icon, resource_path)

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

ios_assets = rule(
    implementation = _ios_assets_impl,
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
      "filename" : "universal.png",
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    },
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}

"""

def _generate_ios_app_icon(ctx, app_icon, common_directory):
    base_directory = "%s/AppIcon.appiconset" % common_directory

    contents_json = ctx.actions.declare_file("%s/Contents.json" % base_directory)

    ctx.actions.write(output = contents_json, content = APP_ICON_CONTENTS)

    universal_icon = ctx.actions.declare_file("%s/universal.png" % base_directory)
    
    cmd = "rsvg-convert -w 1024 -h 1024 {app_icon} -b white -o {out}".format(
        app_icon = app_icon[DefaultInfo].files.to_list()[0].path, 
        out = universal_icon.path
    )

    ctx.actions.run_shell(
        outputs = [universal_icon], 
        command = cmd, 
        inputs = app_icon.files,
        mnemonic = "GenerateIcon",
        use_default_shell_env = True,
    )

    return [universal_icon, contents_json]



