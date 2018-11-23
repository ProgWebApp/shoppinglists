<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
    /* FUNZIONE RICERCA PRODOTTI PUBBLICI E PRIVATI PER L'UTENTE LOGGATO */
    $(function () {
        function formatOption(option) {
            var res = $('<span class="optionClick">' + option.text + '</span>');
            console.log(option.text);
            return res;
        }
        $("#searchProducts").select2({
            placeholder: "Cerca prodotti...",
            allowClear: true,
            ajax: {
                url: function (request) {
                    return "${pageContext.response.encodeURL(contextPath.concat("restricted/ProductsSearchServlet?query="))}" + request.term;

                },
                dataType: "json"
            },
            templateResult: formatOption,
            width: '100%'
        });
        $("#searchProducts").val(null).trigger("change");
        $('#searchProducts').on("select2:select", function () {
            var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet?res=1&productId="))}" + $('#searchProducts').find(":selected").val();
            console.log(url);
            window.location.href = url;
        });
    });
    /* FUNZIONE RICERCA PRODOTTI PUBBLICI PER L'UTENTE non LOGGATO */
    $(function () {
        function formatOption(option) {
            var res = $('<span class="optionClick">' + option.text + '</span>');
            console.log(option.text);
            return res;
        }
        $("#searchPublicProducts").select2({
            placeholder: "Cerca prodotti...",
            allowClear: true,
            ajax: {
                url: function (request) {
                    return "${pageContext.response.encodeURL(contextPath.concat("ProductsSearchPublic?query="))}" + request.term;

                },
                dataType: "json"
            },
            templateResult: formatOption,
            width: '100%'
        });
        $("#searchPublicProducts").val(null).trigger("change");
        $('#searchPublicProducts').on("select2:select", function () {
            var url = "${pageContext.response.encodeURL(contextPath.concat("ProductPublic?productId="))}" + $('#searchPublicProducts').find(":selected").val();
            console.log(url);
            window.location.href = url;
        });
    });</script>
<div class="mynav">
    <div class="mynav-left">
        <div class="mynav-item">
            <a href="${pageContext.response.encodeURL(contextPath.concat("index.jsp"))}"><span class="glyphicon glyphicon-home"></span><span class="hide-elem"> Home</span></a>
        </div>
        <div class="search">
            <c:choose>
                <c:when test="${empty user}">
                    <select id="searchPublicProducts" name="searchPublicProducts" class="form-control select2-allow-clear">
                    </select>
                </c:when>
                <c:when test="${not empty user}">
                    <select id="searchProducts" name="searchProducts" class="form-control select2-allow-clear">
                    </select>
                </c:when>
            </c:choose>
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
                        <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/products.jsp"))}">I miei prodotti</a></li>
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
<script> <c:if test="${not empty user}"> getNotifications(); </c:if> getLocation();</script>
