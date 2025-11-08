import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;


class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var qrcodes as Array<String>;

    public function initialize(menu as Menu2) {
        Menu2InputDelegate.initialize();

        qrcodes = Application.Storage.getValue("qrcodes") as Array?;
        if (qrcodes == null) { qrcodes = []; }

        var newIcon = new Bitmap({
            :rezId => Rez.Drawables.New,
            :locX => LAYOUT_HALIGN_CENTER,
            :locY => LAYOUT_VALIGN_CENTER
        });
        menu.addItem(new IconMenuItem(Rez.Strings.NewQR, null, "new", newIcon, null));

        for (var i=0; i<qrcodes.size(); i++) {
            var label = qrcodes[i].substring(null, null);
            if (label.length()>15) {
                label = label.substring(null, 12) + "...";
            }
            menu.addItem(new MenuItem(label, null, qrcodes[i], null));
        }

        var settingsIcon = new Bitmap({
            :rezId => Rez.Drawables.Settings,
            :locX => LAYOUT_HALIGN_CENTER,
            :locY => LAYOUT_VALIGN_CENTER
        });
        menu.addItem(new IconMenuItem(Rez.Strings.Settings, null, "settings", settingsIcon, null));
    }

    public function onSelect(item as MenuItem) as Void {
        var id = item.getId();
        if (id.equals("new")) {
            var data = new LabsData(null);
            var menu = new Rez.Menus.LabsMenu();
            switchToView(menu, new LabsMenuDelegate(menu, data), SLIDE_LEFT);
        } else if (id.equals("settings")) {
            var menu = new Rez.Menus.AppSettings();
            switchToView(menu, new AppSettings(menu), SLIDE_LEFT);
        } else {
            // TODO: new QRCode View with matrix init
        }
    }
}