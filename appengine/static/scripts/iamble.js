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
    'getCookie': function(key) {
      var pairs = document.cookie.split('; ');
      for (var i = 0, pair; pair = pairs[i] && pairs[i].split('='); i++) {
        if (decodeURIComponent(pair[0]) === key) {
          return decodeURIComponent(pair[1] || '');
        }
      }
      return null;
    },
    'setCookie': function(name, value, options) {
      var params = [];

      if (value === null || value === undefined) {
        options.expires = -1;
      }

      if (typeof options.expires === 'number') {
        var days = options.expires, t = options.expires = new Date();
        t.setDate(t.getDate() + days);
      }

      params.push(encodeURIComponent(key) + '=' + encodeURIComponent(value));

      if (options.expires) {
        params.push('expires=' + options.expires.toUTCString());
      }

      if (options.expires) {
        params.push('expires=' + options.expires.toUTCString());
      }

      if (options.path) {
        params.push('path=' + options.path);
      }

      if (options.domain) {
        params.push('domain=' + options.domain);
      }

      if (options.secure) {
        params.push('secure');
      }

      return (document.cookie = params.join('; '))
    },
    'bind': function(funct) {
      var self = this;
      return function() {
        funct.apply(self, arguments);
      };
    }
  });
})(jQuery);
