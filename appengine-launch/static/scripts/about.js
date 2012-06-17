(function($){
  $.fn.cyphtAbout = function(base, options) {
    return new $.cyphtAbout(this, base, options);
  };

  $.cyphtAbout = function(element, base, options) {
    this.base = base;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.cyphtAbout.fn = $.cyphtAbout.prototype = {
    cyphtAbout: '0.1'
  };

  $.cyphtAbout.fn.extend = $.cyphtAbout.extend = $.extend;

  $.cyphtAbout.fn.extend({
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
