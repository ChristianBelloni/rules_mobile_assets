SharedAssetProvider = provider(doc = "Shared assets info", fields = {
    "app_icon": "App icon",
    "icons": "Icons",
    "images": "Images",
    "strings": "Strings",
    "colors": "Colors",
})

ImageResourceProvider = provider(doc = "Image resource", fields = {
    "base_image": "Base image",
    "dark_theme": "Dark theme image"
})

ColorProvider = provider(doc = "Color definition", fields = {
    "alpha": "color alpha",
    "red": "color red",
    "green": "color green",
    "blue": "color blue",
})

ColorResourceProvider = provider(doc = "Color resource definition", fields = {
    "name": "Color name",
    "base": "Base color",
    "dark": "Dark theme color",
})
