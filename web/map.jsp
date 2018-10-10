<%-- 
    Document   : map
    Created on : 10-ott-2018, 10.20.02
    Author     : pberi
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <style>
            #mapid { height: 380px; }
        </style>
        <link rel="stylesheet" href="./leaflet/leaflet.css" />
        <script src="./leaflet/leaflet.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

    </head>
    <body>
        <h1>That's my map!</h1>
        <div id="mapid" class="map"></div>

        <script>
            var lat, long;
            var json;
            var geojson;
            var xhttp = new XMLHttpRequest();
            function getLocation() {

                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function (position) {
                        console.log("navigator ok");

                        lat = position.coords.latitude;
                        long = position.coords.longitude;
                        foo();
                    });
                } else {
                    console.log("Geolocation is not supported by this browser.");
                }

            }
            getLocation();
            function foo() {
                console.log("lat: " + lat);
                var myquery = "[out:json][timeout:30];"
                        + "(node"
                        + "   [\"shop\"=\"supermarket\"]"
                        + "   (" + (lat - 0.02) + "," + (long - 0.02) + "," + (lat + 0.02) + "," + (long + 0.02) + ");"
                        + "   );"
                        + "out body center qt 100;";
                console.log(myquery);
                xhttp.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        console.log(this.responseText);
                        json = JSON.parse(this.responseText);
                        console.log(json);
                        geojson = '{ "type":"FeatureCollection", "features":[';
                        json.elements.forEach(myToGeoJson);
                        geojson += ']}';
                        geojson = JSON.parse(geojson);
                        console.log(geojson);
                        L.geoJSON(geojson, {
                            style: function (feature) {
                                return {color: feature.properties.color};
                            }
                        }).bindPopup(function (layer) {
                            return layer.feature.properties.name;
                        }).addTo(mymap);
                        L.tileLayer('https://a.tile.openstreetmap.org/{z}/{x}/{y}.png ', {
                            attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
                            maxZoom: 18,
                            //id: 'mapbox.street'
                        }).addTo(mymap);
                    }
                };
                xhttp.open("POST", "http://www.overpass-api.de/api/interpreter", true);
                xhttp.send("data=" + myquery);
            }

            var mymap = L.map('mapid');

            mymap.locate({setView: true});

            function myToGeoJson(mynode, i) {
                if (i > 0) {
                    geojson += ',';
                }
                geojson += '{'
                        + '"type": "Feature",'
                        + '"geometry": {'
                        + '"type": "Point",'
                        + '"coordinates": [' + mynode.lon + ', ' + mynode.lat + ']'
                        + '},'
                        + '"properties": {'
                        + '"id": "' + mynode.id + '",'
                        + '"name": "' + mynode.tags.name + '",'
                        + '"shop": "' + mynode.tags.shop + '"'
                        + '}'
                        + '}';
            }
        </script>


    </body>
</html>
