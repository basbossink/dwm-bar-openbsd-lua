local delim=" | "

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

function timestamp() 
	local command = "date +'wk %U.%u" .. delim .. "%a" .. delim .. "%F"
	.. delim .. "%T%z'"
	return os.capture(command)
end
