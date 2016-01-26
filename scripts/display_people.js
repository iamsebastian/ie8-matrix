var areasToDefine = 10;
var dotMax = 0;
var dotMin = 0;
var dotAreas = [];

var showInner = function() {
  var matrixDotElem = $(this);
  var val = matrixDotElem.text() || '0';
  $('.display-count .count-value').text(val);
};

var addHoverListeners = function() {
  $('.matrixdot').hover(showInner);
};

var addMatrixClasses = function() {
  $('.matrixdot').each(function() {
    var arrIsIterated = false;
    var className;
    var dotElem = $(this);
    var dotElemValue = parseInt(dotElem.text(), 10);
    var elemIsBelow = false;
    var i = 0;

    while(i < dotAreas.length) {
      elemIsBelow = dotElemValue < dotAreas[i];
      arrIsIterated = i + 1 >= dotAreas.length;

      if (elemIsBelow || arrIsIterated) {
        className = i > 0 ?
          'op-' + i + '0' :
          'op-0';

        dotElem.addClass(className);
        break;
      }
      i++;
    }
  });
};

var setDotsValues = function() {
  var area = 0;
  var i = 0;
  var dotsValues = $('.matrixdot').map(function() {
    return parseInt($(this).text(), 10);
  });

  dotMax = Math.max.apply(Math, dotsValues);

  while (i++ < areasToDefine) {
    area = Math.floor(dotMax / areasToDefine * i);
    dotAreas.push(area);
  }
};

var displayMaxEntry = function() {
  $('.display-count .max-value').text(dotMax);
};

$(document).ready(setDotsValues);
$(document).ready(addHoverListeners);
$(document).ready(addMatrixClasses);
$(document).ready(displayMaxEntry);
