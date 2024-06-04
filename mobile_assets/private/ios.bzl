load("@build_bazel_rules_apple//apple:resources.bzl", "apple_resource_group")
load(":providers.bzl", "SharedAssetProvider", "ImageResourceProvider", "ColorResourceProvider", "ColorProvider", "LocalizationResourceProvider", "LocalizationProvider")
load("@aspect_bazel_lib//lib:strings.bzl", "hex")

def _ios_assets_impl(ctx):
    resources = ctx.attr.resources[SharedAssetProvider]
    resource_path = "%s/Resources.xcassets" % ctx.attr.name
    root_contents = ctx.actions.declare_file("%s/Contents.json" % resource_path)

    ctx.actions.write(output = root_contents, content = EMPTY_CONTENTS)

    icon = _generate_ios_app_icon(ctx, resources.app_icon, resource_path)

    images = _generate_images(ctx, resources.images, resource_path)

    colors = _generate_colors(ctx, resources.colors, resource_path)
    
    strings = _generate_strings(ctx, resources.strings, "%s/Localizations" % ctx.attr.name)
    others = []
    if resources.others != None:
        for dep in resources.others:
            others.append(_generate_other(ctx, dep))
    
    return DefaultInfo(
        files = depset(images + icon + [root_contents] + colors + [strings] + others),
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
    
    cmd = "rsvg-convert {app_icon} -w 1024 -h 1024 {out}".format(
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


def _generate_images(ctx, images, common_directory):
    ret = []
    for image in images:
        values = _generate_image(ctx, image[ImageResourceProvider], common_directory)
        for v in values:
            ret.append(v)
    return ret

IMAGE_CONTENTS = """
{
  "images" : [
    {
      "filename" : "base.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "filename" : "dark.png",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "idiom" : "universal",
      "scale" : "3x"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "idiom" : "universal",
      "scale" : "3x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}

"""

def _generate_image(ctx, image, common_directory):
    base_image = image.base_image[DefaultInfo].files.to_list()[0]
    dark_image = base_image
    if image.dark_theme != None:
        dark_image = image.dark_theme[DefaultInfo].files.to_list()[0]
    
    base_image_name = base_image.basename.split(".")[0]

    resource_path = "{}/{}.imageset".format(common_directory, base_image_name)

    base_image_dest = ctx.actions.declare_file("{}/base.png".format(resource_path))

    cmd = "cp {image} {image_destination}".format(
        image = base_image.path,
        image_destination = base_image_dest.path
    )

    ctx.actions.run_shell(
        outputs = [base_image_dest],
        command = cmd,
        inputs = [base_image],
    )

    dark_image_dest = ctx.actions.declare_file("{}/dark.png".format(resource_path))

    cmd = "cp {image} {image_destination}".format(
        image = dark_image.path,
        image_destination = dark_image_dest.path,
    )

    ctx.actions.run_shell(
        outputs = [dark_image_dest],
        command = cmd,
        inputs = [dark_image],
    )

    contents_json = ctx.actions.declare_file("{}/Contents.json".format(resource_path))
    ctx.actions.write(output = contents_json, content = IMAGE_CONTENTS)

    return [base_image_dest, dark_image_dest, contents_json]
    
def _generate_colors(ctx, colors, common_directory):
    ret = []
    for color in colors:
        values = _generate_color(ctx, color[ColorResourceProvider], common_directory)
        for v in values:
            ret.append(v)
    return ret


COLOR_CONTENTS = """
{
  "colors" : [
    {
      "color" : {
        "color-space" : "display-p3",
        "components" : {
          "alpha" : "{ALPHA}",
          "blue" : "{BLUE}",
          "green" : "{GREEN}",
          "red" : "{RED}"
        }
      },
      "idiom" : "universal"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "color" : {
        "color-space" : "display-p3",
        "components" : {
          "alpha" : "{D_ALPHA}",
          "blue" : "{D_BLUE}",
          "green" : "{D_GREEN}",
          "red" : "{D_RED}"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}

"""

def _generate_color(ctx, color, common_directory):
    name = color.name

    _color = color
    color = _color.base[ColorProvider]

    base_alpha = "{}".format(color.alpha)
    base_red = hex(color.red)
    base_green = hex(color.green)
    base_blue = hex(color.blue)

    color = _color.dark[ColorProvider]

    dark_alpha = "{}".format(color.alpha)
    dark_red = hex(color.red)
    dark_green = hex(color.green)
    dark_blue = hex(color.blue)

    contents_json = ctx.actions.declare_file("{}/{}.colorset/Contents.json".format(common_directory, name))
    
    val = COLOR_CONTENTS.replace("{ALPHA}", base_alpha)
    val = val.replace("{RED}", base_red)
    val = val.replace("{GREEN}", base_green)
    val = val.replace("{BLUE}", base_blue)
    val = val.replace("{D_ALPHA}", dark_alpha)
    val = val.replace("{D_RED}", dark_red)
    val = val.replace("{D_GREEN}", dark_green)
    val = val.replace("{D_BLUE}", dark_blue)

    ctx.actions.write(output = contents_json, content = val)
    return [contents_json]

def _generate_strings(ctx, strings, common_directory):
    strings = strings[LocalizationProvider]
    localization_format = """{
    "sourceLanguage" : "{SOURCE}",
    "strings" : {
        {LOCALES}
    },
    "version" : "1.0"
}
    """
    localizations = []
    for string in strings.localizations:
        val = _generate_string(string[LocalizationResourceProvider])
        localizations.append(val)

    localizations = ",\n".join(localizations)
    localizations = localization_format.replace("{LOCALES}", localizations).replace("{SOURCE}", strings.base_language)
    out_locales = ctx.actions.declare_file("%s/Localizable.xcstring" % common_directory)
    ctx.actions.write(output = out_locales, content = localizations)
    return out_locales

# "simple_key" : {
#     "comment" : "This is a comment for translators.",
#     "extractionState" : "manual",
#     "localizations" : {
#         "en" : {
#             "stringUnit" : {
#                 "state" : "translated",
#                 "value" : "Default Value"
#             }
#         }
#     }
# }
def _generate_string(string):
    localizations = []

    for lang, val in string.values.items():
        local = """
                "{LANG}" : {
                    "stringUnit" : {
                        "state" : "translated",
                        "value" : "{VAL}"
                    }
                }""".replace("{LANG}", lang)
        local = local.replace("{VAL}", val)
        localizations.append(local)

    current_format = """"{KEY}" : {
            "extractionState" : "manual",
            "localizations" : {{LOCALIZATIONS}
            }
        }""".replace("{KEY}", string.key).replace("{LOCALIZATIONS}", ",".join(localizations))
    

    return current_format

def _generate_other(ctx, other):
    other = other.files.to_list()[0]
    
    other_name = other.basename

    other_dest = ctx.actions.declare_file("{}".format(other_name))

    cmd = "cp {other} {other_destination}".format(
        other = other.path,
        other_destination = other_dest.path
    )

    ctx.actions.run_shell(
        outputs = [other_dest],
        command = cmd,
        inputs = [other],
    )

    return other_dest
