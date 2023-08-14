-- External libraries support

externallibrary = function(name)
  return function(config)
    project(name)
      kind "Makefile"

      buildcommands(table.translate(config.buildcommands, function(command)
        return "cd " .. _MAIN_SCRIPT_DIR .. "/lib/" .. name .. " && " .. command
      end))

      cleancommands(table.translate(config.cleancommands, function(command)
        return "cd " .. _MAIN_SCRIPT_DIR .. "/lib/" .. name .. " && " .. command
      end))

    project "*"

      filter { "tags:includes/" .. name }
        includedirs(config.exports.includedirs)

      filter { "tags:links/" .. name }
        links(config.exports.links)
  end
end
