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

	/*
	mValue = 0 //Data
		errorMsg = "Error in data";
	mValue = -1 //settings
		errorMsg = settings error
	mValue = -2
		errorMsg = ServiceErrors[mTrend];
	*/


 	const dirSwitch = { 
	                      "1" => ["Fast up"], //DoubleUp
	 					  "2" => ["Up"], //SingleUp
	                      "3" => ["Rising"], //FortyFiveUp
	                      "4" => ["Flat"], //flat
	                      "5" => ["Falling"], //FortyFiveDown
	                      "6" => ["Down"], //SingleDown
	                      "7" => ["Fast down"], //DoubleDown
	                      "8" => ["Out of range"], //out of range
	                      "9" => ["Out of range"] }; //RATE OUT OF RANGE



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
        
        valueField.setFont(Graphics.FONT_LARGE);
        		
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            valueField.setColor(Graphics.COLOR_WHITE);
            labelField.setColor(Graphics.COLOR_WHITE);
            
        } else {
            valueField.setColor(Graphics.COLOR_BLACK);
            labelField.setColor(Graphics.COLOR_BLACK);
        }
        
        if(errorMsg==null || errorMsg=="")
		{        
        	valueField.setText(mValue.format("%.1f"));
        	
        	if(dirSwitch.hasKey(mTrend))
         	{
         		labelField.setText( "BG: " + dirSwitch[mTrend][0]);   
         	}
         	else
         	{
         		labelField.setText( "BG:"); 
         	} 
		}
		else
		{
        	
	 		valueField.setText(errorMsg);
			valueField.setFont(Graphics.FONT_TINY);
        	
        	if(mValue==0)
        		{labelField.setText("Data");}
        	if(mValue==-1)
        		{labelField.setText("Settings");}
        	if(mValue==-2)
        		{labelField.setText("Service");}

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
			mValue = 0;
			mTrend = "0";
         	errorMsg = "No data";
         	bgFitContribField.setData(mValue);
         	return 0;    
		 }    	 
         
         var ix = data.find(",");
    	 if(ix==null)
	 	 {
			mValue = 0;
			mTrend = "0";
         	errorMsg = "Error in data";
         	bgFitContribField.setData(mValue);
			return 0;    
		 }    	 
         
          mValue  = data.substring(0, ix).toDouble();
          mTrend = data.substring(ix+1 , 10);
         
         if(mValue==-1)
         {
         	errorMsg = "config error";
         	bgFitContribField.setData(mValue);         	
         	return 0;  
         }
         
         if(mValue==-2)
         {
         	errorMsg = "Code:"+mTrend.toString();
         	bgFitContribField.setData(mValue);
         	return 0;
         }
         
		 errorMsg =null;
         
         var unit = App.getApp().getProperty("unit");	
	     if(unit==MMOL)
	     {
	     	mValue = mValue / 18;
	     }		
      
       	
       	bgFitContribField.setData(mValue);
        	                 
		return mValue; 	   
    }
}