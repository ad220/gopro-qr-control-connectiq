import Toybox.Lang;
import Toybox.WatchUi;

class QROptionsDelegate extends WatchUi.Menu2InputDelegate {

    private var data as LabsData;

    public function initialize(data as LabsData) {
        Menu2InputDelegate.initialize();

        self.data = data;
    }

    public function onSelect(item as MenuItem) as Void {
        var id = item.getId();
        if (id == :edit) {
            data.matrix = null;
            var menu = new Rez.Menus.LabsMenu();
            switchToView(menu, new LabsMenuDelegate(menu, data), SLIDE_RIGHT);
        }
        else {
            if (id == :save) { data.save(); }
            else { data.discard(); }
            var view = getApp().getInitialView() as Array;
            switchToView(view[0], view[1], SLIDE_RIGHT);
        }
    }

    public function onBack() as Void {
        switchToView(new QRCodeView(data), new BehaviorDelegate(), SLIDE_RIGHT);
    }
}