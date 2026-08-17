local mod = {}

function mod.setup(items, icons, palette)
	mod.properties = {
		updates = true,

		position = "right",
		padding_left = 2,
		padding_right = 5,

		icon = {
			string = icons.camera.inactive,
			width = 22,
			font = { size = 14.0 },
			padding_right = items.config.padding.outer - 2,
			color = palette.colors.purple,
		},

		label = { drawing = false },
	}
	mod.icon = {
		active = { string = icons.camera.active, color = palette.colors.red },
		inactive = { string = icons.camera.inactive, color = palette.colors.purple },
	}
	mod.event = "camera_update"

	return mod
end

local function loadStream(event_name)
	sbar.exec([[
    #SKETCHYBAR_CAMERA_STREAM#

    lastpid=$(cat ${TMPDIR}/sketchybar/camera_pids 2> /dev/null || echo 0);

    if ps -p $lastpid -o command= | grep '#SKETCHYBAR_CAMERA_STREAM#' > /dev/null; then 
      kill -9 $(pgrep -P $lastpid) $lastpid
    fi;

    mkdir -p ${TMPDIR}/sketchybar;

    (
			/usr/bin/log stream --predicate '(eventMessage CONTAINS "AVCaptureSessionDidStartRunningNotification" || eventMessage CONTAINS "AVCaptureSessionDidStopRunningNotification")' | \
			while IFS= read -r line; do
				line=$(echo $line | sed "/^Filtering the log data/d")
				if echo $line | grep "AVCaptureSessionDidStartRunningNotification" >/dev/null; then
					sketchybar --trigger ]] .. event_name .. [[ "INFO=true"
				elif echo $line | grep "AVCaptureSessionDidStopRunningNotification" >/dev/null; then
					sketchybar --trigger ]] .. event_name .. [[ "INFO=false"
				fi
			done
    ) > /dev/null 2>&1 &
    echo $! > ${TMPDIR}/sketchybar/camera_pids;
	]], function(result, exit_code)
		log("camera-stream", "Exited with code: " .. exit_code)
	end)
end

local function updateState(state)
	mod.item:set({ icon = state and mod.icon.active or mod.icon.inactive })
end

function mod.load()
	loadStream(mod.event)

	mod.item = sbar.add("item", mod.properties)
	mod.item:subscribe(mod.event, function(env)
		updateState(env.INFO == "true")
	end)

	mod.item:subscribe("mouse.clicked", function(env)
		sbar.exec('open "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera"')
	end)

	return mod
end

return mod
