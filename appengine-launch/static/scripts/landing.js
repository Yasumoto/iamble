(function($){
  $.fn.cyphtLanding = function(base, options) {
    return new $.cyphtLanding(this, base, options);
  };

  $.cyphtLanding = function(element, base, options) {
    this.base = base;

    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.cyphtLanding.fn = $.cyphtLanding.prototype = {
    cyphtLanding: '0.1'
  };

  $.cyphtLanding.fn.extend = $.cyphtLanding.extend = $.extend;

  $.cyphtLanding.fn.extend({
    'init': function() {
      return this;
    },
    'render': function() {
      this.base.render();

      return this;
    }
  });
})(jQuery);
