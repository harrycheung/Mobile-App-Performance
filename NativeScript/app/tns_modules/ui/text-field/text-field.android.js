var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var common = require("ui/text-field/text-field-common");
function onSecurePropertyChanged(data) {
    var textField = data.object;
    if (!textField.android) {
        return;
    }
    var currentInputType = textField.android.getInputType();
    var currentClass = currentInputType & android.text.InputType.TYPE_MASK_CLASS;
    var currentFlags = currentInputType & android.text.InputType.TYPE_MASK_FLAGS;
    var newInputType = currentInputType;
    if (data.newValue) {
        if (currentClass === android.text.InputType.TYPE_CLASS_TEXT) {
            newInputType = currentClass | currentFlags | android.text.InputType.TYPE_TEXT_VARIATION_PASSWORD;
        }
        else if (currentClass === android.text.InputType.TYPE_CLASS_NUMBER) {
            newInputType = currentClass | currentFlags | android.text.InputType.TYPE_NUMBER_VARIATION_PASSWORD;
        }
        newInputType = newInputType & ~28762;
    }
    else {
        if (currentClass === android.text.InputType.TYPE_CLASS_TEXT) {
            newInputType = currentClass | currentFlags | android.text.InputType.TYPE_TEXT_VARIATION_NORMAL;
        }
        else if (currentClass === android.text.InputType.TYPE_CLASS_NUMBER) {
            newInputType = currentClass | currentFlags | android.text.InputType.TYPE_NUMBER_VARIATION_NORMAL;
        }
    }
    textField.android.setInputType(newInputType);
}
common.secureProperty.metadata.onSetNativeValue = onSecurePropertyChanged;
require("utils/module-merge").merge(common, exports);
var TextField = (function (_super) {
    __extends(TextField, _super);
    function TextField() {
        _super.apply(this, arguments);
    }
    TextField.prototype._configureEditText = function () {
        this.android.setInputType(android.text.InputType.TYPE_CLASS_TEXT | android.text.InputType.TYPE_TEXT_VARIATION_NORMAL | android.text.InputType.TYPE_TEXT_FLAG_CAP_SENTENCES);
        this.android.setLines(1);
        this.android.setMaxLines(1);
        this.android.setHorizontallyScrolling(true);
    };
    return TextField;
})(common.TextField);
exports.TextField = TextField;
