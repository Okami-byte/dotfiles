local mod = {}

-- Setup
function mod.setup(icons, palette)
	mod.properties = {
		position = "right",

		update_freq = 900,

		icon = {
			color = palette.colors.blue,
			string = icons.notifications.empty,
		},

		label = { string = "0" },
	}

	return mod
end

-- Builds a GitHub search-API command for `query` against config.git_api_url/git_key.
-- Works against github.com and GitHub Enterprise/homelab instances alike, since both
-- expose `GET <api_url>/search/issues?q=...`. SbarLua auto-decodes JSON responses into
-- a Lua table, so the callback receives `{ total_count = N, items = {...} }` directly.
local function search_command(key_path, query)
	return string.format(
		[[
      curl -m 15 -s \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $(cat "%s")" \
        "%s/search/issues?q=%s&per_page=1"
    ]],
		key_path,
		config.git_api_url,
		query:gsub(" ", "+")
	)
end

local function set_badge(item, icons, palette, count)
	item:set({
		label = { string = tostring(count) },
		icon = (count > 0) and { color = palette.colors.red, string = icons.notifications.notif }
			or { color = palette.colors.blue, string = icons.notifications.empty },
	})
end

local function update(item, key_path, icons, palette)
	return function(env)
		sbar.exec(search_command(key_path, config.git_pr_query), function(result)
			if type(result) ~= "table" or result.total_count == nil then
				log("notifs", "[error] unexpected PR search response: " .. dump(result))
				return
			end

			set_badge(item, icons, palette, result.total_count)
		end)

		-- Future: fold open-issue count into the same badge. Left disabled since
		-- issues aren't part of the day-to-day workflow on personal repos; flip on
		-- once that changes (e.g. triaging issues on the homelab Gitea/GHE instance).
		-- Requires combining both counts before a single item:set to avoid the two
		-- async responses stomping each other's label.
		--
		-- local issue_query = "is:issue is:open assignee:@me"
		-- sbar.exec(search_command(key_path, issue_query), function(result)
		-- 	if type(result) ~= "table" or result.total_count == nil then
		-- 		log("notifs", "[error] unexpected issue search response: " .. dump(result))
		-- 		return
		-- 	end
		-- 	-- combine with the PR total_count above and set_badge() once
		-- end)
	end
end

-- Load
function mod.load(icons, palette)
	if config.git_key then
		mod.item = sbar.add("item", mod.properties)
		mod.item:subscribe({ "routine", "forced" }, update(mod.item, config.git_key, icons, palette))
		mod.item:subscribe("mouse.clicked", function()
			sbar.exec("open " .. config.git_web_url .. "/pulls/inbox")
		end)
	end

	return mod
end

return mod
