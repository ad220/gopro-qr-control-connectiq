import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class LabsMenuDelegate extends Menu2InputDelegate {

    private var menu as Menu2;
    private var firstItemId as Symbol;

    public function initialize(menu as Menu2) {
        Menu2InputDelegate.initialize();

        self.menu = menu;
        firstItemId = menu.getItem(0).getId() as Symbol;
    }

    public function onSelect(item as MenuItem) as Void {
        var menu = null;
        var id = item.getId();
        if      (firstItemId == :video) {
            if      (id==:video)        { menu = new Rez.Menus.VideoSettings(); }
            else if (id==:protune)      { menu = new Rez.Menus.ProtuneSettings(); }
            else if (id==:extended)     { menu = new Rez.Menus.ExtendedControls(); }
        }
        else if (firstItemId == :resolution) {
            if      (id==:resolution)   { menu = new Rez.Menus.ResolutionPicker(); }
            else if (id==:framerate)    { menu = new Rez.Menus.FrameratePicker(); }
            else if (id==:lens)         { menu = new Rez.Menus.LensPicker(); }
            else if (id==:hypersmooth)  { menu = new Rez.Menus.HypersmoothPicker(); }
            else if (id==:hindsight)    { menu = new Rez.Menus.HindsightPicker(); }
        }
        else if (firstItemId == :audio) {
            if      (id==:audio)        { menu = new Rez.Menus.AudioPicker(); }
            else if (id==:bitrate)      { menu = new Rez.Menus.BitratePicker(); }
            else if (id==:bitdepth)     { menu = new Rez.Menus.BitdepthPicker(); }
            else if (id==:whitebalance) { menu = new Rez.Menus.WBPicker(); }
            else if (id==:color)        { menu = new Rez.Menus.ColorPicker(); }
            else if (id==:sharpness)    { menu = new Rez.Menus.SharpnessPicker(); }
            else if (id==:evcomp)       { menu = new Rez.Menus.EVCompPicker(); }
            else if (id==:evlock)       { menu = new Rez.Menus.EVLockPicker(); }
            else if (id==:isomin)       { menu = new Rez.Menus.ISOPicker(); }
            else if (id==:isomax)       { menu = new Rez.Menus.ISOPicker(); }
            else if (id==:shutterangle) { menu = new Rez.Menus.ShutterAnglePicker(); }
        }
        else if (firstItemId == :camera) {
            if      (id==:camera)       { menu = new Rez.Menus.XCCameraPicker(); }
            else if (id==:video)        { menu = new Rez.Menus.XCVideoPicker(); }
            else if (id==:audio)        { menu = new Rez.Menus.XCAudioPicker(); }
            else if (id==:labs)         { menu = new Rez.Menus.XCLabsPicker(); }
        } 

        if (menu instanceof Menu2) {
            var delegate = firstItemId == :video
                ? new LabsMenuDelegate(menu)
                : new LabsPickerDelegate(menu, firstItemId, self.menu.findItemById(id));
            WatchUi.switchToView(menu, delegate, SLIDE_LEFT);
        }
    }

    public function onBack() as Void {
        if (firstItemId != :video) {
            var menu = new Rez.Menus.QRControlMenu();
            var focus = -1;
            if      (firstItemId == :resolution)    { focus = 0; }
            else if (firstItemId == :audio)         { focus = 1; }
            else if (firstItemId == :camera)        { focus = 2; }
            menu.setFocus(focus);
            WatchUi.switchToView(menu, new LabsMenuDelegate(menu), SLIDE_RIGHT);
        } else {
            Menu2InputDelegate.onBack();
        }
    }
}