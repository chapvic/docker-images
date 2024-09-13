#!/bin/bash

touch .repolist
touch .releases

echo "# BUILD LIST" > .buildlist

counter=0
update_list=""
commit_text=""

if [ -f .releases ]; then
    cp .releases .releases.$(date +%Y%M%d_%H%M%S)
fi

echo "=== Checkout updates ==="
while IDS= read -r name; do
    # Checkout newer version of package
    pushd $name > /dev/null
    tags=$(task checkout 2>/dev/null | xargs)
    popd > /dev/null

    # Get saved package version, if exist
    saved_tags=$(grep -E "^$name\=" .releases | awk -F= '{print $2}' | xargs)

    # If no version, mark as exclamation
    [[ -n "$saved_tags" ]] || saved_tags="[none]"

    # Check for package rebuild reason
    if [[ -n "$tags" ]] && [[ ! "$tags" == "$saved_tags" ]]; then
        sed -i "/^$name\=/d" .releases
        echo "$name=$tags" >> .releases
        echo "$name" >> .buildlist
        echo "- $name : UPDATE REQUIRED - $saved_tags : $tags"
        update_list="$update_list $name"
        counter=$((counter+1))
    else
        echo "- $name : skip"
    fi
done <.repolist

# Sort releases in alphabetical order
rel=$(cat .releases)
echo "$rel" | sort > .releases

# Prepare commit message
update_list=${update_list:1}
if [[ $counter -gt 0 ]]; then
    [[ -z "$update_list" ]] || commit_text="Updated $(date +%F) - $(echo $update_list | sed 's/\s/\, /g')"
fi

# Commiting changes
echo ""
if [[ -n "$commit_text" ]]; then
    echo "=== Created new build list with $counter update(s) ==="
    echo "Packages:"
    for name in $update_list; do
        echo "- $name"
    done
    echo ""
    echo "Commit message: \"$commit_text\""
    echo ""
    echo "=== Commiting..."
    git add .
    git commit -m "$commit_text"
    git push
    echo ""
    echo "Done"
else
    echo "--- No updates found! ---"
    git add .
    git commit -m "Cleaning build list"
fi
