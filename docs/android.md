<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Android rules to define an asset group

<a id="android_assets"></a>

## android_assets

<pre>
load("@rules_mobile_assets//mobile_assets:android.bzl", "android_assets")

android_assets(<a href="#android_assets-name">name</a>, <a href="#android_assets-resources">resources</a>)
</pre>

Extracts the necessary metadata from shared_assets and produces the required directory structure for android_{binary, library} resource_files

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="android_assets-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="android_assets-resources"></a>resources |  shared_assets target   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |


