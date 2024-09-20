<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rules to define a shared assets group

<a id="color_asset"></a>

## color_asset

<pre>
load("@rules_mobile_assets//mobile_assets:defs.bzl", "color_asset")

color_asset(<a href="#color_asset-name">name</a>, <a href="#color_asset-alpha">alpha</a>, <a href="#color_asset-blue">blue</a>, <a href="#color_asset-green">green</a>, <a href="#color_asset-red">red</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="color_asset-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="color_asset-alpha"></a>alpha |  -   | Integer | required |  |
| <a id="color_asset-blue"></a>blue |  -   | Integer | required |  |
| <a id="color_asset-green"></a>green |  -   | Integer | required |  |
| <a id="color_asset-red"></a>red |  -   | Integer | required |  |


<a id="color_resource"></a>

## color_resource

<pre>
load("@rules_mobile_assets//mobile_assets:defs.bzl", "color_resource")

color_resource(<a href="#color_resource-name">name</a>, <a href="#color_resource-base_color">base_color</a>, <a href="#color_resource-dark_theme">dark_theme</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="color_resource-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="color_resource-base_color"></a>base_color |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="color_resource-dark_theme"></a>dark_theme |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |


<a id="image_resource"></a>

## image_resource

<pre>
load("@rules_mobile_assets//mobile_assets:defs.bzl", "image_resource")

image_resource(<a href="#image_resource-name">name</a>, <a href="#image_resource-base_image">base_image</a>, <a href="#image_resource-dark_theme">dark_theme</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="image_resource-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="image_resource-base_image"></a>base_image |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="image_resource-dark_theme"></a>dark_theme |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |


<a id="shared_assets"></a>

## shared_assets

<pre>
load("@rules_mobile_assets//mobile_assets:defs.bzl", "shared_assets")

shared_assets(<a href="#shared_assets-name">name</a>, <a href="#shared_assets-app_icon">app_icon</a>, <a href="#shared_assets-colors">colors</a>, <a href="#shared_assets-images">images</a>, <a href="#shared_assets-others">others</a>, <a href="#shared_assets-strings">strings</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="shared_assets-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="shared_assets-app_icon"></a>app_icon |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="shared_assets-colors"></a>colors |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="shared_assets-images"></a>images |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="shared_assets-others"></a>others |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="shared_assets-strings"></a>strings |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |


<a id="string_collection"></a>

## string_collection

<pre>
load("@rules_mobile_assets//mobile_assets:defs.bzl", "string_collection")

string_collection(<a href="#string_collection-name">name</a>, <a href="#string_collection-base_language">base_language</a>, <a href="#string_collection-localizations">localizations</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="string_collection-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="string_collection-base_language"></a>base_language |  -   | String | optional |  `"en"`  |
| <a id="string_collection-localizations"></a>localizations |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |


<a id="string_resource"></a>

## string_resource

<pre>
load("@rules_mobile_assets//mobile_assets:defs.bzl", "string_resource")

string_resource(<a href="#string_resource-name">name</a>, <a href="#string_resource-values">values</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="string_resource-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="string_resource-values"></a>values |  -   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | required |  |


