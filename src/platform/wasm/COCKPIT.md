# Linux Cockpit additions to mGBA-wasm

This branch (`cockpit/wasm-api`) is [thenick775's wasm fork](https://github.com/thenick775/mgba/tree/feature/wasm)
(`v2.5.1`) plus a small set of exports used by [Linux Cockpit](https://github.com/aaaa0ggMC/Launcher)'s handheld
ability. Everything is additive; nothing existing was changed (besides exporting `HEAPU8` in `CMakeLists.txt`).
Licensed under MPL-2.0 like the rest of mGBA.

## New API (`Module.*`, see `mgba.d.ts`)

| Function | Description |
| --- | --- |
| `readMemory(address, length)` | Read bus memory (GBA: EWRAM `0x02000000`, IWRAM `0x03000000`, ROM `0x08000000`, …) → `Uint8Array \| null`. Stops the emulation thread for the call. |
| `writeMemory(address, data)` | Write bus memory. Policy (who may write) is the host's job. |
| `getGameInfo()` | `{ platform, title, code, maker, version }` of the loaded game. |
| `clearCheats()` | Remove every cheat set from the running game. |
| `addCheats(text)` | Parse mGBA `.cheats` text and add its sets (pair with `clearCheats()` to swap cheats **without reloading**). |
| `getCheatSetCount()` / `setCheatSetEnabled(i, on)` | Inspect / toggle loaded cheat sets. |

The C side lives at the end of the "Linux Cockpit additions" block in `main.c`; the JS wrappers in `pre.js`.

Note: `HEAPU8` is backed by a `SharedArrayBuffer` (pthreads) — `TextDecoder.decode()` rejects shared views, copy first.

## Building

The upstream `docker/Dockerfile` image sets `/home/mgba` to mode 750, so running as your own uid needs the repo mounted
elsewhere:

```bash
docker build -t local-mgba/wasm:2.0 src/platform/wasm/docker
src/platform/wasm/cockpit-build.sh     # output: build-wasm/wasm/{mgba.js,mgba.wasm,mgba.d.ts}
```
