-- Gtest/Gcov testing & coverage support

-- Marks project as testable
testable = function(options)
  tags { "testing/testable" }

  if options.collectcoverage then
    tags { "testing/collect-coverage" }
  end
end

-- Defines a test project
test = function(name)
  executable(name)
    tags { "testing/test" }

    links { "gtest", "gmock" }
end


coveragereport = function(name)
  project(name)
    kind "Makefile"

    tags { "testing/coveragereport" }

    -- TODO Fix "%{cfg.objdir}/.."
    buildcommands {
      "lcov -c -d %{cfg.objdir}/.. -o %{cfg.buildtarget.directory}/%{cfg.buildtarget.basename}.info",
      "genhtml %{cfg.buildtarget.directory}/%{cfg.buildtarget.basename}.info -o %{cfg.buildtarget.directory}/%{cfg.buildtarget.basename}"
    }

    cleancommands {
      "rm -rf %{cfg.buildtarget.directory}/%{cfg.buildtarget.basename}.info",
      "rm -rf %{cfg.buildtarget.directory}/%{cfg.buildtarget.basename}"
    }
end

-- Sets test configuration tags
testconfig = function(options)
  if options.usecoverage then
    tags { "testing/use-coverage" }
  end

  if options.autorun then
    tags { "testing/autorun" }
  end

  if options.generatecoveragereport then
    tags { "testing/generate-coverage-report" }
  end
end

-- Remove test configuration from all projects not marked as testable or test
filter { "tags:scope/project", "tags:not testing/testable", "tags:not testing/test", "tags:not testing/coveragereport" }
  removeconfigurations "test"

-- Remove all non test configurations from test and report projects
filter { "tags:testing/test or testing/coveragereport" }
  removeconfigurations "*"
  configurations { "test" }

-- Make all projects with collect-coverage tag collect coverage data
filter { "test", "tags:testing/collect-coverage" }
  buildoptions { "-fprofile-arcs", "-ftest-coverage" }
  linkoptions { "--coverage" }
  links { "gcov" }

-- Make all projects with use-coverage link coverage utilities but not collect their own coverage
filter { "test", "tags:testing/use-coverage" }
  linkoptions { "--coverage" }
  links { "gcov" }

-- Make all projects with generate-coverage-report tag generate coverage reports after build
-- NOTE: Works bad when there are multple tests
filter { "test", "tags:testing/generate-coverage-report" }
  postbuildcommands {
    "lcov -d %{cfg.objdir}/.. --zerocounters",
    "%{cfg.buildtarget.abspath}",
    "lcov -c -d %{cfg.objdir}/.. -o %{cfg.buildtarget.directory}/%{cfg.buildtarget.basename}_coverage.info",
    "genhtml %{cfg.buildtarget.directory}/%{cfg.buildtarget.basename}_coverage.info -o %{cfg.buildtarget.directory}/%{cfg.buildtarget.basename}_coverage_report"
  }

filter { "tags:testing/autorun", "tags:not testing/generate-coverage-report" }
  postbuildcommands {
    "%{cfg.buildtarget.abspath}"
  }
