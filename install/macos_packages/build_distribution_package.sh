#!/bin/bash

component_package="$1"
resources="$2"

usage(){
    echo "Builds a distribution package for macOS."
    echo "Assumes that the following items already exist:"
    echo "    - A starship component package"
    echo "    - Resources in a pkg_resources directory"
    echo "Usage: $0 <path-to-component-package> <path-to-pkg-resources>"
}

error(){
    echo "[ERROR]: $1"
    exit 1
}

if [[ "$OSTYPE" != 'darwin'* ]]; then
    error "This script only works on MacOS"
fi

if [[ "${2-undefined}" = "undefined" ]]; then
    usage
    exit 1
fi



# Generate a distribution file
productbuild --synthesize --package starship-component.pkg starship_raw.dist

# A terrible hacky way to insert nodes into XML without needing a full XML parser:
# search for a line that matches our opening tag and insert our desired lines after it
# Solution taken from https://www.theunixschool.com/2012/06/insert-line-before-or-after-pattern.html

while read line
do
        echo "$line"
        echo "$line" | grep -qF '<installer-gui-script '
        [ $? -eq 0 ] \
          && echo '<welcome file="welcome.html" mime-type="text-html" />'\
          && echo '<license file="license.html" mime-type="text-html" />'\
          && echo '<conclusion file="conclusion.html" mime-type="text-html" />'\
          && echo '<background file="icon.png" scaling="proportional" alignment="bottomleft"/>'
done < starship_raw.dist > starship.dist

# The above script does not correctly take care of the last line. Apply fixup.
echo '</installer-gui-script>' >> starship.dist

# Build the distribution package
productbuild --distribution starship.dist --resources "$resources" --package-path "$component_package" starship.pkg