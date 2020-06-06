# amazon.iap.*

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [library][api.type.library]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          Amazon, IAP, in-app purchases
> __Platforms__			Amazon Appstore for Android
> --------------------- ------------------------------------------------------------------------------------------

## Overview

The Amazon In-App Purchasing plugin lets you sell digital content and subscriptions from within your apps, including <nobr>in-game</nobr> currency, expansion packs, upgrades, magazine issues, and more.

Before using the Amazon IAP plugin, please familiarize yourself with the Amazon <nobr>In-App</nobr> Purchasing workflows [here](https://developer.amazon.com/sdk/in-app-purchasing.html). Please note that you must install the [Amazon&nbsp;SDK&nbsp;Tester](https://developer.amazon.com/sdk/in-app-purchasing/documentation/testing-iap.html) or publish your app through the Amazon Appstore to use the Amazon IAP plugin.


## Registration

To use the Amazon In-App Purchasing API, you must distribute your app with the Amazon Appstore. Please [register](http://developer.amazon.com) for an account.


## Functions 

The Amazon IAP plugin provides most functions and fields provided by the core [store][api.library.store] library with some minor differences and additions.

#### [store.availableStores][api.library.store.availableStores]

Not operational for Amazon IAP.

#### [store.target][api.library.store.target]

This property always equals `"amazon"`. Your app should not require the plugin until it has been determined to be appropriate, but this value can be used for conditional logic elsewhere in your app.

#### [store.init()][api.library.store.init]

This function does not require a store name as the first parameter. The only required parameter is the callback function.

#### [store.canLoadProducts][api.library.store.canLoadProducts]

This property always equals `true`.

#### [store.loadProducts][api.library.store.loadProducts]

Each product returned in the callback listener's `event.products` table includes `itemType` which can be either `"CONSUMABLE"`, `"ENTITLEMENT"`, or `"SUBSCRIPTION"`.

#### [store.canMakePurchases][api.library.store.canMakePurchases]

This property always equals `true`. The Amazon Appstore allows a customer to disable <nobr>in-app</nobr> purchasing and the IAP workflow will reflect this when the user is prompted to buy an item. However, there is no way for your app to know if a user has disabled IAP.

#### [store.purchase()][api.library.store.purchase]

* This function takes a string (single SKU) instead of an array of items to purchase. The Amazon IAP plugin does not support purchasing multiple items in one transaction.

* Transaction objects in the callback listener contain an additional `.userId` which identifies the user that made the purchase.

* Transaction objects in the callback listener may additionally contain `.subscriptionStartDate` and `.subscriptionEndDate` if the purchased item was a subscription. These properties are represented in <nobr>epoch-milliseconds.</nobr>

* Transaction objects in the callback listener will never contain `.date`.

* Transaction objects in the callback listener will never contain `.signature`.

* Transaction objects in the callback listener will never be of the state `"cancelled"`. Instead, `.state` will equal `"failed"` if the user canceled the transaction.

* If you call this function on an entitlement or subscription that the user already owns, the callback will be called but the only property that will be returned is `.state` with a value of `"restored"`. This is a limitation of the Amazon IAP SDK, so you should not call purchase on entitlements that the user already owns.

#### [store.finishTransaction()][api.library.store.finishTransaction]

Not operational for Amazon IAP. This merely exists to help with cross-platform compatibility.

#### [store.restore()][api.library.store.restore]

* Transaction objects in the callback listener will never contain `.originalReceipt`, `.originalIdentifier`, or `.originalDate` in the event of a restore. Restore events are identical to purchase events except that they have a state value of `"restored"`.

* Amazon IAP offers an additional state of `"revoked"` which might occur after calling `store.restore()`. In this case, a revoked transaction will contain `.userId`, `.identifier`, and `.productIdentifier`. 

#### store.getUserId()

This function is provided for the Amazon IAP Plugin in addition to the Corona [store][api.library.store] library. It can be called anytime after calling [store.init()][api.library.store.init] to determine the ID of the currently <nobr>logged-in</nobr> user. If called before [store.init()][api.library.store.init], this function will return `nil`. If the <nobr>logged-in</nobr> user is unknown, it will return `"unknown"`.

#### store.isSandboxMode()

This function is provided for the Amazon IAP Plugin in addition to the Corona [store][api.library.store] library. It returns `true` when the app is running in the context of the Amazon&nbsp;SDK&nbsp;Tester or `false` when the app has been installed via the Amazon Appstore.


## Project Settings

To use this plugin, add an entry into the `plugins` table of `build.settings`. When added, the build server will integrate the plugin during the build phase.

``````lua
settings =
{
	plugins =
	{
		["plugin.amazon.iap"] =
		{
			publisherId = "com.amazon",
			supportedPlatforms = { ["android-kindle"]=true },
		},
	},
}
``````


## Corona Enterprise

This plugin is pre-bundled in the `Plugins-3rd-Party` folder of the `CoronaEnterprise` download. To use it, copy the following `.jar` files to the `libs` directory of your Android project:

* `in-app-purchasing-1.0.3.jar`
* `plugin.amazon.iap.jar`

Alternatively, you may wish to use the `in-app-purchasing-1.0.3.jar` directly. Please refer to the [documentation](https://developer.amazon.com/sdk/in-app-purchasing.html).


## Documentation

[https://developer.amazon.com/sdk/in-app-purchasing.html](https://developer.amazon.com/sdk/in-app-purchasing.html)


## Example

``````lua
local store

local function storeListener( event )

	local transaction = event.transaction

	if ( transaction.state == "purchased" ) then
		print( "product identifier", transaction.productIdentifier )
		print( "receipt", transaction.receipt )
		print( "transaction identifier", transaction.identifier )
		print( "user who made purchase", transaction.userId )

	elseif ( transaction.state == "restored" ) then 
		print( "product identifier", transaction.productIdentifier ) 
		print( "receipt", transaction.receipt ) 
		print( "transaction identifier", transaction.identifier ) 
		print( "user who made purchase", transaction.userId )

	elseif ( transaction.state == "revoked" ) then 
		print( "product identifier", transaction.productIdentifier ) 
		print( "receipt", transaction.receipt ) 
		print( "transaction identifier", transaction.identifier )
		print( "user who revoked purchase", transaction.userId )

	elseif ( transaction.state == "failed" ) then 
		print( "transaction failed", transaction.errorType, transaction.errorString ) 
	else
		print( "(unknown event)" )
	end
end 
     
local function loadProductsListener( event )

	local products = event.products
	
	for i = 1,#event.products do 
		print( event.products[i].title )
		print( event.products[i].description )
		print( event.products[i].localizedPrice )
		print( event.products[i].productIdentifier )
	end
	for j = 1,#event.invalidProducts do 
		print( event.invalidProducts[j] ) 
	end 
end 

if ( system.getInfo("targetAppStore") == "amazon" or system.getInfo("environment") == "simulator" ) then 

	store = require( "plugin.amazon.iap" )

	store.init( storeListener ) 
	print( "logged in user is", store.getUserId() )

	store.restore()

	store.loadProducts( { "my_test_sku", "my_real_sku" }, loadProductsListener )

	if ( store.isSandboxMode() == true ) then
		store.purchase( "my_test_sku" )
	else
		store.purchase( "my_real_sku" )
	end
end
``````

## Support

* [http://developer.amazon.com/](http://developer.amazon.com)
* [Corona Forums](http://forums.coronalabs.com/forum/614-amazon-iap/)
