function to_array(iterator)
  local arr = {}
  for v in iterator do
    arr[#arr + 1] = v
  end
  return arr
end

function os.capture_lines(cmd)
  local f = assert(io.popen(cmd, 'r'))
  local s = to_array(f:lines('*l'))
  f:close()
  return s
end

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

function strip_last_char(input)
	return string.sub(input, 1, -2)
end

function from_MB_to_B(megabytes) 
	return megabytes * 1024 * 1024
end

function strip_prefix_of(input, prefix_length)
	return string.sub(input, prefix_length + 1)
end

function strip_prefix(input, prefix)
	return strip_prefix_of(input, string.len(prefix))
end

function as_percentage(value, total)
	return (value/total) * 100
end

function sleep(seconds)
	os.execute("sleep " .. seconds)
end
