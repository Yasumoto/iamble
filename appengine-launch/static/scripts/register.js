(function($){
  $.fn.cyphtRegister = function(base, options) {
    return new $.cyphtRegister(this, base, options);
  };

  $.cyphtRegister = function(element, base, options) {
    this.base = base;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.cyphtRegister.fn = $.cyphtRegister.prototype = {
    cyphtRegister: '0.1'
  };

  $.cyphtRegister.fn.extend = $.cyphtRegister.extend = $.extend;

  $.cyphtRegister.fn.extend({
    'init': function() {
      this.base.options.content.append(
        $(document.createElement('DIV')).html('REGISTER INIT')
      );
      return this;
    },
    'render': function() {
      this.base.render();
      this.base.options.content.append(
        $(document.createElement('DIV')).html('REGISTER RENDER')
      );
      return this;
    }
  });
})(jQuery);
