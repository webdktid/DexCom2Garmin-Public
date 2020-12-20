/*
 * NightscoutData Garmin Connect IQ data field application
 * Copyright (C) 2017 tynbendad@gmail.com
 * #WeAreNotWaiting
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, version 3 of the License.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   A copy of the GNU General Public License is available at
 *   https://www.gnu.org/licenses/gpl-3.0.txt
 */

using Toybox.Background;
using Toybox.Communications;
using Toybox.System as Sys;
using Toybox.Application as App;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.

(:background)
class Dex2GarBG extends Toybox.System.ServiceDelegate {
    var reqNum = 0;

    function initialize() {
        Sys.ServiceDelegate.initialize();
        makeRequestToFunction();
    }

    function printMem() {
        var myStats = System.getSystemStats();
        Sys.println("mem total: " + myStats.totalMemory + ", used: " + myStats.usedMemory + ", free: " + myStats.freeMemory);
        Sys.println("memory: free: " + System.getSystemStats().freeMemory);
    }


    function onReceive(responseCode, data) {
    
      if ((responseCode == 200) && (data != null) && data!="") 
      		{
		        Background.exit(data);
            }
            else
            {
            	makeRequestToFunction();
            	Background.exit("-2,"+ responseCode);
            }
    }

   

    function onTemporalEvent() {
                makeRequestToFunction();
    }

	function makeRequestToFunction()
	{
	    var username = App.getApp().getProperty("username");	
	    var password = App.getApp().getProperty("password");	
	    var region = App.getApp().getProperty("region");	
	    var unit = App.getApp().getProperty("unit");	

	    var regionString = "eu";
	    if(region=="1"){
			regionString = "us";
	    }
	    var url = "https://dexcom2garmin.azurewebsites.net/api/GetGlucoseValueNow?username="+username+"&password="+password+"&region=" + regionString;
	
	     Sys.println("url:" + url);
	
	       Communications.makeWebRequest(url, {}, { :method => Communications.HTTP_REQUEST_METHOD_GET,}, method(:onReceive));
	}

}
