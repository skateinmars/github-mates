function initialize_map(map_element, mapOptions) {
  var defaultOptions = {
    panControl: false,
    mapTypeControl: false,
    streetViewControl: false,
    overviewMapControl: false,
    zoomControlOptions: {
      style: google.maps.ZoomControlStyle.SMALL
    },
    zoom: 5,
    center: new google.maps.LatLng(0, 0),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  window.map = new google.maps.Map(map_element, $.extend(defaultOptions, mapOptions));
  window.infowindows = [];

  google.maps.event.addListener(map, 'click', close_infowindows);
}

function close_infowindows() {
  $.each(infowindows, function(i, infowindow) {
    infowindow.close();
  });
}

function displayUser(dom_element) {
  var user = {element: $(dom_element), address: $(dom_element).find('.user_location').html()}
  geocoder.geocode({'address': user.address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      var user_position = results[0].geometry.location;
      var user_login = user.element.find('.user_login').html()

      if(((map.center.lat() == 0) && ($('.commiter').has('.user_location').first().find('.user_login').html() == user_login)) || user.element.hasClass('main_commiter')) {
        map.setCenter(user_position);
      }

      var infowindow = new google.maps.InfoWindow({
        content: user.element.html(),
        maxWidth: 500
      });
      infowindows.push(infowindow);

      var marker = new google.maps.Marker({
        map: map,
        position: user_position,
        title: user_login
      });

      google.maps.event.addListener(marker, 'click', function() {
        close_infowindows();
        infowindow.open(map,marker);
      });

      user.element.remove();
    }
  });
}

$(document).ready(function(){
  window.geocoder = new google.maps.Geocoder();

  initialize_map(
    document.getElementById("commiters_map")
  );

  $('.commiter').has('.user_location').each(function(i) {
    displayUser(this);
  });
});
