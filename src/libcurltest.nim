import libcurl
import ../util/debug

# 参考にしたページ
# https://curl.haxx.se/libcurl/c/url2file.html
# https://qiita.com/soumei/items/c4d9d699ab50ddd0136a

# ヘッダ/ライブラリの場所
# /usr/include/curl/curl.h
# /usr/lib64/libcurl.so.4
# /usr/lib64/libcurl.so.4.5.0
# /usr/lib64/libcurl.so

# リポジトリ
# https://github.com/curl/curl/blob/master/include/curl/curl.h
# https://github.com/Araq/libcurl/blob/master/libcurl.nim

proc writeCallback(buffer: cstring, size: int, nitems: int,
                           outstream: pointer): int{.cdecl.} =

  let bufferSize = buffer.len
  debug "callbackの中", size, nitems, bufferSize

  # 4番目の引数(ポインタ)をキャストしてFileに戻す
  let file: File = cast[File](outstream)

  # 受信データをファイルへ書き込む
  file.write(buffer)

  # レングスの返却
  bufferSize

proc start(): int =

  var
    slist: Pslist = nil
    code: Code = global_init(GLOBAL_ALL)

  let
    # 書き込み用ファイルのオープン
    file = open("result.html", fmWrite)
    # CURLの初期化
    curl = easy_init()

  defer:
    # 後処理
    file.close
    slist_free_all(slist)
    curl.easy_cleanup()
    global_cleanup()

  # URLの設定
  code = curl.easy_setopt(OPT_URL, "https://www.google.co.jp/")
  debug "URLの設定", code

  # VERBOSEオプションを設定
  code = curl.easy_setopt(OPT_VERBOSE, 1)
  debug "VERBOSE", code

  # ヘッダーを作成し登録する
  slist = slist_append(slist, "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100")
  code = curl.easy_setopt(OPT_HTTPHEADER, slist)
  debug "SET HEADER", code

  # ファイル書き込み用コールバック関数を登録する
  code = curl.easy_setopt(OPT_WRITEFUNCTION, writeCallback)
  debug "書き込み関数の登録", code

  # ファイルハンドルを渡す
  code = curl.easy_setopt(OPT_WRITEDATA, file)
  debug "ファイルハンドルの登録", code

  # 実行する
  code = curl.easy_perform()
  debug "実行結果", code
  result = 0

# 引数チェック
when isMainModule:
  quit(start())
