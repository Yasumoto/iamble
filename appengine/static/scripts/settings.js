(function($){
  $.fn.iambleSettings = function(base, options) {
    return new $.iambleSettings(this, base, options);
  };

  $.iambleSettings = function(element, base, options) {
    this.base = base;
    this.bind = this.base.bind;
    this.options = options || {};
    this.target = $(element);
    return this.init();
  };

  $.iambleSettings.fn = $.iambleSettings.prototype = {
    iambleSettings: '0.1'
  };

  $.iambleSettings.fn.extend = $.iambleSettings.extend = $.extend;

  $.iambleSettings.fn.extend({
    'init': function() {
      return this;
    },
    'render': function() {
      this.base.render();
      this.options.distance.buttonset();
      this.options.save.button();

      navigator.geolocation.getCurrentPosition(this.bind(this.onPosition));

      return this;
    },
    'onPosition': function(position) {
      console.dir(position);
      this.options.longitude.val(position.coords.longitude);
      this.options.latitude.val(position.coords.latitude);
      
      var geocoder = new google.maps.Geocoder();
      var latlng = new google.maps.LatLng(
        position.coords.latitude,
        position.coords.longitude
      );

      geocoder.geocode({'latLng': latlng}, this.bind(function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          if (typeof(results[0]) != 'undefined') {
            this.options.address.val(results[0].formatted_address);
          }
        }
      }));
    }
  });
})(jQuery);
