using Toybox.WatchUi;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.FitContributor as Fit;
using Toybox.Math;
using Toybox.Graphics as Gfx;



class Dex2GarView  extends WatchUi.DataField {
	
	const MMOL = 0;
    var bgFitContribField = null;
    const BGFITCONTRIB_FIELD_ID = 0;
	hidden var mValue;
	hidden var mTrend;
	var errorMsg;


 	const dirSwitch = { 
	                      "1" => ["DoubleUp"], //DoubleUp
	 					  "2" => ["SingleUp"], //SingleUp
	                      "3" => ["FortyFiveUp"], //FortyFiveUp
	                      "4" => ["Flat"], //flat
	                      "5" => ["FortyFiveDown"], //FortyFiveDown
	                      "6" => ["SingleDown"], //SingleDown
	                      "7" => ["DoubleDown"], //DoubleDown
	                      "8" => ["Out of range"], //out of range
	                      "9" => ["Out of range"] }; //RATE OUT OF RANGE

	const ServiceErrors = {
						  0=>"An unknown error",
						-1=>"A generic BLE error",
						-2=>"timed out waiting for host.",
						-3=>"timed out waiting for server.",
						-4=>"Response contained no data.",
						-5=>"The request was cancelled",
						-101=>"Too many requests",
						-102=>"Serialized input too large.",
						-103=>"Send failed for an unknown reason.",
						-104=>"No BLE connection available.",
						-200=>"Request invalid http header fields.",
						-201=>"Request invalid http body.",
						-202=>"Request invalid http method.",
						-300=>"Request timeout",
						-400=>"Response body is invalid",
						-401=>"Response invalid http header.",
						-402=>"Serialized response too large.",
						-403=>"Ran out of memory processing response.",
						-1000=>"Filesystem too full to store data",
						-1001=>"https is required for the request.",
						-1002=>"Content type not supported or not expected.",
						-1003=>"Http request was cancelled by the system.",
						-1004=>"Connection lost before response obtained.",
						-1005=>"unable to be read media.",
						-1006=>"unable to proces image.",
						-1007=>"HLS content could not be downloaded."
						};

    // Set the label of the data field here.
    function initialize() {

        DataField.initialize();
        
        bgFitContribField = createField(
            "Blood Glucose",
            BGFITCONTRIB_FIELD_ID,
            FitContributor.DATA_TYPE_FLOAT,
            {:mesgType=>Fit.MESG_TYPE_RECORD, :units=>"bg" }
        );
        
        mValue = 0;
        mTrend = 0;
        errorMsg =null;
        
        bgFitContribField.setData(mValue);
    }

	  function onUpdate(dc) {
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());

        // Set the foreground color and value
        var valueField = View.findDrawableById("value");
        var labelField = View.findDrawableById("label");
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            valueField.setColor(Graphics.COLOR_WHITE);
            labelField.setColor(Graphics.COLOR_WHITE);
            
        } else {
            valueField.setColor(Graphics.COLOR_BLACK);
            labelField.setColor(Graphics.COLOR_BLACK);
        }
        
        if(errorMsg==null)
		{        
        	valueField.setText(mValue.format("%.1f"));
			
			var labelString = "";
		    if (dirSwitch.hasKey(mTrend)) 
	        {
				labelString = "BG: " + dirSwitch[mTrend][0];   
		 		labelField.setText(labelString);
	        }
	        else
	        {
		 		labelField.setText("Unknown error " + mTrend);
	        }
		}
		else
		{
	 		labelField.setText(errorMsg);
        	valueField.setText("");
		}

        View.onUpdate(dc);
    }
    

 // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 20;
            
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 10;
        }

		 
			
        View.findDrawableById("label").setText("Glucose");
        return true;
    }



    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        // See Activity.Info in the documentation for available information.
 
    	 var data = App.getApp().getProperty("osdata");
    	 
    	 if(data==null)
	 	 {
			return 0;    
		 }    	 
         
         var ix = data.find(",");
    	 if(ix==null)
	 	 {
         	errorMsg = "Error in data";
			return 0;    
		 }    	 
         
          mValue  = data.substring(0, ix).toDouble();
          mTrend = data.substring(ix+1 , 10);
         
         if(mValue==-1)
         {
         	errorMsg = "settings i wrong";
         	return 0;
         }
         
         if(mValue==-2)
         {
         	errorMsg = ServiceErrors[mTrend];
         	return 0;
         }
         
		 errorMsg =errorMsg ;
         
         var unit = App.getApp().getProperty("unit");	
	     if(unit==MMOL)
	     {
	     	mValue = mValue / 18;
	   
	     }		
      
        //Sys.println("mValue" + mValue);
        //Sys.println("mTrend" + mTrend);
       	
       	bgFitContribField.setData(mValue);
        	                 
		return mValue; 	   
    }

}