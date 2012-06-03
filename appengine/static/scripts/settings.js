(function($){
  $.fn.iambleSettings = function(base, options) {
    return new $.iambleSettings(this, base, options);
  };

  $.iambleSettings = function(element, base, options) {
    this.base = base;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iambleSettings.fn = $.iambleSettings.prototype = {
    iambleSettings: '0.1'
  };

  $.iambleSettings.fn.extend = $.iambleSettings.extend = $.extend;

  $.iambleSettings.fn.extend({
    'init': function() {
      return this;
    },
    'render': function() {
      this.base.render();
      this.options.distance.buttonset();
      this.options.save.button();
      return this;
    }
  });
})(jQuery);
