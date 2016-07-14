using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class ColombiaDigitalView extends Ui.WatchFace {

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
    
    	// Black out the string
		dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
		dc.fillRectangle(0,0,dc.getWidth(), dc.getHeight());
    
    	// Draw the flag
		var flag_width = dc.getWidth();
		var flag_height = dc.getHeight() - (2+Gfx.getFontHeight(Gfx.FONT_MEDIUM));
		var yellow_height = flag_height / 2;
		var blue_height = flag_height / 4;
		var red_height = blue_height;
		
		dc.setColor(Gfx.COLOR_YELLOW,Gfx.COLOR_BLACK);
		dc.fillRectangle(0,0,flag_width, yellow_height);
		dc.setColor(Gfx.COLOR_BLUE,Gfx.COLOR_BLACK);
		dc.fillRectangle(0,yellow_height, flag_width, blue_height);
		dc.setColor(Gfx.COLOR_RED,Gfx.COLOR_BLACK);
		dc.fillRectangle(0,yellow_height+blue_height, flag_width, red_height);
	
		// Draw the time
		var clockTime = Sys.getClockTime();
		var format = "$1$:$2$";
		var timeString = Lang.format(format, [clockTime.hour, clockTime.min.format("%02d")]);
		dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_BLACK);
		dc.drawText(2, yellow_height+blue_height+red_height +1, Gfx.FONT_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_LEFT);
    
    	// Draw the battery percentage
    	var batString = Lang.format("$1$%", [Sys.getSystemStats().battery.format("%02d")]);
    	dc.drawText((dc.getWidth()-batString.length())/2, yellow_height+blue_height+red_height +1, Gfx.FONT_MEDIUM, batString, Gfx.TEXT_JUSTIFY_CENTER);
    
    	// Draw the date
		var date = Time.Gregorian.info(Time.now(),Time.FORMAT_LONG);
		var dateString = Lang.format("$1$ $2$", [date.day, date.month]);
		dc.drawText(dc.getWidth()-dateString.length(),yellow_height+blue_height+red_height +1,Gfx.FONT_MEDIUM, dateString, Gfx.TEXT_JUSTIFY_RIGHT);
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

}
