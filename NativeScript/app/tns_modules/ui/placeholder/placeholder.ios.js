var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var common = require("ui/placeholder/placeholder-common");
require("utils/module-merge").merge(common, exports);
var Placeholder = (function (_super) {
    __extends(Placeholder, _super);
    function Placeholder() {
        _super.apply(this, arguments);
    }
    Object.defineProperty(Placeholder.prototype, "ios", {
        get: function () {
            if (!this._ios) {
                console.trace();
                var args = { eventName: common.Placeholder.creatingViewEvent, object: this, view: undefined, context: undefined };
                _super.prototype.notify.call(this, args);
                this._ios = args.view;
            }
            return this._ios;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(Placeholder.prototype, "_nativeView", {
        get: function () {
            return this.ios;
        },
        enumerable: true,
        configurable: true
    });
    return Placeholder;
})(common.Placeholder);
exports.Placeholder = Placeholder;
