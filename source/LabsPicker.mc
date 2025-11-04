import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class LabsPickerDelegate extends Menu2InputDelegate {

    private var key as String;
    private var parentMenuId as Object;
    private var parentFocus as Number;

    public function initialize(
        menu as Menu2,
        key as String,
        parentMenuId as Object,
        parentFocus as Number
    ) {

        Menu2InputDelegate.initialize();

        self.key = key;
        self.parentMenuId = parentMenuId;
        self.parentFocus = parentFocus;

        var i=0;
        var item = menu.getItem(i);
        while (item!=null) {
            var id = item.getSubLabel();
            if (id==null) { id = item.getLabel(); }
            item.initialize(item.getLabel(), null, id, {});
            menu.updateItem(item, i);

            i++;
            item = menu.getItem(i);
        }

        var focus = menu.findItemById(getApp().qrParams.get(key));
        menu.setFocus(focus);
    }

    public function onSelect(item as MenuItem) as Void {
        if (parentMenuId != :camera) {

            var app = getApp();
            var id = item.getId();
            var prevParam = app.qrParams.get(key) as String?;

            if (prevParam == null) {
                app.qrParams.put(key, id);
                app.qrCommand = app.qrCommand + id;
            } else {
                var index = app.qrCommand.find(prevParam);
                app.qrCommand = app.qrCommand.substring(null, index) + id 
                    + app.qrCommand.substring(index + prevParam.length(), null);
            }

            onBack();
        }
    }

    public function onBack() as Void {
        var menu = null;
        if      (parentMenuId == :resolution)   { menu = new Rez.Menus.VideoSettings(); }
        else if (parentMenuId == :audio)        { menu = new Rez.Menus.ProtuneSettings(); }
        else if (parentMenuId == :camera)       { menu = new Rez.Menus.ExtendedControls(); }
        menu.setFocus(parentFocus);
        
        if (menu instanceof Menu2) {
            WatchUi.switchToView(menu, new LabsMenuDelegate(menu), SLIDE_RIGHT);
        }
    }
}