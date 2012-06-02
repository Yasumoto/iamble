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
      this.options.content.append(
        $(document.createElement('DIV')).html('IAMBLE INIT')
      );
      return this;
    },
    'render': function() {
      this.options.content.append(
        $(document.createElement('DIV')).html('IAMBLE RENDER')
      );
      return this;
    }
  });
})(jQuery);
