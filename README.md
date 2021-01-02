# DexCom2Garmin-Public

The data field from garmin: 
https://apps.garmin.com/en-US/apps/b7aebf42-f715-42e2-81b6-8250d2ec8652


This repository is the source code of Dexcom2Garmin.
Dexcom2Garmin is a datafield for a number of Garmin product, I use a Fenix 5x plus and a Edge 530, and I am pretty sure that the field should work with the other devices that I have included in the manifest.
This field connects to a azure function proxy, get data from Dexcom and returns it to the watch or bike computer.
You need to setup the following to get data visible on you Garmin device.

On your phone:
* Enable share in you Dexcom mobile app, you don’t have to share data with anyone, but it need to be enabled to copy data from phone to Dexcom clarity.
On the App (goto garmin Connect - Garmin Devices - the device - Activities, Apps & More - data fields - Dexcom 2 Garmin - settings)
* Username and password that you use when you connect to Dexcom clarity
* Region, EU or US
* Unit mmol or mgdl

There is a number of situations where you may experience that the datafield doesn’t work, I device there problems into 3 sections: 

Missing data
*	For this error, only patience will work, the device gets data every 5 minutes. 
*	Config error, when the Garmin device connects to the proxy service, is may get an error back, some of the common problems are: 
*	Your username or password is incorrect
*	You are using nonstandard characters in username and password
*	You have selected the wrong region

Service errors from the webrequest
*	0	An unknown error has occured.
*	-1	A generic BLE error has occured.
*	-2	We timed out waiting for a response from the host.
*	-3	We timed out waiting for a response from a server.
*	-4	Response contained no data.
*	-5	The request was cancelled at the request of the system.
*	-101	Too many requests have been made.
*	-102	Serialized input data for the request was too large.
*	-103	Send failed for an unknown reason.
*	-104	No BLE connection is available.
*	-200	Request contained invalid http header fields.
*	-201	Request contained an invalid http body.
*	-300	Request timed out before a response was received.
*	-400	Response body data is invalid for the request type.
*	-401	Response contained invalid http header fields.
*	-402	Serialized response was too large.
*	-403	Ran out of memory processing network response.
*	-1000	Filesystem too full to store response data.
*	-1001	Indicates an https connection is required for the request.
*	-1002	Content type given in response is not supported or does not match what is expected.
*	-1004	Connection was lost before a response could be obtained.
*	-1005	Downloaded media file was unable to be read.
*	-1006	Downloaded image file was unable to be processed.
*	-1007	HLS content could not be downloaded. Most often occurs when requested and provided bit rates do not match.


