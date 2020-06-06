local Library = require "CoronaLibrary"

-- Create library
local lib = Library:new{ name='plugin.amazon.iap', publisherId='com.amazon' }

-------------------------------------------------------------------------------
-- BEGIN (Insert your implementation starting here)
-------------------------------------------------------------------------------

-- This sample implements the following Lua:
-- 
lib.target = "amazon"
lib.isActive = false
lib.canMakePurchases = false
lib.canloadProducts = false


lib.init = function()
native.showAlert( 'Amazon IAP is not supported on the iphone.', 'plugin.amazon.iap.init() invoked', { 'OK' } )
end

lib.purchase = function()
native.showAlert( 'Amazon IAP is not supported on the iphone.', 'plugin.amazon.iap.purchase() invoked', { 'OK' } )
end

lib.restore = function()
native.showAlert( 'Amazon IAP is not supported on the iphone.', 'plugin.amazon.iap.restore() invoked', { 'OK' } )
end

lib.getUserId = function()
native.showAlert( 'Amazon IAP is not supported on the iphone.', 'plugin.amazon.iap.getUserId() invoked', { 'OK' } )
end

lib.finishTransaction = function()
native.showAlert( 'Amazon IAP is not supported on the iphone.', 'plugin.amazon.iap.finishTransaction() invoked', { 'OK' } )
end

lib.loadProducts = function()
native.showAlert( 'Amazon IAP is not supported on the iphone.', 'plugin.amazon.iap.loadProducts() invoked', { 'OK' } )
end

lib.isSandboxMode = function()
native.showAlert( 'Amazon IAP is not supported on the iphone.', 'plugin.amazon.iap.isSandboxMode() invoked', { 'OK' } )
return true
end

-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------

-- Return an instance
return lib
