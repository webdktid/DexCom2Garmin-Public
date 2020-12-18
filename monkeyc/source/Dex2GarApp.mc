using Toybox.Application as App;
using Toybox.Background;
using Toybox.Time;
using Toybox.System as Sys;

// info about whats happening with the background process
var canDoBG=false;
var setupReqd=false;
var inBackground=false;
// background data, shared directly with appview
var bgdata;
// keys to the object store data
var OSDATA="osdata";




(:background)
class Dex2GarApp extends App.AppBase {

	var value = 0;
	var trend = 0;
	var myView;
    var offsetSeconds = 15;
    var shiftingOffset = false;
    
    function setNextEvent(seconds) {
        Background.registerForTemporalEvent(new Time.Duration(seconds));
        var nextLoad = Time.now().value() + (seconds);
        App.getApp().setProperty("nextLoad", nextLoad);
    }
    
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
	function onStop(state) {
	
	  if(!inBackground) 
	  {
	  	Background.deleteTemporalEvent();
	  }
	
	}
    
     function onBackgroundData(data) {
		      App.getApp().setProperty("osdata",data);
     	      Sys.println("onBackgroundData: "+ data);
     }

    function getInitialView() {
        //register for temporal events if they are supported

        myView = new Dex2GarView();
        if(Toybox.System has :ServiceDelegate) {
            canDoBG=true;
            Background.deleteTemporalEvent();
            var thisApp = Application.getApp();
	        var temp = thisApp.getProperty("offsetSeconds");
            if (temp!=null && temp instanceof Number) {
            	offsetSeconds=temp;
            	Sys.println("from OS: offsetSeconds="+offsetSeconds);
        	}
        
	        setNextEvent(5 * 60);
        } else {
            //Sys.println("****background not available on this device****");
        }
        return [ myView ];
    }
  
	 function getServiceDelegate(){
        Sys.println("getServiceDelegate:");
        inBackground=true;
      
        return [ new Dex2GarBG()];
    }
}