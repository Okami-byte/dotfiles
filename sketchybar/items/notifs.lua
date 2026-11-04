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
-- expose `GET <api_url>/search/issues?q=...`. Runs in the background (detached from
-- the calling sbar.exec's pipe) so the network round-trip never blocks the bar's
-- event thread; the result comes back via the "notifs_update" trigger as either a
-- number or "err:<reason>" (see helpers/pr_count.sh, which does the request).
local function search_command(key_path, query)
	return string.format(
		[[
      (/bin/zsh -lc '
        info=$(./helpers/pr_count.sh "%s" "%s" "%s")
        sketchybar --trigger notifs_update "INFO=$info"
      ') > /dev/null 2>&1 &
    ]],
		key_path,
		config.git_api_url,
		query
	)
end

-- `count` is nil when the lookup failed (bad token, network, rate limit): show a yellow
-- slashed bell instead of "0" so a broken lookup never looks like "nothing to review".
-- The bar stays quiet about why; the reason goes to the log (see the handler in load).
local function set_badge(item, icons, palette, count)
	if not count then
		item:set({
			label = { string = "" },
			icon = { color = palette.colors.yellow, string = icons.notifications.error },
		})
		return
	end

	item:set({
		label = { string = tostring(count) },
		icon = (count > 0) and { color = palette.colors.red, string = icons.notifications.notif }
			or { color = palette.colors.blue, string = icons.notifications.empty },
	})
end

local function update(item, key_path)
	return function(env)
		sbar.exec(search_command(key_path, config.git_pr_query), function() end)

		-- Future: fold open-issue count into the same badge. Left disabled since
		-- issues aren't part of the day-to-day workflow on personal repos; flip on
		-- once that changes (e.g. triaging issues on the homelab Gitea/GHE instance).
		-- Requires combining both counts before a single item:set to avoid the two
		-- background responses stomping each other's label.
		--
		-- local issue_query = "is:issue is:open assignee:@me"
		-- sbar.exec(search_command(key_path, issue_query), function() end)
	end
end

-- Load
function mod.load(icons, palette)
	if config.git_key then
		mod.item = sbar.add("item", mod.properties)
		mod.item:subscribe({ "routine", "forced" }, update(mod.item, config.git_key))
		mod.item:subscribe("notifs_update", function(env)
			local count = tonumber(env.INFO)
			if not count then
				log("notifs", "lookup failed: " .. tostring(env.INFO)) -- e.g. "err:HTTP 401 Bad credentials"
			end
			set_badge(mod.item, icons, palette, count)
		end)
		mod.item:subscribe("mouse.clicked", function()
			sbar.exec("open " .. config.git_web_url .. "/pulls/inbox")
		end)

		-- Look up once after startup; otherwise the badge sits at 0 until the first refresh.
		-- It needs a few seconds: 2s was too early (the bar was still settling after a reload).
		sbar.delay(8, update(mod.item, config.git_key))
	end

	return mod
end

return mod
