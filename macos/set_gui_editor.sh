#! /usr/bin/env bash
# needs duti and yq (the jq sibling)
#brew install duti python-yq
set -ex
app_name=$1
# convert app name to app id
app_id=$(osascript -e "id of app \"$app_name\"")

# set as default editor for 'unspecified' type of file
duti -s "$app_id" public.plain-text all
duti -s "$app_id" public.source-code all
duti -s "$app_id" public.data all

# Example to set for specific file extension
#duti -s "$app_id" .json all

# use github's Linguist to fetch mappings of languages to file extensions
LANGMAP_URL="https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml"
YQ_FILTER_ALL='to_entries | (map(.value.extensions) | flatten) - [null] | unique | .[]'
YQ_FILTER_SOME='{JavaScript,Python,Java,TypeScript,"C#",PHP,"C++",C,Shell,Ruby,Go}'
YQ_FILTER_SOME+=" | $YQ_FILTER_ALL"
YQ_FILTER=$YQ_FILTER_SOME
#curl -sL "$LANGMAP_URL" | yq -r "$YQ_FILTER" | xargs -L 1 -I "{}" duti -s "$app_id" {} all
