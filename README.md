# rules_mobile_assets

Rules to streamline asset management when targeting multiple platforms

## Overview
 - Declarative api to define colors, localizations and images
 - iOS/MacOS resource bundling
 - Android resource bundling

## Planned features
 - [ ] Custom machine-readable format to define assets
 - [ ] Repository rule to generate assets definition
 - [ ] Codegen to define swift and kotlin constants

## Installation

### Using WORKSPACE

Paste this snippet into your `WORKSPACE.bazel` file:

```starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "rules_mobile_assets",
    sha256 = "f34926f948ec99ebb1e9b0081db62c0805b4de9a6d8c60abbf402c411e1da5c2",
    strip_prefix = "rules_mobile_assets-0.0.2",
    url = "https://github.com/ChristianBelloni/rules_mobile_assets/releases/download/0.0.2/rules_mobile_assets-0.0.2.tar.gz",
)

load("@rules_mobile_assets//mobile_assets:repositories.bzl", "rules_mobile_assets_dependencies")

rules_mobile_assets_dependencies()

load("@rules_mobile_assets//mobile_assets:setup.bzl", "rules_mobile_assets_setup")

rules_mobile_assets_setup()
```

## Usage

### Assets definition

BUILD.bazel

```starlark
load(
    "@rules_mobile_assets//mobile_assets:defs.bzl",
    "color_asset",
    "color_resource",
    "image_resource",
    "shared_assets",
    "string_collection",
    "string_resource",
)

# Define an image
image_resource(
    name = "example_image",
    base_image = "images/my_image.png",
    # Optional dark theme image
    dark_theme = "images/my_dark_theme_image.png",
)

# Define a color asset
color_asset(
    name = "example_color",
    alpha = 255,
    red = 150,
    green = 20,
    blue = 100,
)
# Optional dark theme color
color_asset(
    name = "example_color_dark",
    ...
)

# Bundle the color resources together
color_resource(
    name = "example_color",
    base_color = "example_color",
    dark_theme = "example_color_dark",
)

# Define a localized string
string_resource(
    name = "example_string",
    values = {
        "it": "la mia stringa",
        "en": "My string",
        ...
    }
)

# Bundle the localized strings together
string_collection(
    name = "locales",
    base_language = "en",
    localizations = ["example_string", ...]
)

# Bundle all the resources together
shared_assets(
    name = "shared_assets",
    app_icon = "icons/my_logo.svg",
    colors = [
        "example_color", 
        ...
    ],
    images = [
        ":example_image",
        ...
    ],
    others = ["images/other.txt"],
    strings = "locales",
    visibility = ["//visibility:public"],
)
```


### iOS usage

my_ios_app/BUILD

```
load("@rules_mobile_assets//mobile_assets:ios.bzl", "ios_assets")
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")

ios_assets(
    name = "ios_assets",
    resources = "//:shared_assets",
)

ios_application(
    name = "my_application",
    resources = [:ios_assets],
    ...,
)
```
#### Plist support


When one of the known keys is defined as a localization you can use additional_plist to localize the final Info.plist file

```
KNOWN_KEYS = [
    "NSCameraUsageDescription",
    "NSMicrophoneUsageDescription",
    "NSPhotoLibraryUsageDescription",
    "NSAppleMusicUsageDescription",
]
```

```
load("@rules_mobile_assets//mobile_assets:apple.bzl", "additional_plist")
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")

additional_plist(
    name = "localized_info_plist",
    resources = "<shared_assets_target>"
)

ios_application(
    name = "my_application",
    infoplists = ["MyInfo.plist", ":localized_info_plist"]
)
```

### Android usage

my_android_app/BUILD

```
load("@rules_mobile_assets//mobile_assets:android.bzl", "android_assets")

android_assets(
    name = "android_assets",
    resources = "//:shared_assets",
)

android_binary(
    name = "my_app",
    resource_files = ":android_assets",
    ...,
)
```
