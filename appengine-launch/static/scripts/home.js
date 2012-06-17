(function($){
  $.fn.cyphtHome = function(base, options) {
    return new $.cyphtHome(this, base, options);
  };

  $.cyphtHome = function(element, base, options) {
    this.base = base;
    this.bind = this.base.bind;

    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.cyphtHome.fn = $.cyphtHome.prototype = {
    cyphtHome: '0.1'
  };

  $.cyphtHome.fn.extend = $.cyphtHome.extend = $.extend;

  $.cyphtHome.fn.extend({
    'init': function() {
      this.buttonKeys = {
        COFFEE: 'coffee',
        QUICK: 'quick_bite',
        FINE: 'fine_dinning'
      };
      return this;
    },
    'render': function() {
      this.base.render();

      var buttons = [
        $(document.createElement('DIV'))
            .text('Coffee')
            .attr('id', this.buttonKeys.COFFEE),
        $(document.createElement('DIV'))
            .text('Quick bite')
            .attr('id', this.buttonKeys.QUICK),
        $(document.createElement('DIV'))
            .text('Fine dining')
            .attr('id', this.buttonKeys.FINE)
      ];

      $(buttons).each(this.bind(function(index, button) {
        this.options.buttons.append(button);
        button.button().click(this.bind(this.onClick));
      }));

      this.options.thumbsup.button({icons: {primary: 'thumbs-up'}});
      this.options.thumbsdown.button({icons: {primary: 'thumbs-down'}});

      return this;
    },
    'renderMap' : function() {
      var myOptions = {
        zoom: 8,
        center: new google.maps.LatLng(-34.397, 150.644),
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      map = new google.maps.Map(this.options.map.get(0), myOptions);
      this.options.map.fadeIn();
    },
    'onClick' : function(event) {
      var target = $(event.currentTarget);
      var id = target.attr('id');
      var data = {
        'type': id
      };

      var request = $.ajax({
        'type': 'POST',
        'url': '?',
        'data': data,
        'dataType': 'json'
      })

      request.done(this.bind(function(msg) {
        this.base.success(JSON.stringify(msg));
        this.renderMap();
      }));

      request.fail(this.bind(function(jqXHR, textStatus) {
        this.base.error('Error ' + jqXHR.status);
        console.error(jqXHR.responseText);
      }));
    }
  });
})(jQuery);
