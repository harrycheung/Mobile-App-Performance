/**
 * iOS specific http request implementation.
 */
var imageSource = require("image-source");
var types = require("utils/types");
var GET = "GET";
var USER_AGENT_HEADER = "User-Agent";
var USER_AGENT = "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25";
function request(options) {
    return new Promise(function (resolve, reject) {
        try {
            var sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration();
            var queue = NSOperationQueue.mainQueue();
            var session = NSURLSession.sessionWithConfigurationDelegateDelegateQueue(sessionConfig, null, queue);
            var urlRequest = NSMutableURLRequest.requestWithURL(NSURL.URLWithString(options.url));
            urlRequest.HTTPMethod = types.isDefined(options.method) ? options.method : GET;
            urlRequest.setValueForHTTPHeaderField(USER_AGENT, USER_AGENT_HEADER);
            if (options.headers) {
                for (var header in options.headers) {
                    urlRequest.setValueForHTTPHeaderField(options.headers[header] + "", header);
                }
            }
            if (types.isString(options.content)) {
                urlRequest.HTTPBody = NSString.alloc().initWithString(options.content).dataUsingEncoding(4);
            }
            if (types.isNumber(options.timeout)) {
                urlRequest.timeoutInterval = options.timeout / 1000;
            }
            var dataTask = session.dataTaskWithRequestCompletionHandler(urlRequest, function (data, response, error) {
                if (error) {
                    reject(new Error(error.localizedDescription));
                }
                else {
                    var headers = {};
                    var headerFields = response.allHeaderFields;
                    var keys = headerFields.allKeys;
                    for (var i = 0, l = keys.count; i < l; i++) {
                        var key = keys.objectAtIndex(i);
                        headers[key] = headerFields.valueForKey(key);
                    }
                    resolve({
                        content: {
                            raw: data,
                            toString: function () { return NSDataToString(data); },
                            toJSON: function () { return JSON.parse(NSDataToString(data)); },
                            toImage: function () {
                                return new Promise(function (resolveImage, reject) {
                                    resolveImage(imageSource.fromData(data));
                                });
                            }
                        },
                        statusCode: response.statusCode,
                        headers: headers
                    });
                }
            });
            dataTask.resume();
        }
        catch (ex) {
            reject(ex);
        }
    });
}
exports.request = request;
function NSDataToString(data) {
    return NSString.alloc().initWithDataEncoding(data, 4).toString();
}
