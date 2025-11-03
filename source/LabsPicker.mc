import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class LabsPickerDelegate extends Menu2InputDelegate {

    private var parentMenuId as Object;
    private var parentFocus as Number;

    public function initialize(menu as Menu2, parentMenuId as Object, parentFocus as Number) {
        Menu2InputDelegate.initialize();

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
    }

    public function onSelect(item as MenuItem) as Void {
        
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