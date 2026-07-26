#!/usr/bin/env bash
# Chunkbook — one-time setup.
# Downloads the four library files the splitter needs into ./lib
# Run once:  bash setup.sh

set -euo pipefail

PDFJS="3.11.174"
JSZIP="3.10.1"
PDFLIB="1.17.1"
BASE="https://cdnjs.cloudflare.com/ajax/libs"

cd "$(dirname "$0")"
mkdir -p lib

get () {
  local url="$1" out="lib/$2"
  if [ -s "$out" ]; then
    echo "  already have  $2"
    return
  fi
  echo "  downloading   $2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$out"
  elif command -v wget >/dev/null 2>&1; then
    wget -q "$url" -O "$out"
  else
    echo "Neither curl nor wget is installed. Install one, or download the files by hand:"
    echo "  $url"
    exit 1
  fi
}

echo "Fetching libraries into ./lib"
get "$BASE/pdf.js/$PDFJS/pdf.min.js"          "pdf.min.js"
get "$BASE/pdf.js/$PDFJS/pdf.worker.min.js"   "pdf.worker.min.js"
get "$BASE/jszip/$JSZIP/jszip.min.js"         "jszip.min.js"
get "$BASE/pdf-lib/$PDFLIB/pdf-lib.min.js"    "pdf-lib.min.js"

echo
echo "Checking sizes:"
fail=0
for f in pdf.min.js pdf.worker.min.js jszip.min.js pdf-lib.min.js; do
  if [ ! -s "lib/$f" ]; then
    echo "  MISSING  $f"; fail=1; continue
  fi
  bytes=$(wc -c < "lib/$f" | tr -d ' ')
  if [ "$bytes" -lt 20000 ]; then
    echo "  TOO SMALL  $f  (${bytes} bytes — probably an error page, delete it and retry)"; fail=1
  else
    echo "  ok  $f  (${bytes} bytes)"
  fi
done

if [ "$fail" -ne 0 ]; then
  echo
  echo "Setup did not complete. Fix the files listed above and run this again."
  exit 1
fi

echo
echo "Done. Now start a local server from this folder:"
echo "    python3 -m http.server 8000"
echo "and open  http://localhost:8000"
