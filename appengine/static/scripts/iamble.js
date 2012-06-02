(function($){
  $.fn.iamble = function(options) {
    return new $.iamble(this, options);
  };

  $.iamble = function(element, options) {
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iamble.fn = $.iamble.prototype = {
    iamble: '0.1'
  };

  $.iamble.fn.extend = $.iamble.extend = $.extend;

  $.iamble.fn.extend({
    'init': function() {

      return this;
    },
    'render': function() {

      return this;
    }
  });
})(jQuery);
