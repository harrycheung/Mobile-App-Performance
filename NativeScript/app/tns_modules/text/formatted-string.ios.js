var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var formattedStringCommon = require("text/formatted-string-common");
require("utils/module-merge").merge(formattedStringCommon, exports);
var FormattedString = (function (_super) {
    __extends(FormattedString, _super);
    function FormattedString() {
        _super.apply(this, arguments);
    }
    FormattedString.prototype.createFormattedStringCore = function () {
        var mas = NSMutableAttributedString.alloc().init();
        var i;
        var spanStart = 0;
        var spanLength = 0;
        var spanText = "";
        for (i = 0; i < this.spans.length; i++) {
            var span = this.spans.getItem(i);
            spanText = span.text || "";
            spanLength = spanText.length;
            span.updateSpanModifiers(this);
            var attrDict = NSMutableDictionary.alloc().init();
            var p;
            for (p = 0; p < span.spanModifiers.length; p++) {
                attrDict.setObjectForKey(span.spanModifiers[p].value, span.spanModifiers[p].key);
            }
            var nsAttributedString = NSMutableAttributedString.alloc().initWithStringAttributes(spanText, attrDict);
            mas.insertAttributedStringAtIndex(nsAttributedString, spanStart);
            spanStart += spanLength;
        }
        this._formattedText = mas;
    };
    return FormattedString;
})(formattedStringCommon.FormattedString);
exports.FormattedString = FormattedString;
