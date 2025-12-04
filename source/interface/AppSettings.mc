import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;

class AppSettings extends WatchUi.Menu2InputDelegate {

    (:initialized) private static var settings as Dictionary<String,Boolean>;

    public static function init() as Void {
        var result = Application.Storage.getValue("settings") as Dictionary<String, Boolean>?;
        var def = Application.loadResource(Rez.JsonData.DefaultSettings) as Dictionary<String, Boolean>;
        if (result == null) {
            result = def;
        } else if (result.get("version") as Number < def.get("version") as Number) {
            var keys = result.keys();
            for (var i=0; i<keys.size(); i++) {
                if (keys[i] != "version" and def.hasKey(keys[i])) {
                    def.put(keys[i], result.get(keys[i]) as Boolean);
                }
            }
            result = def;
        }
        settings = result;
    }

    public static function get(key as String?) as Boolean {
        if (key == null) { return false; }

        var result = settings.get(key);
        if (result == null) {
            System.println("Unknown setting key");
            return false;
        }
        return result;
    }


    public function initialize(menu as Menu2) {
        Menu2InputDelegate.initialize();
        
        var i = 0; 
        var item = menu.getItem(i) as ToggleMenuItem?;
        while (item != null) {
            var id = item.getSubLabel() as String;
            item.initialize(item.getLabel(), null, id, settings.get(id) as Boolean, null);
            menu.updateItem(item, i);

            i++;
            item = menu.getItem(i);
        }
    }

    public function onSelect(item as MenuItem) as Void {
        if (item instanceof ToggleMenuItem) {
            settings.put(item.getId() as String, item.isEnabled());
        }
    }

    public function onBack() as Void {
        Application.Storage.setValue("settings", settings);
        getApp().returnHome();
    }

}