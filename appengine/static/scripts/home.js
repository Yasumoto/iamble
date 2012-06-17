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

      this.options.thumbsup
          .button({icons: {primary: 'thumbs-up'}})
          .click(this.bind(this.onThumbsUp));

      this.options.thumbsdown
          .button({icons: {primary: 'thumbs-down'}})
          .click(this.bind(this.onThumbsDown));

      return this;
    },
    'renderMap' : function(lat, lng) {
      var pos = new google.maps.LatLng(lat, lng);

      var myOptions = {
        zoom: 10,
        center: pos,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      map = new google.maps.Map(this.options.map.get(0), myOptions);

      var marker = new google.maps.Marker({
        position: pos,
        title:"Hello World!"
      });
      marker.setMap(map);

      this.options.map.fadeIn();
    },
    'request': function(type, id, vote) {
      var data = {
        'id': id,
        'type': type,
        'vote': vote
      };

      var request = $.ajax({
        'type': 'POST',
        'url': '?',
        'data': data,
        'dataType': 'json'
      })

      request.done(this.bind(function(suggestion) {
        this.responseId = suggestion['address'];
        this.base.options.messages.empty();
        this.renderMap(suggestion['lat'], suggestion['lng']);

        this.options.title.html(suggestion['name']);
        this.options.address.html(suggestion['address']);
        this.options.reasons.empty();
        this.options.reasons
          .append($(document.createElement('li'))
              .append(suggestion['why_description1']))
          .append($(document.createElement('li'))
              .append(suggestion['why_description2']));

        this.options.result.fadeIn().css("display","inline-block");
      }));

      request.fail(this.bind(this.onAjaxFail));
    },
    'onThumbsDown': function() {
      this.request(this.currentType, this.responseId, -1);
    },
    'onThumbsUp': function() {
      this.request(this.currentType, this.responseId, 1);
    },
    'onClick' : function(event) {
      var target = $(event.currentTarget);
      var type = target.attr('id');
      this.currentType = type;
      this.request(type, null, 0);
    },
    'onAjaxFail': function(jqXHR, textStatus) {
      this.base.error('Error ' + jqXHR.status);
      console.error(jqXHR.responseText);
    }
  });
})(jQuery);
