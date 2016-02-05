var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var common = require("ui/progress/progress-common");
function onValuePropertyChanged(data) {
    var progress = data.object;
    if (!progress.android) {
        return;
    }
    progress.android.setProgress(data.newValue);
}
function onMaxValuePropertyChanged(data) {
    var progress = data.object;
    if (!progress.android) {
        return;
    }
    progress.android.setMax(data.newValue);
}
common.Progress.valueProperty.metadata.onSetNativeValue = onValuePropertyChanged;
common.Progress.maxValueProperty.metadata.onSetNativeValue = onMaxValuePropertyChanged;
require("utils/module-merge").merge(common, exports);
var Progress = (function (_super) {
    __extends(Progress, _super);
    function Progress() {
        _super.apply(this, arguments);
    }
    Progress.prototype._createUI = function () {
        this._android = new android.widget.ProgressBar(this._context, null, android.R.attr.progressBarStyleHorizontal);
    };
    Object.defineProperty(Progress.prototype, "android", {
        get: function () {
            return this._android;
        },
        enumerable: true,
        configurable: true
    });
    return Progress;
})(common.Progress);
exports.Progress = Progress;
