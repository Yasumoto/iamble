(function($){
  $.fn.iambleLanding = function(base, options) {
    return new $.iambleLanding(this, base, options);
  };

  $.iambleLanding = function(element, base, options) {
    this.base = base;

    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iambleLanding.fn = $.iambleLanding.prototype = {
    iambleLanding: '0.1'
  };

  $.iambleLanding.fn.extend = $.iambleLanding.extend = $.extend;

  $.iambleLanding.fn.extend({
    'init': function() {
      return this;
    },
    'render': function() {
      this.base.render();

      return this;
    }
  });
})(jQuery);
