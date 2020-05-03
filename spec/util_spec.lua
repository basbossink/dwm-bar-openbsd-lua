describe('util', function()
	require('util')

	describe('to_array', function()
		it('should return an array representing the passed iterator', function()
			local counter = 0
			local input = function()
				counter = counter + 1
				if counter <= 3 then return counter end
			end
			local actual = to_array(input)
			assert.are.same({1,2,3}, actual)
		end)
	end)

	describe('strip_last_char', function()
		it('should return the string without the last character', function()
			local actual = strip_last_char("ab")
			assert.are.same("a", actual)
		end)
	end)

	describe('from_MB_to_b', function()
		it('should return the value in bytes', function()
			local actual = from_MB_to_B(1)
			assert.are.equal(1024*1024, actual)
			actual = from_MB_to_B(1/1024)
			assert.are.equal(1024, actual)
		end)
	end)

	describe('strip_prefix_of', function()
		it('should return the string without the first specified number of characters', function()
			local actual = strip_prefix_of("ab",1)
			assert.are.same("b", actual)
			actual = strip_prefix_of("abc",2)
			assert.are.equal("c", actual)
		end)
	end)

	describe('strip_prefix', function()
		it('should return the string without the prefix', function()
			local actual = strip_prefix("ab","a")
			assert.are.same("b", actual)
			actual = strip_prefix("abc","ab")
			assert.are.equal("c", actual)
		end)
	end)

	describe('as_percentage', function()
		it('should return the correct percentage value', function()
			local actual = as_percentage(1,1)
			assert.are.equal(100, actual)
			actual = as_percentage(0,1)
			assert.are.equal(0, actual)
			actual = as_percentage(10,100)
			assert.are.equal(10, actual)
		end)
	end)
end)
