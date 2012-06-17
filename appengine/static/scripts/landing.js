(function($){
  $.fn.cyphtLanding = function(base, options) {
    return new $.cyphtLanding(this, base, options);
  };

  $.cyphtLanding = function(element, base, options) {
    this.base = base;
    this.bind = this.base.bind;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.cyphtLanding.fn = $.cyphtLanding.prototype = {
    cyphtLanding: '0.1'
  };

  $.cyphtLanding.fn.extend = $.cyphtLanding.extend = $.extend;

  $.cyphtLanding.fn.extend({
    'init': function() {
      return this;
    },
    'render': function() {
      this.base.render();
      this.options.submit.button().click(this.bind(this.onSignup));
      if (!this.base.getCookie('signedup')) {
        this.options.signup.fadeIn();
        this.options.signup.css({
          'display': 'inline-block'
        });
      }
      return this;
    },
    'onSignup': function() {
      var data = {
        'email': this.options.email.val()
      };

      var request = $.ajax({
        'url': '/signup',
        'type': 'POST',
        'data': data,
        'dataType': 'json'
      });

      request.done(this.bind(function(msg) {
        this.base.success('You successfully signed up to get notified!');
        this.options.signup.fadeOut();
        this.base.setCookie('signedup', true);
      }));

      request.fail(this.bind(function(jqXHR, textStatus) {
        this.base.error('Error ' + jqXHR.status);
        console.error(jqXHR.responseText);
      }));
    }
  });
})(jQuery);
