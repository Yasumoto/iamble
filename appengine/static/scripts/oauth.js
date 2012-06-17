(function($){
  $.fn.cyphtOAuth = function(base, options) {
    return new $.cyphtOAuth(this, base, options);
  };

  $.cyphtOAuth = function(element, base, options) {
    this.base = base;
    this.bind = this.base.bind;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.cyphtOAuth.fn = $.cyphtOAuth.prototype = {
    cyphtOAuth: '0.1'
  };

  $.cyphtOAuth.fn.extend = $.cyphtOAuth.extend = $.extend;

  $.cyphtOAuth.fn.extend({
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
