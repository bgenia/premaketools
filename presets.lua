-- Configuration presets

presets = function(presets)
  for _, preset in pairs(presets) do
    tags { "presets/" .. preset }
  end
end

-- Strict warning preset
filter { "tags:presets/strict" }
  warnings "Extra"
  flags { "FatalWarnings" }

-- School 21 C/C++ preset
filter { "tags:presets/school21" }
  cdialect "C11"
  cppdialect "C++17"

  presets { "strict" }
