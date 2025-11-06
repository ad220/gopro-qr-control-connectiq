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

        // Replace each item's id with its labs value,
        // add the unset item at the beginning of the menu,
        // and shift once every item to the menu's end.
        var i=0;
        var newItem = new MenuItem(Rez.Strings.Unset, null, "", {});
        var shiftItem = menu.getItem(i);
        while (shiftItem != null) {
            menu.updateItem(newItem, i);
            var id = shiftItem.getSubLabel();
            if (id==null) { id = shiftItem.getLabel(); }
            newItem = new MenuItem(shiftItem.getLabel(), null, id, {});
            
            i++;
            shiftItem = menu.getItem(i);
        }
        menu.addItem(newItem);

        if (parentMenuId == :camera) {
            menu.deleteItem(0);
        }

        var focus = menu.findItemById(getApp().qrParams.get(key));
        menu.setFocus(focus);
    }

    public function onSelect(item as MenuItem) as Void {
        if (parentMenuId != :camera) {
            getApp().setParam(key, item.getId() as String);
            onBack();
        } else {
            var key = item.getId() as String;
            var value = getApp().qrParams.get(key);
            var view = new NumInputView(key, value);
            pushView(view, new NumInputDelegate(view), SLIDE_DOWN);
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