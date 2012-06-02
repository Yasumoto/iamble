(function($){
  $.fn.iamble = function(o) {
    return new $.iamble(this, o);
  };

  $.iamble = function(e, o) {
    this.options = o || {};
    this.target = $(e);
    return this;
  };

  $.iamble.fn = $.iamble.prototype = {
    iamble: '0.1'
  };

  $.iamble.fn.extend = $.iamble.extend = $.extend;

  $.iamble.fn.extend({
    'init': function() {
      this.target.append(
        $('<DIV>').text('HELLO WORLD!')
      );
      return this;
    }
  });
});
