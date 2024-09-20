<!-- Generated with Stardoc: http://skydoc.bazel.build -->

MacOS rules to define an asset group

<a id="macos_assets"></a>

## macos_assets

<pre>
load("@rules_mobile_assets//mobile_assets:macos.bzl", "macos_assets")

macos_assets(<a href="#macos_assets-name">name</a>, <a href="#macos_assets-resources">resources</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="macos_assets-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="macos_assets-resources"></a>resources |  shared_assets target   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


