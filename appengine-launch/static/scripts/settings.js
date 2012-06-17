(function($){
  $.fn.cyphtSettings = function(base, options) {
    return new $.cyphtSettings(this, base, options);
  };

  $.cyphtSettings = function(element, base, options) {
    this.base = base;
    this.bind = this.base.bind;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.cyphtSettings.fn = $.cyphtSettings.prototype = {
    cyphtSettings: '0.1'
  };

  $.cyphtSettings.fn.extend = $.cyphtSettings.extend = $.extend;

  $.cyphtSettings.fn.extend({
    'init': function() {
      return this;
    },
    'render': function() {
      this.base.render();
      this.options.distance.buttonset();
      this.options.save.button();

      navigator.geolocation.getCurrentPosition(this.bind(this.onPosition));

      return this;
    },
    'onPosition': function(position) {
      this.options.longitude.val(position.coords.longitude);
      this.options.latitude.val(position.coords.latitude);
    }
  });
})(jQuery);
