(function($){
  $.fn.iambleRegister = function(base, options) {
    return new $.iambleRegister(this, base, options);
  };

  $.iambleRegister = function(element, base, options) {
    this.base = base;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iambleRegister.fn = $.iambleRegister.prototype = {
    iambleRegister: '0.1'
  };

  $.iambleRegister.fn.extend = $.iambleRegister.extend = $.extend;

  $.iambleRegister.fn.extend({
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
