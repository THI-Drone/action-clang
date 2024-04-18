#!/bin/bash
# inputs: 
# $1: true to apply changes regarding formatting
apply_changes=$1
# $2: true commit the changes directly
commit=$2
# $3: commit message
commit_msg=$3
# $4: commit user name
commit_user_name=$4
# $5: commit user email
commit_user_email=$5

# function to check modified, added, or copied C++ files and format them
format_files() {
    echo "Formatting files..."
    for file in $(git diff --name-only --diff-filter=ACMR HEAD | grep -E '.cpp|.h'); do
      echo "Formatting: $file"
      clang-format -i -style=Google $file
    done
}

# decide whether to format files
if [[ "$apply_changes" == "true" ]]; then
    format_files
fi

# decide whether to commit changes
if [[ "$commit" == "true" ]]; then
    # commit applied changes
    git config --local user.email "$commit_user_email"
    git config --local user.name "$commit_user_name"
    git add .
    if [ -z "$(git status --porcelain)" ]; then
        exit 0
    fi
    git commit -m "$commit_msg"
    git push origin HEAD:${GITHUB_REF}
else
    git add .
    if [ -z "$(git status --porcelain)" ]; then
        echo "google style is not met"
        exit 1
    fi
fi
