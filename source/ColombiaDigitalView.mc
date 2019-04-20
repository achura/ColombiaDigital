using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

class ColombiaDigitalView extends Ui.WatchFace {

	hidden var mScreenHeight;
	hidden var mScreenWidth;
	hidden var mTextHeight;

    function initialize() {
        WatchFace.initialize();
	}

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
		mScreenHeight = dc.getHeight();
		mScreenWidth = dc.getWidth();
		mTextHeight = 2+Gfx.getFontHeight(Gfx.FONT_MEDIUM);

		var height = mScreenHeight + 1;
		var y = 0;

    	if(Sys.getDeviceSettings().screenShape == Sys.SCREEN_SHAPE_ROUND) {
			y = mTextHeight;
			height = height - 2*mTextHeight;

			drawFlag(dc, 0, y, height, mScreenWidth);
    		drawDateForRoundScreen(dc);
    		drawTimeForRoundScreen(dc);
	    } else {
			y = 0;
			height = height - mTextHeight;

			drawFlag(dc, 0, y, height, mScreenWidth);
    		drawTimeForRectanglarScreen(dc);
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

	function drawFlag(dc, x, y, height, width) {
		var yellow_height = height / 2;
		var blue_height = height / 4;
		var red_height = blue_height;
		
		//! Yellow
		dc.setColor(Gfx.COLOR_YELLOW,Gfx.COLOR_BLACK);
		dc.fillRectangle(x,y,width, yellow_height);
		
		//! Blue
		dc.setColor(Gfx.COLOR_DK_BLUE ,Gfx.COLOR_BLACK);
		dc.fillRectangle(x,y+yellow_height, width, blue_height);

		//! Red
		dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_BLACK);
		dc.fillRectangle(x,y+yellow_height+blue_height, width, red_height);
	}

	function drawTimeForRectanglarScreen(dc) {
		var y = mScreenHeight - mTextHeight + 1;
		
		//! Clear the canvas
		dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
		dc.fillRectangle(0,y-1,mScreenWidth,mTextHeight);

		//! Draw the time
		var clockTime = Sys.getClockTime();
		var timeString = getTimeString();
		dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_TRANSPARENT);
		dc.drawText(2, y, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_LEFT);
    
    	//! Draw the battery percentage
    	var batString = Lang.format("$1$%", [Sys.getSystemStats().battery.format("%02d")]);
    	dc.drawText((mScreenWidth-batString.length())/2, y, Gfx.FONT_MEDIUM, batString, Gfx.TEXT_JUSTIFY_CENTER);
    
    	//! Draw the date
		var date = Time.Gregorian.info(Time.now(),Time.FORMAT_LONG);
		var dateString = Lang.format("$1$ $2$", [date.day, date.month]);
		dc.drawText(mScreenWidth-dateString.length(),y,Gfx.FONT_MEDIUM, dateString, Gfx.TEXT_JUSTIFY_RIGHT);
	}
	
	function drawTimeForRoundScreen(dc) {
		var y = mScreenHeight - mTextHeight + 1;

		//! Clear the canvas
		dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
		dc.fillRectangle(0,y-1,mScreenWidth,mTextHeight);

		//! Draw the time
		var timeString = getTimeString();
		dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_BLACK);
		dc.drawText((mScreenWidth-timeString.length())/2, y, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	}

	function drawDateForRoundScreen(dc) {		
		//! Clear the canvas
		dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
		dc.fillRectangle(0,0,mScreenWidth,mTextHeight);

		//! Draw the date
		dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_BLACK);
		var date = Time.Gregorian.info(Time.now(),Time.FORMAT_LONG);
		var dateString = Lang.format("$1$ $2$", [date.day, date.month]);
		dc.drawText((mScreenWidth-dateString.length())/2, 1, Gfx.FONT_MEDIUM, dateString, Gfx.TEXT_JUSTIFY_CENTER);
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
