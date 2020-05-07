require('util')

local delim="|"

function network()
	local command = "netstat -i -b -n -h -f inet -s -I iwm0"
	local result = os.capture_lines(command)
	local bandwidth = result[#result]
	local split = to_array(string.gmatch(bandwidth, "%S+"))
	return "iwm0: " .. split[4] .. " D " .. split[5] .. " U " .. split[#split]
end

function cpu()
	local command = "top -d 1 -s 0 -1 -u"
	local result = os.capture_lines(command)
	local load_averages = result[1]
	local split = to_array(string.gmatch(load_averages, "[%d.]+"))
	return "L.Avg. " .. split[1] .. ", " .. split[2] .. ", " .. split[3]
end

function memory()
	local command = "vmstat -c 1 -w 0"
	local result = os.capture_lines(command)
	local last = result[#result]
	local matches = to_array(string.gmatch(last, "%S+"))
	local usermem = tonumber(
		strip_prefix(
			os.capture("sysctl hw.usermem"),
			"hw.usermem="))
	local used_str = strip_last_char(matches[3])
	local available_str = strip_last_char(matches[4])
	local used = as_percentage(from_MB_to_B(tonumber(used_str)),usermem)
	local available = as_percentage(from_MB_to_B(tonumber(available_str)),usermem)
	local result = string.format(
		"AVM %.1f%%%sFVM %.1f%%",
		used,
		delim,
		available)
	return result
end

function plugged_in()
	local command = "apm -a"
	local plugged_in_state = "Unknown"
	local result = os.capture(command)
	if "1" == result then
		plugged_in_state = "C"
	elseif "0" == result then
		plugged_in_state = "D"
	elseif "2" == result then
		plugged_in_state = "Back."
	end
	return plugged_in_state
end

function power_percentage_left()
	return "B " .. os.capture("apm -l") .. "%"
end

function timestamp()
	local command = "date +'wk%U.%u" .. delim .. "%a" .. delim .. "%F"
	.. delim .. "%T%z'"
	return os.capture(command)
end

function update_xroot_name(value)
	os.execute('xsetroot -name "' .. value .. '"')
end

function continuously_update_xroot_name()
	while true do
		local new_value = string.format(
		"%s%s%s%s%s%s%s%s%s%s%s",
		network(),
		delim,
		cpu(),
		delim,
		memory(),
		delim,
		plugged_in(),
		delim,
		power_percentage_left(),
		delim,
		timestamp())
		update_xroot_name(new_value)

		sleep(1)
	end
end

