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
      this.base.options.content.append(
        $(document.createElement('DIV')).html('HOME INIT')
      );
      return this;
    },
    'render': function() {
      this.base.render();
      this.base.options.content.append(
        $(document.createElement('DIV')).html('HOME RENDER')
      );
      return this;
    }
  });
})(jQuery);
