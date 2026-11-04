#!/usr/bin/env bash
# Prints how many results a GitHub search returns, or "err:<reason>" if the lookup failed.
# The bell (items/notifs.lua) shows the number, or an error icon and logs the reason.
# Usage: pr_count.sh <token-file> <api-url> <search-query>
set -u

token_file=$1
api_url=$2
query=$3

# `-w` appends the HTTP status to the body so one request gives us both.
response=$(curl -m 15 -s -w 'HTTP:%{http_code}' \
  -H 'Accept: application/vnd.github+json' \
  -H "Authorization: Bearer $(cat "$token_file")" \
  "$api_url/search/issues?q=${query// /+}&per_page=1&advanced_search=true")
status=${response##*HTTP:}
body=${response%HTTP:*}

count=$(jq -r '.total_count // empty' <<<"$body" 2>/dev/null)
if [[ -n $count ]]; then
  echo "$count"
else
  # 401 = bad token, 403/429 = rate limited, 000 = no network or timeout.
  message=$(jq -r '.message // empty' <<<"$body" 2>/dev/null | tr -d '"')
  echo "err:HTTP $status $message"
fi
