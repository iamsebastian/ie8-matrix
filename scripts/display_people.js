var showInner = function() {
  var matrixDotElem = $(this);
  var val = matrixDotElem.text() || '0';
  $('.display-count .count-value').text(val);
};

var addListeners = function() {
  $('.matrixdot').hover(showInner);
};

$(document).ready(addListeners);

//$(document).ready(function() {
  //$('.display-count').text('fooo');
//});
