import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

(:glance)
class AppGlance extends WatchUi.GlanceView {

    private var title as String;

    public function initialize() {
        GlanceView.initialize();

        self.title = loadResource(Rez.Strings.AppName);
    }

    public function onUpdate(dc as Dc) as Void {
        GlanceView.onUpdate(dc);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(0, 0.5*dc.getHeight(), Graphics.FONT_GLANCE, title, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}