# premaketools

Poorly written premake5 utility scripts.

## project.lua

Support for my common project structure:

```txt
build/
  obj/
  bin/
src/
  project1/
    include/
    src/
  project2/
    include/
    src/
premake5.lua
```

Automatically configures projects & dependencies.

```lua
require "premaketools/project"

workspace "sample"
  executable "project1"

  executable "project2"
    uses { "project1" } -- Shorthand for both `includes` and `links`
```

Also includes release, debug and test configurations.

## testing.lua

GTest/GMock unit tests and gcov/lcov coverage reports.

Simple test without coverage:

```lua
workspace "sample"
  executable "project1"
    testable {} -- Allows test configuration for this project

  test "project1_test"
    uses { "project1" }
```

Simple test with coverage:

```lua
workspace "sample"
  executable "project1"
    testable {
      collectcoverage = true
    }

  test "project1_test"
    testconfig {
      -- Use coverage data
      usecoverage = true,
      -- Run tests and generate coverage report
      -- Uses coverage data from all projects
      generatecoveragereport = true
    }

    uses { "project1" }
```

Dedicated coverage report for finer configuration:

```lua
workspace "sample"
  executable "project1"
    testable {
      collectcoverage = true
    }

  test "project1_test"
    testconfig {
      usecoverage = true,
      autorun = true -- Run tests to collect coverage data
    }

    uses { "project1" }

  coveragereport "project1_report" {
    -- All tests and projects to collect coverage from
    "project1_test",
    "project1"
  }
```

## presets.lua

Utility configuration presets.

```lua
workspace "sample"

  presets { "strict" } -- Turns on extra warnings and makes them fatal
```

Available presets:

* `strict` - Extra fatal warnings
* `school21` - `string` + C11/C++17 standards

## external.lua

External library configuration for common project structure.

Assumes that external libs are placed in the `lib/` directory:

```txt
src/
  ...
libs/
  lib1/
    ...
  lib2/
    ...
premake5.lua
```

Example:

```lua
workspace "sample"

  -- Defines an external library by it's directory name (lib/imguiwrap)
  externallibrary "imguiwrap" {
    buildcommands = { "cmake . && make" }, -- Build script
    cleancommands = { "make clean" }, -- Clean script
    exports = {
      -- Library exports
      -- Can be applied to other projects with `includes`, `links` and `uses`
      includedirs = { "lib/imguiwrap/src", "lib/imguiwrap/vendor/imgui/src" },
      links = { "lib/imguiwrap/src/imguiwrap", "lib/imguiwrap/vendor/imgui/imgui", "lib/imguiwrap/vendor/glfw/src/glfw3" }
    }
  }

  guiexecutable "project1"
    uses { "imguiwrap" }
```
