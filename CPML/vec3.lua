--- A 3 component vector.
-- @module vec3

local sqrt    = math.sqrt
local cos     = math.cos
local sin     = math.sin
local vec3    = {}
local vec3_mt = {}

-- Private constructor.
local function new(x, y, z)
	local v       = {}
	v.x, v.y, v.z = x, y, z
	return setmetatable(v, vec3_mt)
end

-- Do the check to see if JIT is enabled. If so use the optimized FFI structs.
local status, ffi
if type(jit) == "table" and jit.status() then
	status, ffi = pcall(require, "ffi")
	if status then
		ffi.cdef "typedef struct { double x, y, z;} cpml_vec3;"
		new = ffi.typeof("cpml_vec3")
	end
end

--- Constants
-- @table vec3
-- @field unit_x X axis of rotation
-- @field unit_y Y axis of rotation
-- @field unit_z Z axis of rotation
-- @field zero Empty vector
vec3.unit_x = new(1, 0, 0)
vec3.unit_y = new(0, 1, 0)
vec3.unit_z = new(0, 0, 1)
vec3.zero   = new(0, 0, 0)

-- Statically allocate a temporary variable used in some of our functions.
local tmp = new(0, 0, 0)

--- The public constructor.
-- @param x Can be of three types: </br>
-- number X component
-- table {x, y, z} or {x=x, y=y, z=z}
-- scalar To fill the vector eg. {x, x, x}
-- @tparam number y Y component
-- @tparam number z Z component
-- @treturn vec3 out
function vec3.new(x, y, z)
	-- number, number, number
	if x and y and z then
		assert(type(x) == "number", "new: Wrong argument type for x (<number> expected)")
		assert(type(y) == "number", "new: Wrong argument type for y (<number> expected)")
		assert(type(z) == "number", "new: Wrong argument type for z (<number> expected)")

		return new(x, y, z)

	-- {x, y, z} or {x=x, y=y, z=z}
	elseif type(x) == "table" then
		local x, y, z = x.x or x[1], x.y or x[2], x.z or x[3]
		assert(type(x) == "number", "new: Wrong argument type for x (<number> expected)")
		assert(type(y) == "number", "new: Wrong argument type for y (<number> expected)")
		assert(type(z) == "number", "new: Wrong argument type for z (<number> expected)")

		return new(x, y, z)

	-- number
	elseif type(x) == "number" then
		return new(x, x, x)
	else
		return new(0, 0, 0)
	end
end

--- Clone a vector.
-- @tparam vec3 a Vector to be cloned
-- @treturn vec3 out
function vec3.clone(a)
	return new(a.x, a.y, a.z)
end

--- Add two vectors.
-- @tparam vec3 out Vector to store the result
-- @tparam vec3 a Left hand operant
-- @tparam vec3 b Right hand operant
-- @treturn vec3 out
function vec3.add(out, a, b)
	out.x = a.x + b.x
	out.y = a.y + b.y
	out.z = a.z + b.z
	return out
end

--- Subtract one vector from another.
-- @tparam vec3 out Vector to store the result
-- @tparam vec3 a Left hand operant
-- @tparam vec3 b Right hand operant
-- @treturn vec3 out
function vec3.sub(out, a, b)
	out.x = a.x - b.x
	out.y = a.y - b.y
	out.z = a.z - b.z
	return out
end

--- Multiply a vector by another vectorr.
-- @tparam vec3 out Vector to store the result
-- @tparam vec3 a Left hand operant
-- @tparam vec3 b Right hand operant
-- @treturn vec3 out
function vec3.mul(out, a, b)
	out.x = a.x * b.x
	out.y = a.y * b.y
	out.z = a.z * b.z
	return out
end

--- Divide a vector by a scalar.
-- @tparam vec3 out Vector to store the result
-- @tparam vec3 a Left hand operant
-- @tparam vec3 b Right hand operant
-- @treturn vec3 out
function vec3.div(out, a, b)
	out.x = a.x / b.x
	out.y = a.y / b.y
	out.z = a.z / b.z
	return out
end

--- Get the normal of a vector.
-- @tparam vec3 out Vector to store the result
-- @tparam vec3 a Vector to normalize
-- @treturn vec3 out
function vec3.normalize(out, a)
	local l = vec3.len(a)
	if l == 0 then
		return out
	end
	out.x = a.x / l
	out.y = a.y / l
	out.z = a.z / l
	return out
end

--- Trim a vector to a given length
-- @tparam vec3 out Vector to store the result
-- @tparam vec3 a Vector to be trimmed
-- @tparam number len Length to trim the vector to
-- @treturn vec3 out
function vec3.trim(out, a, len)
	return out
		:normalize(a)
		:scale(out, math.min(vec3.len(a), len))
end

--- Get the cross product of two vectors.
-- @tparam vec3 out Vector to store the result
-- @tparam vec3 a Left hand operant
-- @tparam vec3 b Right hand operant
-- @treturn vec3 out
function vec3.cross(out, a, b)
	out.x = a.y * b.z - a.z * b.y
	out.y = a.z * b.x - a.x * b.z
	out.z = a.x * b.y - a.y * b.x
	return out
end

--- Get the dot product of two vectors.
-- @tparam vec3 a Left hand operant
-- @tparam vec3 b Right hand operant
-- @treturn number dot
function vec3.dot(a, b)
	return a.x * b.x + a.y * b.y + a.z * b.z
end

--- Get the length of a vector.
-- @tparam vec3 a Vector to get the length of
-- @treturn number len
function vec3.len(a)
	return sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
end

--- Get the squared length of a vector.
-- @tparam vec3 a Vector to get the squared length of
-- @treturn number len
function vec3.len2(a)
	return a.x * a.x + a.y * a.y + a.z * a.z
end

--- Get the distance between two vectors.
-- @tparam vec3 a Left hand operant
-- @tparam vec3 b Right hand operant
-- @treturn number dist
function vec3.dist(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y
	local dz = a.z - b.z
	return sqrt(dx * dx + dy * dy + dz * dz)
end

--- Get the squared distance between two vectors.
-- @tparam vec3 a Left hand operant
-- @tparam vec3 b Right hand operant
-- @treturn number dist
function vec3.dist2(a, b)
	local dx = a.x - b.x
	local dy = a.y - b.y
	local dz = a.z - b.z
	return dx * dx + dy * dy + dz * dz
end

--- Scale a vector by a scalar.
-- @tparam vec3 out Vector to store the result
-- @tparam vec3 a Left hand operant
-- @tparam number b Right hand operant
-- @treturn vec3 out
function vec3.scale(out, a, b)
	out.x = a.x * b
	out.y = a.y * b
	out.z = a.z * b
	return out
end

--- Rotate vector about an axis.
-- @tparam vec3 out Vector to store the result
-- @tparam vec3 a Vector to rotate
-- @tparam number phi Amount to rotate, in radians
-- @tparam vec3 axis Axis to rotate by
-- @treturn vec3 out
function vec3.rotate(out, a, phi, axis)
	if not vec3.is_vec3(axis) then
		return a
	end

	local u = new():normalize(axis)
	local c = cos(phi)
	local s = sin(phi)

	-- Calculate generalized rotation matrix
	local m1 = new((c + u.x * u.x * (1 - c)),       (u.x * u.y * (1 - c) - u.z * s), (u.x * u.z * (1 - c) + u.y * s))
	local m2 = new((u.y * u.x * (1 - c) + u.z * s), (c + u.y * u.y * (1 - c)),       (u.y * u.z * (1 - c) - u.x * s))
	local m3 = new((u.z * u.x * (1 - c) - u.y * s), (u.z * u.y * (1 - c) + u.x * s), (c + u.z * u.z * (1 - c))      )

	out.x = a:dot(m1)
	out.y = a:dot(m2)
	out.z = a:dot(m3)
	return out
end

function vec3.perpendicular(out, a)
	out.x = -a.y
	out.y =  a.x
	out.z =  0
	return out
end

--- Lerp between two vectors.
-- @tparam vec3 out Vector to store the result
-- @tparam vec3 a Left hand operant
-- @tparam vec3 b Right hand operant
-- @tparam number s Step value
-- @treturn vec3 out
function vec3.lerp(out, a, b, s)
	return out
		:sub(b, a)
		:scale(out, s)
		:add(out, a)
end

--- Unpack a vector into individual components.
-- @tparam vec3 a Vector to unpack
-- @treturn number x
-- @treturn number y
-- @treturn number z
function vec3.unpack(a)
	return a.x, a.y, a.z
end

--- Return a boolean showing if a table is or is not a vec3.
-- @tparam vec3 a Vector to be tested
-- @treturn boolean is_vec3
function vec3.is_vec3(a)
	if type(a) == "cdata" then
		return ffi.istype("cpml_vec3", a)
	end

	return
		type(a)   == "table"  and
		type(a.x) == "number" and
		type(a.y) == "number" and
		type(a.z) == "number"
end

--- Return a boolean showing if a table is or is not a zero vec3.
-- @tparam vec3 a Vector to be tested
-- @treturn boolean is_zero
function vec3.is_zero(a)
	return
		a.x == 0 and
		a.y == 0 and
		a.z == 0
end

--- Return a formatted string.
-- @tparam vec3 a Vector to be turned into a string
-- @treturn string formatted
function vec3.to_string(a)
	return string.format("(%+0.3f,%+0.3f,%+0.3f)", a.x, a.y, a.z)
end

vec3_mt.__index    = vec3
vec3_mt.__tostring = vec3.to_string

function vec3_mt.__call(_, x, y, z)
	return vec3.new(x, y, z)
end

function vec3_mt.__unm(a)
	return new(-a.x, -a.y, -a.z)
end

function vec3_mt.__eq(a, b)
	if not vec3.is_vec3(a) or not vec3.is_vec3(b) then
		return false
	end
	return a.x == b.x and a.y == b.y and a.z == b.z
end

function vec3_mt.__add(a, b)
	assert(vec3.is_vec3(a), "__add: Wrong argument type for left hand operant. (<cpml.vec3> expected)")
	assert(vec3.is_vec3(b), "__add: Wrong argument type for right hand operant. (<cpml.vec3> expected)")
	return new():add(a, b)
end

function vec3_mt.__sub(a, b)
	assert(vec3.is_vec3(a), "__sub: Wrong argument type for left hand operant. (<cpml.vec3> expected)")
	assert(vec3.is_vec3(b), "__sub: Wrong argument type for right hand operant. (<cpml.vec3> expected)")
	return new():sub(a, b)
end

function vec3_mt.__mul(a, b)
	assert(vec3.is_vec3(a), "__mul: Wrong argument type for left hand operant. (<cpml.vec3> expected)")
	assert(vec3.is_vec3(b) or type(b) == "number", "__mul: Wrong argument type for right hand operant. (<cpml.vec3> or <number> expected)")

	if vec3.is_vec3(b) then
		return new():mul(a, b)
	end

	return new():scale(a, b)
end

function vec3_mt.__div(a, b)
	assert(vec3.is_vec3(a), "__div: Wrong argument type for left hand operant. (<cpml.vec3> expected)")
	assert(vec3.is_vec3(b) or type(b) == "number", "__div: Wrong argument type for right hand operant. (<cpml.vec3> or <number> expected)")

	if vec3.is_vec3(b) then
		return new():div(a, b)
	end

	return new():scale(a, 1 / b)
end

if status then
	ffi.metatype(new, vec3_mt)
end

return setmetatable({}, vec3_mt)
