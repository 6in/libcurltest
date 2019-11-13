# Package

packageName   = "libcurltest"
version       = "0.1.0"
author        = "input your name"
description   = "sample app with nimble"
license       = "MIT"           

srcDir        = "src"                     # ソースフォルダ
binDir        = "bin"                     # 実行モジュールを配置するフォルダ
bin           = @[ "libcurltest" ]    # アプリケーションファイル名
skipDirs      = @[ "tests" , "util" ]     # nimble install時にスキップするフォルダ
backend       = "c"                       # デフォルトはc

# Dependencies

requires "nim >= 1.0.0"
requires "libcurl >= 1.0.0"

task start, "アプリケーションを実行します":
  exec "nimble build"
  exec "bin/" & packageName & " nim"

task clean, "キャッシュのクリア":
  rmDir "src/nimcache"
  rmDir "tests/nimcache"
  rmDir "util/nimcache"

task pretty, "ソースの整形" :
  exec "nim c -r --hints:off --verbosity:0 --out:bin/test util/pretty_files"
