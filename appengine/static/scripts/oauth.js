(function($){
  $.fn.iambleOAuth = function(base, options) {
    return new $.iambleOAuth(this, base, options);
  };

  $.iambleOAuth = function(element, base, options) {
    this.base = base;
    this.bind = this.base.bind;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iambleOAuth.fn = $.iambleOAuth.prototype = {
    iambleOAuth: '0.1'
  };

  $.iambleOAuth.fn.extend = $.iambleOAuth.extend = $.extend;

  $.iambleOAuth.fn.extend({
    'init': function() {
      return this;
    },
    'render': function() {
      this.base.render();
      if (typeof(this.options.continue) != 'undefined') {
        this.options.continue.button().click(this.bind(this.onContinue));
      }
      return this;
    },
    'onContinue' : function() {
      window.location = '/settings';
    }
  });
})(jQuery);
