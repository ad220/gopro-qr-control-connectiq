import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Graphics;


class NumButton extends WatchUi.Selectable {

    private var value as Number;

    public function initialize(options as Dictionary) {
        Selectable.initialize(options);

        self.value = options.get(:value) as Number;
    }

    public function draw(dc as Dc) as Void {
        Selectable.draw(dc);

        var label = value!= -1 ? value.toString() : "<";
        if (getState() == :stateHighlighted) {
            dc.fillRectangle(locX, locY, width, height);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
            dc.drawText(0.5*width+locX, 0.5*height+locY, Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        } else {
            dc.drawText(0.5*width+locX, 0.5*height+locY, Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    public function getValue() as Number {
        return value;
    }
    
}

class NumInputView extends WatchUi.View {

    private var title as String;
    private var input as Number?;
    (:initialized) private var hilighted as NumButton;
    (:initialized) private var inputLabel as Text;

    public function initialize(title as String, value as String?) {
        View.initialize();

        self.title = title;
        self.input = value==null ? null : value.substring(value.find("=")+1, null).toNumber();
    }

    public function onLayout(dc as Dc) as Void {
        var layout = Rez.Layouts.NumInputLayout(dc);
        setLayout(layout);
        setKeyToSelectableInteraction(true);
        
        inputLabel = findDrawableById("NumLabel") as Text;
        hilighted = findDrawableById("ZeroButton") as NumButton;

        (findDrawableById("NumInputTitle") as Text).setText(title);
        inputLabel.setText(input==null ? Rez.Strings.Unset : input.toString());
    }


    public function addNumber(n as Number) {
        if (n != -1) {
            if (input == null) { input = 0; }
            if (input < 99999) { // max 6 digits
                input = 10*input + n;
                inputLabel.setText(input.toString());
            }
        } else {
            if (input>9) {
                input /= 10;
                inputLabel.setText(input.toString());
            } else {
                input = null;
                inputLabel.setText(Rez.Strings.Unset);
            }
        }
    }

    public function setHilighted(button as NumButton, onSelect as Boolean) {
        if (hilighted != button) {
            hilighted.setState(:stateDefault);
            mKeyToSelectable = (12 - button.getValue()) % 12;
            hilighted = button;
        }
    }

    public function getKey() as String {
        return title;
    }

    public function getInput() as Number? {
        return input;
    }
}

class NumInputDelegate extends WatchUi.BehaviorDelegate {

    private var view as NumInputView;
    
    public function initialize(view as NumInputView) {
        BehaviorDelegate.initialize();

        self.view = view;
    }

    public function onSelectable(selectableEvent as SelectableEvent) as Boolean {
        var button = selectableEvent.getInstance();
        if (button instanceof NumButton) {
            var state = button.getState();
            view.setHilighted(button, state == :stateSelected);
            if (state == :stateSelected) {
                view.addNumber(button.getValue());
                button.setState(selectableEvent.getPreviousState());
            }
        }
        return true;
    }

    public function onBack() as Boolean {
        var key = view.getKey();
        var value = view.getInput();
        if (value == null) {
            getApp().setParam(key, "");
        } else {
            getApp().setParam(key, "*" + key + "=" + value.toString());
        }
        return BehaviorDelegate.onBack();
    }
}