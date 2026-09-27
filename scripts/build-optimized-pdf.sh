#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Build a smaller PDF from temporary copies of this project's PNG assets.

Usage:
  scripts/build-optimized-pdf.sh [--output PATH] [--max-dimension PIXELS]

Options:
  -o, --output PATH          Output PDF path. Defaults to main-optimized.pdf
  --max-dimension PIXELS     Maximum width or height for PNG copies. Defaults to 1950
  -h, --help                 Show this help

The script requires macOS, Typst, rsync, and sips. It does not modify the
original Typst files or PNG assets. By default it leaves main.pdf unchanged.
EOF
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(cd -- "$script_dir/.." && pwd)"
output_path="$project_root/main-optimized.pdf"
max_dimension=1950

while (($# > 0)); do
  case "$1" in
    -o|--output)
      if (($# < 2)); then
        echo "Missing path after $1" >&2
        exit 2
      fi
      output_path="$2"
      shift 2
      ;;
    --max-dimension)
      if (($# < 2)); then
        echo "Missing pixel count after $1" >&2
        exit 2
      fi
      max_dimension="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! "$max_dimension" =~ ^[0-9]+$ ]] || ((max_dimension < 1)); then
  echo "--max-dimension must be a positive integer" >&2
  exit 2
fi

if [[ "$output_path" != /* ]]; then
  output_path="$PWD/$output_path"
fi

if [[ "$output_path" == "$project_root/main.typ" || "$output_path" == "$project_root/appendix.typ" ]]; then
  echo "The output path must not overwrite a Typst source file" >&2
  exit 2
fi

case "$output_path" in
  "$project_root/main.pdf"|"$project_root/main-optimized.pdf")
    ;;
  *)
    if [[ -e "$output_path" ]]; then
      echo "Refusing to overwrite an existing file: $output_path" >&2
      exit 2
    fi
    ;;
esac

for tool in typst rsync sips; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Required command not found: $tool" >&2
    exit 1
  fi
done

if [[ ! -f "$project_root/Auswertung/prepared/plot_data.json" ]]; then
  echo "Missing required file: Auswertung/prepared/plot_data.json" >&2
  exit 1
fi

temp_parent="$project_root/tmp/pdfs"
mkdir -p "$temp_parent"
temp_root="$(mktemp -d "$temp_parent/optimized.XXXXXX")"
cleanup() {
  rm -rf "$temp_root"
  rmdir "$temp_parent" 2>/dev/null || true
  rmdir "$project_root/tmp" 2>/dev/null || true
}
trap cleanup EXIT

build_root="$temp_root/project"
mkdir -p "$build_root"

rsync -a \
  --exclude='.git' \
  --exclude='Auswertung/***' \
  --exclude='/tmp/***' \
  --exclude='/output/***' \
  --exclude='/main.pdf' \
  --exclude='/main_slides.pdf' \
  "$project_root/" "$build_root/"

mkdir -p "$build_root/Auswertung/prepared"
cp "$project_root/Auswertung/prepared/plot_data.json" \
  "$build_root/Auswertung/prepared/plot_data.json"

for image_path in "$build_root"/assets/*.png; do
  [[ -f "$image_path" ]] || continue
  image_info="$(sips -g pixelWidth -g pixelHeight "$image_path")"
  image_width="$(printf '%s\n' "$image_info" | awk '/pixelWidth:/ { print $2 }')"
  image_height="$(printf '%s\n' "$image_info" | awk '/pixelHeight:/ { print $2 }')"

  if ((image_width > max_dimension || image_height > max_dimension)); then
    resized_path="${image_path%.png}.resized.png"
    sips -Z "$max_dimension" "$image_path" --out "$resized_path" >/dev/null
    mv -f "$resized_path" "$image_path"
  fi
done

(
  cd "$build_root"
  typst compile main.typ "$temp_root/main-optimized.pdf"
)

output_dir="$(dirname "$output_path")"
mkdir -p "$output_dir"
staged_output="$output_dir/.$(basename "$output_path").tmp.$$"
cp "$temp_root/main-optimized.pdf" "$staged_output"
mv -f "$staged_output" "$output_path"

echo "Wrote $output_path"
echo "Temporary image copies used a maximum dimension of ${max_dimension}px."
