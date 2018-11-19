
    var lat, long;
    var json;
    var shopsJSON;
    var shops;
    function getLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                lat = position.coords.latitude;
                long = position.coords.longitude;
                getShopNames();
            });
        } else {
            console.log("Geolocation is not supported by this browser.");
            return 0;
        }
    }
    function getShopNames() {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                shopsJSON = JSON.parse(this.responseText);
                shops = "";
                shopsJSON.shops.forEach(addShop);
                searchShopAround();
            }
        };
        xhttp.open("GET", "MapServlet", true);
        xhttp.send("");
        
    }

    function addShop(shop, i) {
        shops += "node[\"shop\"=\"" + shop + "\"](around:8000, " + lat + ", " + long + ");";
    }

    function searchShopAround() {
        var myquery = "[out:json][timeout:30];"
            + "(" + shops + ");"
            + "out body center qt 100;";
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                json = JSON.parse(this.responseText);
                console.log("ci sono "+json.elements.length+" messaggi");
            }
        };
        xhttp.open("POST", "http://www.overpass-api.de/api/interpreter", true);
        xhttp.send("data=" + myquery);
    }