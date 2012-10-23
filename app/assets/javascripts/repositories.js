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
    infowindow.infowindow.close();
  });
}

function displayUserOnMap(element) {
  var user = {element: element, address: element.find('.user_location').html()};
  var userLat = element.find('.user_location').data('lat');
  var userLng = element.find('.user_location').data('lng');

  if (userLat && userLng) {
    latLng = new google.maps.LatLng(userLat, userLng);
    markerifyUser(user.element, latLng);
  } else {
    geocoder.geocode({'address': user.address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        markerifyUser(user.element, results[0].geometry.location);
      } else {
        popupifyUser(user.element);
      }
    });
  }
}

function markerifyUser(element, location) {
  var user_login = element.find('.user_login').html()

  if(((map.center.lat() == 0) && ($('.commiter').has('.user_location').first().find('.user_login').html() == user_login)) || element.hasClass('main_commiter')) {
    map.setCenter(location);
    markerOptions = {
      icon: $('p.main_commiter_infos img').attr('src')
    };
  } else {
    markerOptions = {}
  }

  var infowindow = new google.maps.InfoWindow({
    content: element.html(),
    maxWidth: 500
  });
  var marker = new google.maps.Marker($.extend({
    map: map,
    position: location,
    title: user_login
  }, markerOptions));

  google.maps.event.addListener(marker, 'click', function() {
    close_infowindows();
    infowindow.open(map,marker);
  });
  infowindows.push({marker: marker, infowindow: infowindow});

  element.remove();
}

function popupifyUser(element) {
  element.popover({
    content: element.find('.user_infos').html(),
    trigger: 'hover',
    placement: 'top',
    title: element.find('.user_login').html()
  });
  element.find('.user_infos').remove();
}

$(document).ready(function(){
  window.geocoder = new google.maps.Geocoder();

  if($('#commiters_map').length > 0) {
    initialize_map(document.getElementById("commiters_map"));

    $('.commiter').each(function(i) {
      el = $(this);

      if(el.find('.user_location').length > 0) {
        displayUserOnMap(el);
      } else {
        popupifyUser(el);
      }
    });
  }
  
});
