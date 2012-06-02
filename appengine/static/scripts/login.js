(function($){
  $.fn.iambleLogin = function(base, options) {
    return new $.iambleLogin(this, base, options);
  };

  $.iambleLogin = function(element, base, options) {
    this.base = base;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iambleLogin.fn = $.iambleLogin.prototype = {
    iambleLogin: '0.1'
  };

  $.iambleLogin.fn.extend = $.iambleLogin.extend = $.extend;

  $.iambleLogin.fn.extend({
    'init': function() {
      this.base.options.content.append(
        $(document.createElement('DIV')).html('LOGIN INIT')
      );
      return this;
    },
    'render': function() {
      this.base.render();
      this.base.options.content.append(
        $(document.createElement('DIV')).html('LOGIN RENDER')
      );
      return this;
    }
  });
})(jQuery);
