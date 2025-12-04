import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class LabsPickerDelegate extends Menu2InputDelegate {

    private var data as LabsData;
    private var key as String;
    private var parentMenuId as Object;
    private var parentFocus as Number;

    public function initialize(
        menu as Menu2,
        data as LabsData,
        key as String,
        parentMenuId as Object,
        parentFocus as Number
    ) {
        Menu2InputDelegate.initialize();

        self.data = data;
        self.key = key;
        self.parentMenuId = parentMenuId;
        self.parentFocus = parentFocus;

        // Replace each item's id with its labs value,
        // add the unset item at the beginning of the menu,
        // and shift once every item to the menu's end.
        var i=0;
        var newItem = new MenuItem(Rez.Strings.Unset, null, "", null);
        var shiftItem = menu.getItem(i);
        while (shiftItem != null) {
            menu.updateItem(newItem, i);
            var id = shiftItem.getSubLabel();
            if (id==null) { id = shiftItem.getLabel(); }
            newItem = new MenuItem(shiftItem.getLabel(), null, id, null);
            
            i++;
            shiftItem = menu.getItem(i);
        }
        menu.addItem(newItem);

        if (parentMenuId == :camera) {
            menu.deleteItem(0);
        }

        var value = data.params.get(key);
        if (value != null) {
            menu.setFocus(menu.findItemById(value));
        }
    }

    public function onSelect(item as MenuItem) as Void {
        if (parentMenuId != :camera) {
            data.setParam(key, item.getId() as String);
            onBack();
        } else {
            var key = item.getId() as String;
            var value = data.params.get(key);
            var view = new NumInputView(key, value);
            pushView(view, new NumInputDelegate(view, data), SLIDE_DOWN);
        }
    }

    public function onBack() as Void {
        var menu = null;
        if      (parentMenuId == :resolution)   { menu = new Rez.Menus.VideoSettings(); }
        else if (parentMenuId == :audio)        { menu = new Rez.Menus.ProtuneSettings(); }
        else if (parentMenuId == :camera)       { menu = new Rez.Menus.ExtendedControls(); }
        
        if (menu instanceof Menu2) {
            menu.setFocus(parentFocus);
            WatchUi.switchToView(menu, new LabsMenuDelegate(menu, data), SLIDE_RIGHT);
        }
    }
}