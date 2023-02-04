# Package
version       = "0.5.0"
author        = "Andre Weissflog, Garett Bass, Gustav Olsson"
description   = "Nim bindings for the sokol C headers"
license       = "MIT"
srcDir        = "src"
# skipDirs      = @["examples"]
binDir        = "build"

# Dependencies
requires "nim >= 1.4.4"
import strformat

let examples = [
  "main",
]

let shaders = [
  "cube",
  "points"
]

proc compilerSwitch(): string =
  when defined(windows):
    return "--cc:vcc"
  else:
    return ""

proc backendSwitch(): string =
  when defined gl:
    return "-d:gl"
  else:
    return ""

proc run(name: string) =
  exec &"nim r {compilerSwitch()} {backendSwitch()} src/{name}"

# Tasks
task main, "main":
  run "main"

task build_debug, "Build all examples in debug mode":
  # hmm, is there a better way?
  for example in examples:
      exec &"nim c --outdir:build {backendSwitch()} {compilerSwitch()} --debugger:native examples/{example}"

task build_all, "Build all examples in release mode":
  # hmm, is there a better way?
  for example in examples:
      exec &"nim c --outdir:build {backendSwitch()} {compilerSwitch()} -d:release examples/{example}"

task shaders, "Compile all shaders (requires sokol-tools-bin)":
  let binDir = "bin"
  let shdcPath = 
    when defined(windows):
      &"{binDir}/win32/sokol-shdc"
    elif defined(macosx) and defined(arm64):
      &"{binDir}/osx_arm64/sokol-shdc"
    elif defined(macosx):
      &"{binDir}/osx/sokol-shdc"
    else:
      &"{binDir}/sokol-shdc"
  for shader in shaders:
    let cmd = &"{shdcPath} -i src/shaders/{shader}.glsl -o src/shaders/{shader}.nim -l glsl330:metal_macos:hlsl4 -f sokol_nim"
    echo &"    {cmd}"
    exec cmd
