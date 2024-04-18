#!/bin/bash
# inputs: 
# $1: true commit the changes directly
commit=$1
# $2: commit message
commit_msg=$2
# $3: commit user name
commit_user_name=$3
# $4: commit user email
commit_user_email=$4

# check modified, added, or copied C++ files and format them
echo "Formatting files..."
for file in $(find . -name "*.cpp" -o -name "*.cc" -o -name "*.cxx" -o -name "*.hpp" -o -name "*.hh" -o -name "*.h" -o -name "*.hxx" -o -name "*.c++"); do
  echo "Formatting: $file"
  clang-format -i $file
done

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
    if [ -z "$(git status --porcelain)" ]; then
      echo "google style is met"
      exit 0
    else
        echo "google style is not met"
        exit 1
      
    fi
fi
