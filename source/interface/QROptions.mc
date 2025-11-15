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
        else if (id == :save) {
            data.save();
            getApp().returnHome();
        }
        else if (id == :discard) {
            pushView(
                new ConfirmView(Rez.Strings.ConfirmDiscard),
                new ConfirmDelegate(method(:discard)),
                SLIDE_DOWN
            );
        }
    }

    public function discard() as Void {
        data.discard();
        getApp().returnHome();
    }

    public function onBack() as Void {
        var view = new QRCodeView(data);
        switchToView(view, new QRCodeDelegate(view), SLIDE_RIGHT);
    }
}