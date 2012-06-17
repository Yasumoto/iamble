(function($){
  $.fn.cyphtSettings = function(base, options) {
    return new $.cyphtSettings(this, base, options);
  };

  $.cyphtSettings = function(element, base, options) {
    this.base = base;
    this.bind = this.base.bind;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.cyphtSettings.fn = $.cyphtSettings.prototype = {
    cyphtSettings: '0.1'
  };

  $.cyphtSettings.fn.extend = $.cyphtSettings.extend = $.extend;

  $.cyphtSettings.fn.extend({
    'init': function() {
      this.geocoder = new google.maps.Geocoder();
      return this;
    },
    'render': function() {
      this.base.render();
      this.options.distance.buttonset();
      this.options.save.button();
      this.options.static_address.button().click(
          this.bind(this.onUseStatic));
      this.options.address.change(this.bind(this.onUseStatic));

      if (!this.options.static_address.is(':checked')) {
        navigator.geolocation.getCurrentPosition(this.bind(this.onPosition));
        this.base.options.spinner.fadeIn('fast');
      }
      return this;
    },
    'onUseStatic': function(e) {
      if (this.options.static_address.is(':checked')) {
        this.base.options.spinner.fadeIn('fast');
        this.geocoder.geocode({'address': this.options.address.val()},
            this.bind(function(results, status) {
              if (status == google.maps.GeocoderStatus.OK) {
                if (typeof(results[0]) != 'undefined') {
                  this.options.longitude.val(
                      results[0].geometry.location.lng());
                  this.options.latitude.val(
                      results[0].geometry.location.lat());
                }
                this.base.options.spinner.fadeOut('fast');
              }
            }));
      }
    },
    'onPosition': function(position) {
      console.dir(position);
      this.options.longitude.val(position.coords.longitude);
      this.options.latitude.val(position.coords.latitude);

      var latlng = new google.maps.LatLng(
        position.coords.latitude,
        position.coords.longitude
      );

      this.geocoder.geocode({'latLng': latlng}, this.bind(function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          if (typeof(results[0]) != 'undefined') {
            this.options.address.val(results[0].formatted_address);
          }
          this.base.options.spinner.fadeOut('fast');
        }
      }));
    }
  });
})(jQuery);
