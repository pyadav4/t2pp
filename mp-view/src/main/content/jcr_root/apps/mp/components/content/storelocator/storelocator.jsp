<%@include file="/libs/foundation/global.jsp"%>
<cq:defineObjects/>

<c:choose>
    <c:when test="${not empty properties['datasource']}">

    <body onload="initialize()"  >
    <div id="wrap" >
	<h2> ${properties.title}</h2>
    <div id="map-canvas" ></div>
    <div id="panel" ></div>
    </div>
    </body>
    <script type="text/javascript"
      src="http://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyBAL4D2NWr2x-85ke71dKGQu9rkBujtuzg&libraries=places&sensor=false">
    </script>
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
    

    </c:when>
    <c:otherwise>
        <h1>Store Component</h1>
        <h2>Warning: Datasource page is not configured</h2>
    </c:otherwise>
</c:choose>


<script>

    var datasource='${properties.datasource}';
	var radius = "<%=properties.get("radius")%>";
    var searchpos = "<%=slingRequest.getRequestPathInfo().getSelectorString()%>";
	

</script>
 <script type="text/javascript">
      var map;
      var service;
      var universalCenter;
      function handleSearchResults(results, status){
        //When DOM loaded we attach click event to button
          $(document).ready(function() {
                  //start ajax request
                  $.ajax({
                      url: '/libs/datastore.json' +datasource,
                      //force to handle it as text
                      dataType: "text",
                      success: function(data) {
                      var infowindow =  new google.maps.InfoWindow({
                          content: ""
                      });
                          //data downloaded so we call parseJSON function 
                          //and pass downloaded data
                          var json = $.parseJSON(data);
                          for(var i in json){
                              var latLng = new google.maps.LatLng(json[i].xcord, json[i].ycord); 
                              var marker = new google.maps.Marker({
                                  position: latLng,
                                  title: json[i].name
                              });
                              bindInfoWindow(marker, map, infowindow, json[i]);                                                           
                              marker.setMap(map);                             
                              
                              }
                      }
                  });

                  // Handler for .ready() called.
                  var panelDiv = document.getElementById('panel');
                  var data = new MedicareDataSource;
                  var view = new storeLocator.View(map, data, {
                    geolocation: false,
                    features: data.getFeatures()
                  });
                  v=view;
                  p=new storeLocator.Panel(panelDiv, {
                    view: view
                  });

                  if(navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function(position) {
                      var pos = new google.maps.LatLng(position.coords.latitude,
                                                       position.coords.longitude);
                        if(typeof otherCenter!='undefined') {
                            universalCenter=otherCenter;
                        }
                        else {
                            universalCenter=pos; }

                      var infowindow = new google.maps.InfoWindow({
                        map: map,
                        position: universalCenter,
                        content: 'Welcome'
                      });

                      map.setCenter(universalCenter);

                                                view.refreshView();
                        $('.store-list').jScrollPane({
                                                    horizontalGutter:2,
                                                    verticalGutter:5,
                                                    showArrows: false      
                                                                                                });

                    }, function() {
                      handleNoGeolocation(true);
                    });
                  } else {
                    // Browser doesn't support Geolocation
                    handleNoGeolocation(false);
                  }
                  
                 
          });
      }
      function bindInfoWindow(marker, map, infowindow, jsonValue) {
          google.maps.event.addListener(marker, 'click', function() {
              infowindow.setContent("<div class=\"markerLabel\"><h5><a href=\"http://www.apple.com/retail/eastview/  \" target=\"_blank\" class=\"marker \" rel=\"nofollow\">" +jsonValue.name +"</a></h5><table class=\"adrWrap\"><tbody><tr><td class=\"address\">" +jsonValue.address  +"<br>" +jsonValue.state +"<br>" + jsonValue.country+"</td></tr></tbody></table><div><span class=\"l\">Phone:</span>&nbsp;<span class=+\"skype_c2c_print_container\">" +jsonValue.phonenumber +"</span></div><div><span class=\"l\"> Email:</span>&nbsp;<a href=\"mailto:steve.jobs@apple.com\">steve.jobs@apple.com </a></div></div>" );
              infowindow.open(map, marker);
          });
      }
      function performSearch(){
            var request={
                    bounds:map.getBounds(),
                    name:"McDonald's"
            };
            service.nearbySearch(request,handleSearchResults);
      }
      
      function initialize() {
          var defaultLocation = new google.maps.LatLng(28.6100,77.2300);
          var mapOptions = {
              center: defaultLocation,
              zoom: 4,
              mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
            service = new google.maps.places.PlacesService(map);
            google.maps.event.addListenerOnce(map, 'bounds_changed',performSearch);
      }


      function handleNoGeolocation(errorFlag) {
          if (errorFlag) {
            var content = 'Error: Service failed.';
          } else {
            var content = 'Error: Your browser doesn\'t support geolocation.';
          }
          var options = {
            map: map,
            position: new google.maps.LatLng(60, 105),
            content: content
          };
          universalCenter=options.position;
          var infowindow = new google.maps.InfoWindow(options);
          map.setCenter(options.position);
        }
    </script>
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<cq:includeClientLib categories="apps.storelocator"/>