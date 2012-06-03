(function($){
  $.fn.iamble = function(options) {
    return new $.iamble(this, options);
  };

  $.iamble = function(element, options) {
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iamble.fn = $.iamble.prototype = {
    iamble: '0.1'
  };

  $.iamble.fn.extend = $.iamble.extend = $.extend;

  $.iamble.fn.extend({
    'init': function() {

      return this;
    },
    'render': function() {
      this.options.messages.live('.status_message').click(function() {
        $(this).fadeOut();
      });
      return this;
    },
    'message': function(msg, type) {
      var statusMessage = $(document.createElement('DIV'))
        .addClass('status_message')
        .addClass(type)
        .text(msg)
        .hide();

      this.options.messages.fadeOut('fast', function() {
        $(this).empty().show().append(statusMessage);
        statusMessage.fadeIn();
      });
      return this;
    },
    'success': function(msg) {
      return this.message(msg, 'success');
    },
    'info': function(msg) {
      return this.message(msg, 'info');
    },
    'warning': function(msg) {
      return this.message(msg, 'warning');
    },
    'error': function(msg) {
      return this.message(msg, 'error');
    },
    'bind': function(funct) {
      var self = this;
      return function() {
        funct.apply(self, arguments);
      };
    }
  });
})(jQuery);
