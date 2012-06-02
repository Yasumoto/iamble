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
      this.base.options.content.append(
        $(document.createElement('DIV')).html('SETTINGS INIT')
      );
      return this;
    },
    'render': function() {
      this.base.render();
      this.base.options.content.append(
        $(document.createElement('DIV')).html('SETTINGS RENDER')
      );
      return this;
    }
  });
})(jQuery);
