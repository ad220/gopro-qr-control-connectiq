import Toybox.Lang;
import Toybox.System;
import Toybox.Application;

class LabsData {

    public var command as String;
    public var params as Dictionary;
    public var matrix as Array<ByteArray>?;

    public function initialize(command as String?) {
        if (command != null) {
            self.command = command;
            self.params = Application.Storage.getValue("paramsOf:"+command);
            self.matrix = [];

            var serializedMatrix = Application.Storage.getValue("matrixOf:"+command) as ByteArray;
            var size = serializedMatrix.size()<625 ? 21 : 25;
            for (var i=0; i<size; i++) {
                matrix.add(serializedMatrix.slice(i*size, (i+1)*size));
            }
        } else {
            self.command = "";
            self.params = {};
            self.matrix = null;
        }
    }

    
    function setParam(key as String, value as String) {
        var prevParam = params.get(key) as String?;
        if (prevParam == null) {
            if (!value.equals("")) {
                params.put(key, value);
                command = command + value;
            }
        } else {
            var index = command.find(prevParam);
            command = command.substring(null, index) + value 
                + command.substring(index + prevParam.length(), null);
            if (value.equals("")) {
                params.remove(key);
            } else {
                params.put(key, value);
            }
        }
    }
}