import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;

class AppSettings extends WatchUi.Menu2InputDelegate {

    (:initialized) private static var settings as Dictionary;

    public static function init() {
        settings = Application.Storage.getValue("settings") as Dictionary?;
        var def = Application.loadResource(Rez.JsonData.DefaultSettings) as Dictionary;
        if (settings == null) {
            settings = def;
        } else if (settings.get("version") as Number < def.get("version") as Number) {
            var keys = settings.keys();
            for (var i=0; i<keys.size(); i++) {
                if (keys[i] != "version" and def.hasKey(keys[i])) {
                    def.put(keys[i], settings.get(keys[i]));
                }
            }
            settings = def;
        }
    }

    public static function get(key as String) {
        return settings.get(key);
    }


    public function initialize(menu as Menu2) {
        Menu2InputDelegate.initialize();
        
        var i = 0; 
        var item = menu.getItem(i) as ToggleMenuItem?;
        while (item != null) {
            var id = item.getSubLabel();
            item.initialize(item.getLabel(), null, id, settings.get(id) as Boolean, null);
            menu.updateItem(item, i);

            i++;
            item = menu.getItem(i);
        }
    }

    public function onSelect(item as MenuItem) as Void {
        if (item instanceof ToggleMenuItem) {
            settings.put(item.getId(), item.isEnabled());
        }
    }

    public function onBack() as Void {
        Application.Storage.setValue("settings", settings);
        getApp().returnHome();
    }

}