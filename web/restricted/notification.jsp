<%-- 
    Document   : map
    Created on : 10-ott-2018, 10.20.02
    Author     : pberi
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <div id="mynum"></div>
        <script>
            var lat, long;
            var json;
            var shopsJSON;
            var shops;

            var geojson;
            getLocation();
            function getLocation() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function (position) {
                        lat = position.coords.latitude;
                        long = position.coords.longitude;
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
                        console.log(shopsJSON);
                        shops = "";
                        shopsJSON.shops.forEach(addShop);
                        foo();
                    }
                };
                xhttp.open("GET", "../MapServlet", true);
                xhttp.send("");

            }
            function addShop(shop, i) {
                shops += "node[\"shop\"=\"" + shop + "\"](" + (lat - 0.02) + "," + (long - 0.02) + "," + (lat + 0.02) + "," + (long + 0.02) + ");";
            }
            function foo() {
                console.log("lat: " + lat);
                var myquery = "[out:json][timeout:30];"
                        + "(" + shops + ");"
                        + "out body center qt 100;";
                console.log(myquery);
                var xhttp = new XMLHttpRequest();

                xhttp.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        console.log(this.responseText);
                        json = JSON.parse(this.responseText);
                        console.log(json);
                        document.getElementById("mynum").innerHTML = "-" + json.elements.length + "-";
                    }
                };
                xhttp.open("POST", "http://www.overpass-api.de/api/interpreter", true);
                xhttp.send("data=" + myquery);
            }
        </script>
    </body>
</html>
