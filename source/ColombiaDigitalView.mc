using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

const FLAG_SETTING = "flagType";

enum {
	COLOMBIAN_FLAG_TYPE,
	DUTCH_FLAG_TYPE
}

class ColombiaDigitalView extends Ui.WatchFace {

	hidden var mFlagType;
	hidden var mDrawFlag;

    function initialize() {
        WatchFace.initialize();
		updateFlag();
	}

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
		//dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
		//dc.fillRectangle(0,0,dc.getWidth(), dc.getHeight());

		//drawFlag(dc);
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
    	var textHeight = 2 + Gfx.getFontHeight(Gfx.FONT_MEDIUM);    
    	switch(Sys.getDeviceSettings().screenShape) {
	    	case Sys.SCREEN_SHAPE_ROUND:
	    		drawDateForRoundScreen(dc);
				drawFlag(dc, 0, textHeight, dc.getHeight() - 2*textHeight, dc.getWidth());
	    		drawTimeForRoundScreen(dc);
	    	break;
	    	case Sys.SCREEN_SHAPE_RECTANGLE:
			default:
				drawFlag(dc, 0, 0,dc.getHeight() - textHeight, dc.getWidth());
	    		drawTimeForRectanglarScreen(dc);
	    	break;
	    }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

	function onSettingChanged() {
        _mainView.handleSettingUpdate();
		updateFlag();        
        WatchUi.requestUpdate();
	}

	function updateFlag() {
		mFlagType = App.getApp().getProperty(FLAG_SETTING);
		mDrawFlag = true;
	}

	function drawFlag(dc, x, y, height, width) {
		switch(mFlagType) {
			case DUTCH_FLAG_TYPE:
				drawDutchFlag(dc, x, y, height, width);
				break;
			case COLOMBIAN_FLAG_TYPE:
			default:
				drawColombianFlag(dc, x, y, height, width);
				break;
		}
		mDrawFlag = false;
	}

	function drawColombianFlag(dc, x, y, height, width) {
		var yellow_height = height / 2;
		var blue_height = height / 4;
		var red_height = blue_height;
		
		dc.setColor(Gfx.COLOR_YELLOW,Gfx.COLOR_BLACK);
		dc.fillRectangle(x,y,width, yellow_height);
		dc.setColor(Gfx.COLOR_BLUE,Gfx.COLOR_BLACK);
		dc.fillRectangle(x,y+yellow_height, width, blue_height);
		dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_BLACK);
		dc.fillRectangle(x,y+yellow_height+blue_height, width, red_height);
	}

	function drawDutchFlag(dc, x, y, height, width) {		
		dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(x,y,width, height/3);

		dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(x,y+height/3, width, height/3);

		dc.setColor(Gfx.COLOR_BLUE,Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(x,y+2*height/3, width, height/3);
	}

	function drawTimeForRectanglarScreen(dc) {
		// Clear the canvas
		var width = dc.getWidth();
		var height = 2+Gfx.getFontHeight(Gfx.FONT_MEDIUM);
		var y = dc.getHeight() - height + 1;
		var color;
		if(mFlagType == DUTCH_FLAG_TYPE) {
			color = Gfx.COLOR_ORANGE;
		} else {
			color = Gfx.COLOR_BLACK;
		}
		dc.setColor(color,color);
		dc.fillRectangle(0,y-1,width,height);

		// Draw the time
		var clockTime = Sys.getClockTime();
		var timeString = getTimeString();
		dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_TRANSPARENT);
		dc.drawText(2, y, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_LEFT);
    
    	// Draw the battery percentage
    	var batString = Lang.format("$1$%", [Sys.getSystemStats().battery.format("%02d")]);
    	dc.drawText((dc.getWidth()-batString.length())/2, y, Gfx.FONT_MEDIUM, batString, Gfx.TEXT_JUSTIFY_CENTER);
    
    	// Draw the date
		var date = Time.Gregorian.info(Time.now(),Time.FORMAT_LONG);
		var dateString = Lang.format("$1$ $2$", [date.day, date.month]);
		dc.drawText(dc.getWidth()-dateString.length(),y,Gfx.FONT_MEDIUM, dateString, Gfx.TEXT_JUSTIFY_RIGHT);
	}
	
	function drawTimeForRoundScreen(dc) {
		// Clear the canvas
		var width = dc.getWidth();
		var height = 2+Gfx.getFontHeight(Gfx.FONT_MEDIUM);
		var y = dc.getHeight() - height + 1;
		var textColor = Gfx.COLOR_WHITE;
		var backgroundColor = Gfx.COLOR_BLACK;
		dc.setColor(backgroundColor,Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(0,y-1,width,height);

		// Draw the time
		var timeString = getTimeString();
		dc.setColor(textColor,backgroundColor);
		dc.drawText((dc.getWidth()-timeString.length())/2, y, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}

	function drawDateForRoundScreen(dc) {
		// Clear the canvas
		var width = dc.getWidth();
		var height = 2+Gfx.getFontHeight(Gfx.FONT_MEDIUM);
		var textColor = Gfx.COLOR_WHITE;
		var backgroundColor = Gfx.COLOR_BLACK;
		dc.setColor(backgroundColor,Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(0,0,width,height);

		// Draw the date
		dc.setColor(textColor,Gfx.COLOR_TRANSPARENT);
		var date = Time.Gregorian.info(Time.now(),Time.FORMAT_LONG);
		var dateString = Lang.format("$1$ $2$", [date.day, date.month]);
		dc.drawText((dc.getWidth()-dateString.length())/2, 1, Gfx.FONT_MEDIUM, dateString, Gfx.TEXT_JUSTIFY_CENTER);
	}

	function getTimeString() {
		var clockTime = Sys.getClockTime();
		var hour = clockTime.hour;
		if (!Sys.getDeviceSettings().is24Hour && hour > 12) {
			hour = clockTime.hour - 12;
		}
		
		var timeString = Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
		return timeString;
	}
}
