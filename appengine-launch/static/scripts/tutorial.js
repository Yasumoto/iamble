(function($){
  $.fn.iambleTutorial = function(base, options) {
    return new $.iambleTutorial(this, base, options);
  };

  $.iambleTutorial = function(element, base, options) {
    this.base = base;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iambleTutorial.fn = $.iambleTutorial.prototype = {
    iambleTutorial: '0.1'
  };

  $.iambleTutorial.fn.extend = $.iambleTutorial.extend = $.extend;

  $.iambleTutorial.fn.extend({
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
