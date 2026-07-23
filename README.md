# CatGui

A draggable, scrollable Roblox GUI for testing — teleport buttons plus adjustable
Jump Power / Speed sliders (right-click those buttons).

## Files

- `CatGui.lua` — the main script. Place as a LocalScript in `StarterGui` or `StarterPlayerScripts`,
  or host this file and load it remotely (see `LoadCatGui.lua`).
- `LoadCatGui.lua` — a loader script. Point `RAW_URL` at this file's GitHub raw link and run
  the loader to fetch and execute `CatGui.lua` remotely. Requires `HttpService.HttpEnabled = true`
  in Studio (Game Settings → Security).

## Usage

1. Push this repo to GitHub.
2. Grab the raw URL for `CatGui.lua`, e.g.
   `https://raw.githubusercontent.com/<you>/<repo>/main/CatGui.lua`
3. Paste it into `LoadCatGui.lua`'s `RAW_URL` variable.
4. Run `LoadCatGui.lua` in your test place.

Editing `CatGui.lua` on GitHub and pushing updates means every place loading it
picks up the change on next run — no manual re-copying.
