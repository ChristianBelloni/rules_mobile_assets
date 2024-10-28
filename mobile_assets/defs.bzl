"""
Rules to define a shared assets group
"""

load("//mobile_assets/private:defs.bzl", _color_asset = "color_asset", _color_resource = "color_resource", _image_resource = "image_resource", _shared_assets = "shared_assets", _string_collection = "string_collection", _string_resource = "string_resource")

load("//mobile_assets/private:utils.bzl", _define_colors = "define_colors")

image_resource = _image_resource
shared_assets = _shared_assets
color_resource = _color_resource
color_asset = _color_asset
string_resource = _string_resource
string_collection = _string_collection
define_colors = _define_colors
