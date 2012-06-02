(function($){
  $.fn.iambleCreateLogic = function(base, options) {
    return new $.iambleCreateAccount(this, base, options);
  };

  $.iambleCreateAccount = function(element, base, options) {
    this.base = base;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iambleCreateAccount.fn = $.iambleCreateAccount.prototype = {
    iambleLogin: '0.1'
  };

  $.iambleCreateAccount.fn.extend = $.iambleCreateAccount.extend = $.extend;

  $.iambleLogin.fn.extend({
    'init': function() {
      this.base.options.content.append(
        $(document.createElement('DIV')).html('CREATE ACCOUNT INIT')
      );
      return this;
    },
    'render': function() {
      this.base.render();
      this.base.options.content.append(
        $(document.createElement('DIV')).html('CREATE ACCOUNT RENDER')
      );
      return this;
    }
  });
})(jQuery);
