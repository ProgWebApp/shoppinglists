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
            #mapid { min-height: 380px; }
        </style>
        <link rel="stylesheet" href="./leaflet/leaflet.css" />
        <script src="./leaflet/leaflet.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Negozi vicini</title>
        <%@include file="include/generalMeta.jsp"%>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>Trova i negozi vicini a te</h1>      
                        <p>Trova i negozi più vicini dove poter completare la lista</p>
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp"%>
            </div>
            <div id="body">
                <div id="mapid" class="map"></div>
            </div>
            <%@include file="include/footer.jsp"%>
        </div>
        <script>
            var lat, long;
            var json;
            var shopsJSON;
            var shops;

            var geojson;
            var mymap = L.map('mapid');
            mymap.locate({setView: true});
            getLocation();
            function getLocation() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function (position) {
                        lat = position.coords.latitude;
                        long = position.coords.longitude;
                        var circle = L.circle([lat, long], {
                            color: '#ff6336',
                            fillColor: '#ff6336',
                            fillOpacity: 0.3,
                            radius: 1000
                        }).addTo(mymap);
                        getShops();
                    });
                } else {
                    console.log("Geolocation is not supported by this browser.");
                }
            }

            function getShops() {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        shopsJSON = JSON.parse(this.responseText);
                        shops = "";
                        shopsJSON.shops.forEach(addShop);
                        foo();
                    }
                };
                xhttp.open("GET", "${pageContext.response.encodeURL(contextPath.concat("MapServlet"))}", true);
                xhttp.send("");
            }

            function addShop(shop, i) {
                shops += "node[\"shop\"=\"" + shop + "\"](around:1000, " + lat + ", " + long + ");";

            }

            function foo() {
                var myquery = "[out:json][timeout:30];"
                        + "(" + shops + ");"
                        + "out body center qt 100;";
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        json = JSON.parse(this.responseText);
                        console.log(this.responseText);
                        console.log(json.elements.length);
                        geojson = '{ "type":"FeatureCollection", "features":[';
                        json.elements.forEach(myToGeoJson);
                        geojson += ']}';
                        geojson = JSON.parse(geojson);

                        L.geoJSON(geojson, {
                            style: function (feature) {
                                return {color: feature.properties.color};
                            }
                        }).bindPopup(function (layer) {
                            return layer.feature.properties.name+" "+layer.feature.properties.shop;
                        }).addTo(mymap);
                        L.tileLayer('https://a.tile.openstreetmap.org/{z}/{x}/{y}.png ', {
                            attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
                            maxZoom: 17,
                        }).addTo(mymap);
                    }
                };
                xhttp.open("POST", "https://www.overpass-api.de/api/interpreter", true);
                xhttp.send("data=" + myquery);
            }

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
