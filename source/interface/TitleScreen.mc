import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class TitleScreen extends WatchUi.View {
    public function initialize() {
        View.initialize();
    }

    public function onUpdate(dc as Dc) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(0.5*width, 0.65*height, Graphics.FONT_LARGE, loadResource(Rez.Strings.AppName), 5);
        dc.fillRoundedRectangle(0.52*width, 0.42*height, 0.065*width, 0.065*height, 0.023*width);

        dc.setColor(0x00AAFF, Graphics.COLOR_BLACK);
        dc.drawText(0.5*width, 0.81*height, Graphics.FONT_TINY, loadResource(Rez.Strings.Start), 5);
        dc.fillRoundedRectangle(0.38*width, 0.28*height, 0.1*width, 0.1*height, 0.023*width);
        dc.fillRoundedRectangle(0.52*width, 0.28*height, 0.1*width, 0.1*height, 0.023*width);

        
        dc.setColor(0x0055AA, Graphics.COLOR_BLACK);
        dc.fillRoundedRectangle(0.38*width, 0.42*height, 0.1*width, 0.1*height, 0.023*width);
    }
}

class TitleDelegate extends WatchUi.BehaviorDelegate {
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    public function onSelect() as Boolean {
        var view = getApp().getHomeMenu();
        pushView(view[0], view[1], SLIDE_LEFT);
        return true;
    }
}