-- LoadCatGui.lua
-- Loader script: fetches CatGui.lua from a hosted URL and runs it.
-- Replace RAW_URL below with the raw link to your hosted CatGui.lua
-- (e.g. a GitHub raw URL, or wherever you host it for testing).

local RAW_URL = "https://raw.githubusercontent.com/yourusername/yourrepo/main/CatGui.lua"

loadstring(game:HttpGet(RAW_URL))()
