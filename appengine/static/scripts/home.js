(function($){
  $.fn.iambleHome = function(base, options) {
    return new $.iambleHome(this, base, options);
  };

  $.iambleHome = function(element, base, options) {
    this.base = base;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iambleHome.fn = $.iambleHome.prototype = {
    iambleHome: '0.1'
  };

  $.iambleHome.fn.extend = $.iambleHome.extend = $.extend;

  $.iambleHome.fn.extend({
    'init': function() {
      return this;
    },
    'render': function() {
      this.base.render();
      return this;
    }
  });
})(jQuery);
