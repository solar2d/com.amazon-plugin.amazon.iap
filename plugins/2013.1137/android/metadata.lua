local metadata =
{
	plugin =
	{
		format = 'jar', -- Valid values are 'jar'
		manifest = 
		{
			permissions = {},
			usesPermissions =
			{
			},
			usesFeatures = {},
			applicationChildElements =
			{
				-- Example in the comment block
				[[ <receiver android:name="com.amazon.inapp.purchasing.ResponseReceiver" ><intent-filter><action android:name="com.amazon.inapp.purchasing.NOTIFY" android:permission="com.amazon.inapp.purchasing.Permission.NOTIFY"/></intent-filter></receiver>]],
			},
		},
	},
}

return metadata
