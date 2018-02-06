---
layout: default
---

# Output Filters

## Introduction

Output filters are an optional addition to a lookup, when an output filter is defined, the answer from a lookup is passed to the filter prior to being sent back to the requestor.  This allows for parsing and modification of answers in a lookup in a pluggable way.  Output filters are defined using the `output_filter` method within a `lookup` block.  Several filters are shipped with Jerakia and you can also write your own or community output filter plugins.

## Available filters

* [strsub](/outputfilters/strsub): Walk through the data set and perform a basic string substitution
* [encryption](/outputfilters/encryption): Enable decryption of values in the dataset, depending what type of [encryption provider](/encryption) is being used
* [dig](/outputfilters/dig): Dig into the data structure and return a subset


