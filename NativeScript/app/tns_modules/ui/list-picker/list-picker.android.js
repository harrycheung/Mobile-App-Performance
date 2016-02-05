var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var common = require("ui/list-picker/list-picker-common");
var types = require("utils/types");
require("utils/module-merge").merge(common, exports);
var ListPicker = (function (_super) {
    __extends(ListPicker, _super);
    function ListPicker() {
        _super.call(this);
    }
    Object.defineProperty(ListPicker.prototype, "android", {
        get: function () {
            return this._android;
        },
        enumerable: true,
        configurable: true
    });
    ListPicker.prototype._createUI = function () {
        this._android = new android.widget.NumberPicker(this._context);
        this._android.setDescendantFocusability(android.widget.NumberPicker.FOCUS_BLOCK_DESCENDANTS);
        this._android.setMinValue(0);
        this._android.setMaxValue(0);
        this._android.setValue(0);
        var that = new WeakRef(this);
        this._formatter = new android.widget.NumberPicker.Formatter({
            get owner() {
                return that.get();
            },
            format: function (index) {
                if (this.owner) {
                    return this.owner._getItemAsString(index);
                }
                return " ";
            }
        });
        this._android.setFormatter(this._formatter);
        this._valueChangedListener = new android.widget.NumberPicker.OnValueChangeListener({
            get owner() {
                return that.get();
            },
            onValueChange: function (picker, oldVal, newVal) {
                if (this.owner) {
                    this.owner._onPropertyChangedFromNative(common.ListPicker.selectedIndexProperty, newVal);
                }
            }
        });
        this._android.setOnValueChangedListener(this._valueChangedListener);
        var mInputTextField = java.lang.Class.forName("android.widget.NumberPicker").getDeclaredField("mInputText");
        mInputTextField.setAccessible(true);
        this._editText = mInputTextField.get(this._android);
        this._editText.setFilters([]);
        this._editText.setText(" ", android.widget.TextView.BufferType.NORMAL);
    };
    ListPicker.prototype._onSelectedIndexPropertyChanged = function (data) {
        _super.prototype._onSelectedIndexPropertyChanged.call(this, data);
        if (this.android && types.isNumber(data.newValue)) {
            this.android.setValue(data.newValue);
        }
    };
    ListPicker.prototype._onItemsPropertyChanged = function (data) {
        if (this.android) {
            if (!data.newValue || !data.newValue.length) {
                this.android.setMaxValue(0);
            }
            else {
                this.android.setMaxValue(data.newValue.length - 1);
            }
            this.android.setWrapSelectorWheel(false);
        }
        this._updateSelectedIndexOnItemsPropertyChanged(data.newValue);
        this._fixNumberPickerRendering();
    };
    ListPicker.prototype._fixNumberPickerRendering = function () {
        if (!this.android) {
            return;
        }
        this.android.setFormatter(null);
        this.android.setFormatter(this._formatter);
        if (this._editText) {
            this._editText.setFilters([]);
        }
        this._editText.invalidate();
        this.android.invalidate();
    };
    return ListPicker;
})(common.ListPicker);
exports.ListPicker = ListPicker;
