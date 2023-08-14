-- Common project structure support

-- Modify default scope properties
_workspace = workspace

workspace = function(name)
  if name == '*' then
    return _workspace(name)
  end

  _workspace(name)
    -- Mark scope type by tags
    tags { "scope/workspace" }

    -- Default workspace setup
    location "build"

    objdir "build/obj"
    targetdir "build/bin"
end

_project = project

project = function(name)
  if name == '*' then
    return _project(name)
  end

  _project(name)
    -- Mark scope type by tags
    tags { "scope/project" }


    -- Default project setup
    filter { "tags:not external" }
      location "%{wks.location}"

      files { "src/%{prj.name}/src/**.cpp" }
      includedirs { "src/%{prj.name}/include" }

  _project(name)
end

-- Project/kind shorthands
staticlibrary = function(name) project(name) kind "StaticLib" end
sharedlibrary = function(name) project(name) kind "SharedLib" end
executable = function(name) project(name) kind "ConsoleApp" end
guiexecutable = function(name) project(name) kind "WindowedApp" end

-- Links projects and adds `links/project` tag
_links = links

links = function(projects)
  for _, project in pairs(projects) do
    _links { project }
    tags { "links/" .. project }
  end
end

-- Includes headers from other projects and adds `includes/project` tag
includes = function(projects)
  for _, project in pairs(projects) do
    includedirs { "src/" .. project .. "/include" }
    tags { "includes/" .. project }
  end
end

-- Shorthand for both `includes` and `links`, adds `uses/project` tag
uses = function(projects)
  for _, project in pairs(projects) do
    includes { project }
    links { project }
    tags { "uses/" .. project }
  end
end

-- Default configurations
configurations { "debug", "release", "test" }

-- Release configuration
filter "release"
  defines { "NDEBUG" }
  optimize "On"

-- Debug configuration
filter "debug"
  symbols "On"
  defines { "DEBUG" }
