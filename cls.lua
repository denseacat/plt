function make_proxy(class, priv, getters, setters, is_expose_private)
  setmetatable(priv, class)  -- fallback priv lookups to class
  local fallback = is_expose_private and priv or class
  local index = getters and
    function(self, key)
      -- read from getter, else from fallback
      local func = getters[key]
      if func then return func(self) else return fallback[key] end
    end
    or fallback  -- default to fast property reads through table
  local newindex = setters and
    function(self, key, value)
      -- write to setter, else to proxy
      local func = setters[key]
      if func then func(self, value)
      else rawset(self, key, value) end
    end
    or fallback  -- default to fast property writes through table
  local proxy_mt = {         -- create metatable for proxy object
    __newindex = newindex,
    __index = index,
    priv = priv
  }
  local self = setmetatable({}, proxy_mt)  -- create proxy object
  return self
end

return make_proxy