(function($){
  $.fn.iambleOAuth = function(base, options) {
    return new $.iambleOAuth(this, base, options);
  };

  $.iambleOAuth = function(element, base, options) {
    this.base = base;
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
      return this;
    }
  });
})(jQuery);
