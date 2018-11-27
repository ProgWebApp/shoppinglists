<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="${contextPath}jquery-ui-1.12.1/jquery-ui.js"></script>
<script>
    /* RECUPERA IL NUMERO DI NOTIFICHE DI MESSAGGI */
    function getNotifications() {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                console.log("Hai " + this.responseText + " notifiche");
            }
        };
        xhttp.open("GET", "${pageContext.response.encodeURL(contextPath.concat("restricted/NotificationsServlet"))}", true);
        xhttp.send("");
    }

    /* RECUPERA IL NUMERO DI NEGOZI VICINI */
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
                shopsJSON.shops.forEach(function (shop) {
                    shops += "node[\"shop\"=\"" + shop + "\"](around:1000, " + lat + ", " + long + ");";
                });
                searchShopAround();
            }
        };
        xhttp.open("GET", "${pageContext.response.encodeURL(contextPath.concat("MapServlet"))}", true);
        xhttp.send("");
    }
    function searchShopAround() {
        var myquery = "[out:json][timeout:30];"
                + "(" + shops + ");"
                + "out body center qt 100;";
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                json = JSON.parse(this.responseText);
                console.log("ci sono " + json.elements.length + " negozi vicini");
            }
        };
        xhttp.open("POST", "http://www.overpass-api.de/api/interpreter", true);
        xhttp.send("data=" + myquery);
    }

    /* FUNZIONE RICERCA PRODOTTI */
    $(function () {
        $("#searchProducts").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url:
    <c:if test="${not empty user}">"${pageContext.response.encodeURL(contextPath.concat("restricted/ProductsSearchServlet"))}"</c:if>
    <c:if test="${empty user}">"${pageContext.response.encodeURL(contextPath.concat("ProductsSearchPublic"))}"</c:if>,
                    dataType: "json",
                    data: {
                        query: request.term
                    },
                    success: function (data) {
                        response(data);
                    },
                    error(e) {
                        console.log("Error: " + e);
                    }
                });
            },
            response: function (event, ui) {
    <c:if test="${not empty user}">
                ui.content.push({label: "Aggiungi \"" + $("#searchProducts").val() + "\" ai miei prodotti", value: 0});
    </c:if>
            },
            select: function (event, ui) {
                if (ui.item.value === 0) {
                    var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/productForm.jsp?name="))}" + $("#searchProducts").val();
                    window.location.href = url;
                } else {
    <c:if test="${not empty user}">
                    var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet?res=1&productId="))}" + ui.item.value;
    </c:if>
    <c:if test="${empty user}">
                    var url = "${pageContext.response.encodeURL(contextPath.concat("ProductPublic?res=1&productId="))}" + ui.item.value;
    </c:if>
                    window.location.href = url;
                }
                return false;
            },
            focus: function () {
                return false;
            }
        });
        $("#searchProducts").keypress(function (e) {
            console.log("Valore: " + $("#searchProducts").text);
            if (e.which === 13 && $("#searchProducts").val() !== "") {
                var url = "${pageContext.response.encodeURL(contextPath.concat("products.jsp?query="))}" + $("#searchProducts").val();
                window.location.href = url;
            }
        });
    });
</script>
<div class="mynav">
    <div class="mynav-left">
        <div class="mynav-item">
            <a href="${pageContext.response.encodeURL(contextPath.concat("index.jsp"))}"><span class="glyphicon glyphicon-home"></span><span class="hide-elem"> Home</span></a>
        </div>
        <div class="search">
            <input type="text" name="searchProducts" id="searchProducts" placeholder="Cerca prodotti...">
        </div>
    </div>
    <div class="mynav-right">
        <c:choose>
            <c:when test="${not empty user}">
                <div class="mynav-item hide-elem">
                    <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/user.jsp"))}" style="color:white">
                        <span class="glyphicon glyphicon-user"></span>
                        <span>Profilo</span>
                    </a>
                </div>
                <div class="mynav-item hide-elem">
                    <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/Logout"))}" style="color:white">
                        <span class="glyphicon glyphicon-log-out"></span>
                        <span>Logout</span>
                    </a>
                </div>
                <div class="mynav-item dropdown" >
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <span class="glyphicon glyphicon-menu-hamburger"></span>
                        <span class="hide-elem">Men&ugrave;</span>
                    </a>
                    <ul class="dropdown-menu  dropdown-menu-right">
                        <li class="hide-elem-men"><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/user.jsp"))}">Profilo</a></li>
                        <li class="hide-elem-men"><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/Logout"))}">Logout</a></li>
                        <li class="hide-elem-men"><hr></li>
                        <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/shoppingLists.jsp"))}">Le mie liste</a></li>
                        <li><a href="${pageContext.response.encodeURL(contextPath.concat("shoppingListForm.jsp"))}">Nuova lista</a></li>
                        <li><hr></li>
                        <li><a href="${pageContext.response.encodeURL(contextPath.concat("products.jsp"))}">I miei prodotti</a></li>
                        <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/productForm.jsp"))}">Aggiungi prodotto</a></li>
                        <li><hr></li>
                        <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/categories.jsp"))}">Categorie lista</a></li>
                        <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/shoppingListCategoryForm.jsp"))}">Nuova categoria lista</a></li>
                        <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/categories.jsp"))}">Categorie prodotto</a></li>
                        <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/productCategoryForm.jsp"))}">Nuova categoria prodotto</a></li>
                    </ul>
                </div>
            </c:when>
            <c:when test="${empty user}">
                <div class="mynav-item hide-elem">
                    <a href="${pageContext.response.encodeURL(contextPath.concat("login.jsp"))}" style="color:white">
                        <span class="glyphicon glyphicon-log-out"></span>
                        <span>Login</span>
                    </a>
                </div>
                <div class="mynav-item dropdown" >
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <span class="glyphicon glyphicon-menu-hamburger"></span>
                        <span class="hide-elem">Men&ugrave;</span>
                    </a>
                    <ul class="dropdown-menu  dropdown-menu-right">
                        <li class="hide-elem-men"><a href="${pageContext.response.encodeURL(contextPath.concat("login.jsp"))}">Login</a></li>
                        <li class="hide-elem-men"><hr></li>
                        <li><a href="${pageContext.response.encodeURL(contextPath.concat("ShoppingListPublic?res=1"))}">La mia lista</a></li>
                    </ul>
                </div>
            </c:when>
        </c:choose>
    </div>
</div>
<script>
    <c:if test="${not empty user}">
    getNotifications();
    </c:if>
    getLocation();
</script>
