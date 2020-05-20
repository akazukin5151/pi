import httpclient
import strformat
import strutils
import math

var client = newHttpClient()

proc fetch_digits(start: int): string =
  let r = client.getContent(&"https://api.pi.delivery/v1/pi?start={start}&numberOfDigits=1000")
  return r[12..^1][0..^3]

proc encode(num: string): tuple[s,e: int] =
  var start = 0
  while true:
    var pi_part = fetch_digits(start)
    var index = pi_part.find(num)

    if index == -1:
      start += 1000
      continue

    let actual_index = start + index
    let actual_end = actual_index + int(len(num))
    return (actual_index, actual_end)

proc decode(start_index, end_index: int): string =
  let
    x = start_index.floorDiv(1000) * 1000
    pi_part = fetch_digits(x)
    start = start_index - x
    ending = end_index - x
  return pi_part[start..<ending]

echo "Please enter a number to encode:"
let
  num = readLine(stdin)
  (ind_start, ind_end) = encode(num)
  original = decode(ind_start, ind_end)

echo "your num: ", num
echo "start pos: ", ind_start
echo "end pos: ", ind_end

echo "your original number is: ", original

