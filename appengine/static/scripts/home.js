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

      var buttons = [
        $(document.createElement('DIV')).text('Coffee'),
        $(document.createElement('DIV')).text('Quick bite'),
        $(document.createElement('DIV')).text('Fine dinning')
      ];

      $(buttons).each(this.bind(function(index, button) {
        this.options.content.append(button);
        button.button();
      }));
      return this;
    },
    'bind': function(funct) {
      var self = this;
      return function() {
        funct.apply(self, arguments);
      };
    }
  });
})(jQuery);
