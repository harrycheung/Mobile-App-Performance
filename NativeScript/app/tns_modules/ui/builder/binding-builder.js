var expressionSymbolsRegex = /[ \+\-\*%\?:<>=!\|&\(\)\[\]^~]/;
var bindingConstants;
(function (bindingConstants) {
    bindingConstants.sourceProperty = "sourceProperty";
    bindingConstants.targetProperty = "targetProperty";
    bindingConstants.expression = "expression";
    bindingConstants.twoWay = "twoWay";
    bindingConstants.source = "source";
    bindingConstants.bindingValueKey = "$value";
})(bindingConstants = exports.bindingConstants || (exports.bindingConstants = {}));
;
var hasEqualSignRegex = /=+/;
var equalSignComparisionOperatorsRegex = /(==|===|>=|<=|!=|!==)/;
function isNamedParam(value) {
    var equalSignIndex = value.search(hasEqualSignRegex);
    if (equalSignIndex > -1) {
        var equalSignSurround = value.substr(equalSignIndex > 0 ? equalSignIndex - 1 : 0, 3);
        if (equalSignSurround.search(equalSignComparisionOperatorsRegex) === -1) {
            return true;
        }
    }
    return false;
}
function areNamedParams(params) {
    var i;
    for (i = 0; i < params.length; i++) {
        if (isNamedParam(params[i])) {
            return true;
        }
    }
    return false;
}
var namedParamConstants = {
    propName: "propName",
    propValue: "propValue"
};
function getPropertyNameValuePair(param, knownOptions, callback) {
    var nameValuePair = {};
    var propertyName = param.substr(0, param.indexOf("=")).trim();
    var propertyValue = param.substr(param.indexOf("=") + 1).trim();
    if (knownOptions) {
        if (!propertyName) {
            propertyName = knownOptions.defaultProperty;
        }
        else {
            propertyName = propertyName in knownOptions ? propertyName : null;
        }
    }
    if (propertyName) {
        if (callback) {
            nameValuePair = callback(propertyName, propertyValue);
        }
        else {
            nameValuePair[namedParamConstants.propName] = propertyName;
            nameValuePair[namedParamConstants.propValue] = propertyValue;
        }
        return nameValuePair;
    }
    return null;
}
function parseNamedProperties(parameterList, knownOptions, callback) {
    var result = {};
    var i;
    for (i = 0; i < parameterList.length; i++) {
        var nameValuePair = getPropertyNameValuePair(parameterList[i], knownOptions, callback);
        if (nameValuePair) {
            result[nameValuePair[namedParamConstants.propName]] = nameValuePair[namedParamConstants.propValue];
        }
    }
    return result;
}
function extractPropertyNameFromExpression(expression) {
    var firstExpressionSymbolIndex = expression.search(expressionSymbolsRegex);
    if (firstExpressionSymbolIndex > -1) {
        var sourceProp = expression.substr(0, firstExpressionSymbolIndex).trim();
        return sourceProp;
    }
    else {
        return expression;
    }
}
function getBindingOptions(name, value) {
    var namedParams = [];
    var params = value.split(",");
    if (!areNamedParams(params)) {
        if (params.length === 1) {
            namedParams.push(bindingConstants.sourceProperty + " = " + extractPropertyNameFromExpression(params[0].trim()));
            var expression = params[0].search(expressionSymbolsRegex) > -1 ? params[0].trim() : null;
            if (expression) {
                namedParams.push(bindingConstants.expression + " = " + expression);
            }
            namedParams.push(bindingConstants.twoWay + " = true");
        }
        else {
            namedParams.push(bindingConstants.sourceProperty + " = " + extractPropertyNameFromExpression(params[0].trim()));
            namedParams.push(bindingConstants.expression + " = " + params[1].trim());
            var twoWay = params[2] ? params[2].toLowerCase().trim() === "true" : true;
            namedParams.push(bindingConstants.twoWay + " = " + twoWay);
        }
    }
    else {
        namedParams = params;
    }
    var bindingPropertyHandler = function (prop, value) {
        var result = {};
        result[namedParamConstants.propName] = prop;
        if (prop === bindingConstants.twoWay) {
            if (value === "true") {
                result[namedParamConstants.propValue] = true;
            }
            else {
                result[namedParamConstants.propValue] = false;
            }
        }
        else {
            result[namedParamConstants.propValue] = value;
        }
        return result;
    };
    var bindingOptionsParameters = parseNamedProperties(namedParams, xmlBindingProperties, bindingPropertyHandler);
    var bindOptions = {
        targetProperty: name
    };
    for (var prop in bindingOptionsParameters) {
        if (bindingOptionsParameters.hasOwnProperty(prop)) {
            bindOptions[prop] = bindingOptionsParameters[prop];
        }
    }
    if (bindOptions[bindingConstants.twoWay] === undefined) {
        bindOptions[bindingConstants.twoWay] = true;
    }
    return bindOptions;
}
exports.getBindingOptions = getBindingOptions;
var xmlBindingProperties = {
    sourceProperty: true,
    expression: true,
    twoWay: true,
    source: true,
    defaultProperty: bindingConstants.sourceProperty
};
