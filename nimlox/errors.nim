proc report(line: int, where: string, message: string) =
  echo "[line ", line, "] Error", where, ": ", message

proc error *(line: int, message: string) =
  report(line, "", message)
