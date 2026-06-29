local popup = require("helpers/popup")

local mod = {}

local popup_width = 250

-- Setup
function mod.setup(icons, palette)
	mod.properties = {
		position = "right",

		icon = {
			string = "􀙇",
		},

		label = {
			string = "FTN-0b28",
			max_chars = 10,
			scroll_duration = 80,
		},

		popup = { align = "center" },
	}

	return mod
end

local function update(items, item, icons, palette)
	return function(env)
		sbar.exec(
			[=[
      interface=$(scutil --nwi | egrep -om1 'en[0-9]')

      if [[ $interface ]]; then
        wifi_active=true
        wifi_ip=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
        wifi_ssid=$(networksetup -listpreferredwirelessnetworks $interface | sed -n '2p' | xargs) # Working as of macOS 26.3
        sname=$(ipconfig getsummary $interface | grep sname | awk '{print $3}')
      else
        wifi_active=false
      fi

      #      Connected,Interface,Adress,SSID,Hotspot
      printf "%s\n%s\n%s\n%s\n%s" "$wifi_active" "${interface:--}" "${wifi_ip:--}" "${wifi_ssid:--}" "${sname:--}"
    ]=],
			function(result, exit_code)
				local wifi_infos = strSplit(result, "\n")

				local properties = { icon = {}, label = {} }
				wifi_infos[1] = wifi_infos[1] ~= "false"

				if wifi_infos[1] then -- Wifi avail
					if wifi_infos[5] == "-" then -- Sname
						properties.icon.string = icons.wifi.connected
						properties.icon.color = palette.colors.blue
					else
						properties.icon.string = icons.wifi.hotspot
						properties.icon.color = palette.colors.cyan
					end

					if wifi_infos[4] == "-" then -- SSID
						properties.icon.padding_right = 0
						properties.label.drawing = false
					else
						properties.icon.padding_right = items.config.padding.inner
						properties.label = { string = wifi_infos[4], drawing = true }
					end

					if wifi_infos[3] == "-" then -- Local IP
						properties.icon.string = icons.wifi.error
						properties.icon.color = palette.colors.yellow
					end
				else
					properties.icon.color = palette.colors.red
					properties.icon.string = icons.wifi.disconnected
					properties.icon.padding_right = 0
					properties.label.drawing = false
				end

				item:set(properties)
			end
		)
	end
end

local function add_popup_items(item, icons, palette)
	mod.ssid = sbar.add("item", {
		position = "popup." .. item.name,
		icon = {
			font = { style = "Bold" },
			string = icons.wifi.router or icons.wifi.connected,
		},
		width = popup_width,
		align = "center",
		label = {
			font = { size = 15, style = "Bold" },
			max_chars = 18,
			string = "…",
		},
		background = { color = 0x00000000 },
	})

	mod.hostname = sbar.add("item", {
		position = "popup." .. item.name,
		icon  = { align = "left", string = "Hostname:",  width = popup_width / 2 },
		label = { align = "right", string = "…",         width = popup_width / 2, max_chars = 24 },
		background = { color = 0x00000000 },
	})

	mod.ip = sbar.add("item", {
		position = "popup." .. item.name,
		icon  = { align = "left", string = "IP:",        width = popup_width / 2 },
		label = { align = "right", string = "…",         width = popup_width / 2 },
		background = { color = 0x00000000 },
	})

	mod.mask = sbar.add("item", {
		position = "popup." .. item.name,
		icon  = { align = "left", string = "Subnet:",    width = popup_width / 2 },
		label = { align = "right", string = "…",         width = popup_width / 2 },
		background = { color = 0x00000000 },
	})

	mod.router = sbar.add("item", {
		position = "popup." .. item.name,
		icon  = { align = "left", string = "Router:",    width = popup_width / 2 },
		label = { align = "right", string = "…",         width = popup_width / 2 },
		background = { color = 0x00000000 },
	})
end

local function fetch_details()
	sbar.exec("networksetup -getcomputername", function(result)
		mod.hostname:set({ label = result })
	end)
	sbar.exec("scutil --nwi | egrep -om1 'en[0-9]'", function(iface)
		local interface = iface:gsub("%s+", "")
		sbar.exec("ipconfig getifaddr " .. interface, function(result)
			mod.ip:set({ label = result })
		end)
		sbar.exec(
			"networksetup -listpreferredwirelessnetworks "
				.. interface
				.. " | sed -n '2p' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'",
			function(result)
				mod.ssid:set({ label = result })
			end
		)
		sbar.exec(
			"networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'",
			function(result)
				mod.mask:set({ label = result })
			end
		)
		sbar.exec(
			"networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'",
			function(result)
				mod.router:set({ label = result })
			end
		)
	end)
end

local function copy_label_to_clipboard(env)
	local label = sbar.query(env.NAME).label.value
	sbar.exec('echo "' .. label .. '" | pbcopy')
	sbar.set(env.NAME, { label = { string = "􀉁", align = "center" } })
	sbar.delay(1, function()
		sbar.set(env.NAME, { label = { string = label, align = "right" } })
	end)
end

-- Load
function mod.load(items, icons, palette)
	mod.item = sbar.add("item", mod.properties)
	popup.register(mod.item)

	mod.item:set({
		popup = {
			background = {
				color = 0xff101010,
				corner_radius = 10,
				border_width = 1,
				border_color = palette.zone.border,
			},
		},
	})

	add_popup_items(mod.item, icons, palette)

	mod.item:subscribe("wifi_change", update(items, mod.item, icons, palette))
	mod.item:subscribe("mouse.clicked", function(env)
		if env.INFO.button == "right" then
			popup.toggle(mod.item, fetch_details)
		else
			sbar.exec(execs.menubar .. string.format(' -s "%s"', menu_items.wifi))
		end
	end)
	mod.item:subscribe({ "mouse.entered", "mouse.exited" }, function(env)
		mod.item:set({ scroll_texts = env.SENDER == "mouse.entered" })
	end)
	popup.auto_hide(mod.item)

	mod.hostname:subscribe("mouse.clicked", copy_label_to_clipboard)
	mod.ip:subscribe("mouse.clicked",       copy_label_to_clipboard)
	mod.mask:subscribe("mouse.clicked",     copy_label_to_clipboard)
	mod.router:subscribe("mouse.clicked",   copy_label_to_clipboard)
	mod.ssid:subscribe("mouse.clicked",     copy_label_to_clipboard)

	return mod
end

return mod
