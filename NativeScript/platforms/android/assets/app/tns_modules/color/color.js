var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var common = require("color/color-common");
var Color = (function (_super) {
    __extends(Color, _super);
    function Color() {
        _super.apply(this, arguments);
    }
    Object.defineProperty(Color.prototype, "android", {
        get: function () {
            return this.argb;
        },
        enumerable: true,
        configurable: true
    });
    Color.prototype._argbFromString = function (hex) {
        return android.graphics.Color.parseColor(hex);
    };
    return Color;
})(common.Color);
exports.Color = Color;
