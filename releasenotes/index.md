---
layout: minimal
---

# Jerakia Release log

## 0.5

### 0.5.0

* [Issue #9](https://github.com/crayfishx/jerakia/issues/9) : Added [data schema](/schema/) feature
* [Issue #12](https://github.com/crayfishx/jerakia/issues/12): Added deep merge capability
* [Issue #35](https://github.com/crayfishx/jerakia/issues/35): Bugfix: reverse priority given to hash merges
* [Issue #33](https://github.com/crayfishx/jerakia/issues/33): Use default values for jerakia.yaml options so file is not mandatory
* [Issue #36](https://github.com/crayfishx/jerakia/issues/36): Plugins now support an `autorun` method to run upon use without needing to call plugin methods
* [Issue #37](https://github.com/crayfishx/jerakia/issues/37): Configuration can now be passed to Jerakia plugins from `jerakia.yaml` in a `plugins` hash.
* Misc: `plugin.hiera.rewrite_lookup` is now deprecated (currently warns), this feature is now run using the autorun method
* Misc: File data source now supports a JSON file handler

