#!/usr/bin/env sh

# Flattens two versions of the same LaTeX document and produces a latexdiff of them, leaves the new tex in the new tex directory

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 old.tex new.tex"
    exit 1
fi

oldtex="$(realpath "$1")"
newtex="$(realpath "$2")"
oldflat=$(mktemp).tex
newflat=$(mktemp).tex
diff="$(dirname "$newtex")/diff$(date +%y%m%d).tex"

latexdiff --flatten "$oldtex" "$oldtex" > "$oldflat"
latexdiff --flatten "$newtex" "$newtex" > "$newflat"

# Remove latexdiff extra thinds from flattened files
for file in "$oldflat" "$newflat"; do
    sed -i '/%DIF PREAMBLE/d; /%DIF/d; /DIFscaledelfig/d' "$file"
done

latexdiff "$oldflat" "$newflat" > "$diff"

rm $oldflat $newflat