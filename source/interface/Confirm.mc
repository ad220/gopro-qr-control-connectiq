import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class ConfirmView extends WatchUi.View {

    private var msgId as ResourceId;

    public function initialize(msgId as ResourceId) {
        View.initialize();

        self.msgId = msgId;
    }

    public function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.ConfirmLayout(dc));
        (findDrawableById("ConfirmMessage") as Text).setText(msgId);
    }
}

class ConfirmDelegate extends WatchUi.BehaviorDelegate {

    private var callback as Null or Method() as Void;

    public function initialize(callback as Null or Method() as Void) {
        BehaviorDelegate.initialize();

        self.callback = callback;
    }

    public function onBack() as Boolean {
        WatchUi.popView(SLIDE_UP);
        return true;
    }

    public function onSelect() as Boolean {
        WatchUi.popView(SLIDE_UP);
        if (callback!=null) { callback.invoke(); }
        return true;
    }
}