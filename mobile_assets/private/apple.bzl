load(":providers.bzl", "SharedAssetProvider", "ImageResourceProvider", "ColorResourceProvider", "ColorProvider", "LocalizationResourceProvider", "LocalizationProvider")
load("@aspect_bazel_lib//lib:strings.bzl", "hex")

def generate_images(ctx, images, common_directory):
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
    
def generate_colors(ctx, colors, common_directory):
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

def _hex(color):
    str = hex(color).replace("0x", "")
    if len(str) != 2:
        return "0x0{}".format(str)
    else:
        return "0x{}".format(str)

def _generate_color(ctx, color, common_directory):
    name = color.name

    _color = color
    color = _color.base[ColorProvider]

    base_alpha = "{}".format(color.alpha)
    base_red = _hex(color.red)
    base_green = _hex(color.green)
    base_blue = _hex(color.blue)
    
    
    color = _color.base[ColorProvider]
    if _color.dark != None:
        color = _color.dark[ColorProvider]

    dark_alpha = "{}".format(color.alpha)
    dark_red = _hex(color.red)
    dark_green = _hex(color.green)
    dark_blue = _hex(color.blue)

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



KNOWN_KEYS = [
    "NSCameraUsageDescription",
    "NSMicrophoneUsageDescription",
    "NSPhotoLibraryUsageDescription",
    "NSAppleMusicUsageDescription",
]

def _acc_lang(ctx, strings, common_directory, lang):
    out_file = ctx.actions.declare_file("{}/{}.lproj/Localizable.strings".format(common_directory, lang))
    out_file_plist = ctx.actions.declare_file("{}/{}.lproj/InfoPlist.strings".format(common_directory, lang))
    format = ""
    format_plist = ""
    for vals in strings.localizations:
        vals = vals[LocalizationResourceProvider]
        val = vals.values[lang]
        key = vals.key
        if key in KNOWN_KEYS:
            format_plist += "\"{}\" = \"{}\";\n".format(key, val)
        else:
            format += "\"{}\" = \"{}\";\n".format(key, val)

    ctx.actions.write(output = out_file, content = format)
    ctx.actions.write(output = out_file_plist, content = format_plist)
    return [out_file, out_file_plist]

def generate_strings(ctx, strings, common_directory):
    strings = strings[LocalizationProvider]
    first = strings.localizations[0]
    first = first[LocalizationResourceProvider]
    langs = first.values.keys()
    files = []
    for lang in langs:
        files += _acc_lang(ctx, strings, common_directory, lang)
    return files


def generate_other(ctx, other):
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

PLIST_TEMPLATE = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
{CONTENT}</dict>
</plist>
"""

PLIST_KEY_TEMPLATE = """    <key>{KEY}</key>
    <string>{VALUE}</string>
"""

def _additional_plist_impl(ctx):
    resources = ctx.attr.resources[SharedAssetProvider]
    strings = resources.strings[LocalizationProvider]
    lang = strings.base_language
    format = ""
    for pair in strings.localizations:
        pair = pair[LocalizationResourceProvider]
        key = pair.key
        value = pair.values[lang]

        if key in KNOWN_KEYS:
            format += PLIST_KEY_TEMPLATE.replace("{KEY}", key).replace("{VALUE}", value)

    out = ctx.actions.declare_file("Info_%s.plist" % ctx.attr.name)
    format = PLIST_TEMPLATE.replace("{CONTENT}", format)
    ctx.actions.write(output = out, content = format)

    return DefaultInfo(files = depset([out]))


additional_plist = rule(
    implementation = _additional_plist_impl,
    attrs = {
        "resources": attr.label(mandatory = True, providers = [SharedAssetProvider])
    }
)
