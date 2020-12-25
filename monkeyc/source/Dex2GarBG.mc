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

    function onReceive(responseCode, data) {
    
      if ((responseCode == 200) && (data != null) && data!="") 
      		{
		        Background.exit(data);
            }
            else
            {
            	Background.exit("-2,"+ responseCode);
            	makeRequestToFunction();
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
