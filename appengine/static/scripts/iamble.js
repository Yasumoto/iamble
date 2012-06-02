(function($){
  $.fn.iamble = function(o) {
    return new $.iamble(this, o);
  };

  $.iamble = function(e, o) {
    this.options = o || {};
    this.target = $(e);
    return this.init();
  };

  $.iamble.fn = $.iamble.prototype = {
    iamble: '0.1'
  };

  $.iamble.fn.extend = $.iamble.extend = $.extend;

  $.iamble.fn.extend({
    'init': function() {
      this.options.content.append(
        $(document.createElement('DIV')).html('INIT')
      );
      return this;
    },
    'render': function() {
      this.options.content.append(
        $(document.createElement('DIV')).html('RENDER')
      );
      return this;
    }
  });
})(jQuery);
