(function($){
  $.fn.cyphtTutorial = function(base, options) {
    return new $.cyphtTutorial(this, base, options);
  };

  $.cyphtTutorial = function(element, base, options) {
    this.base = base;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.cyphtTutorial.fn = $.cyphtTutorial.prototype = {
    cyphtTutorial: '0.1'
  };

  $.cyphtTutorial.fn.extend = $.cyphtTutorial.extend = $.extend;

  $.cyphtTutorial.fn.extend({
    'init': function() {
      this.base.options.content.append(
        $(document.createElement('DIV')).html('TUTORIAL INIT')
      );
      return this;
    },
    'render': function() {
      this.base.render();
      this.base.options.content.append(
        $(document.createElement('DIV')).html('TUTORIAL RENDER')
      );
      return this;
    }
  });
})(jQuery);
