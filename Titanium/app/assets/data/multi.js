var file = Titanium.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, 'data', 'multi_lap_session.csv');
var contents = file.read().text;

if (typeof exports !== 'undefined' && typeof module !== 'undefined' && module.exports) {
  exports = module.exports = contents;
}
