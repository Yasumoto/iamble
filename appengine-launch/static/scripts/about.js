(function($){
  $.fn.iambleAbout = function(base, options) {
    return new $.iambleAbout(this, base, options);
  };

  $.iambleAbout = function(element, base, options) {
    this.base = base;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iambleAbout.fn = $.iambleAbout.prototype = {
    iambleAbout: '0.1'
  };

  $.iambleAbout.fn.extend = $.iambleAbout.extend = $.extend;

  $.iambleAbout.fn.extend({
    'init': function() {
      this.base.options.content.append(
        $(document.createElement('DIV')).html('ABOUT INIT')
      );
      return this;
    },
    'render': function() {
      this.base.render();
      this.base.options.content.append(
        $(document.createElement('DIV')).html('ABOUT RENDER')
      );
      return this;
    }
  });
})(jQuery);
