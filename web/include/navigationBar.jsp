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
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header pull-left">
            <a class="navbar-brand" style="color:white" href="${pageContext.response.encodeURL(contextPath.concat("index.jsp"))}"><span class="glyphicon glyphicon-home"></span><span class="hidden-sm hidden-xs"> Home</span></a>
        </div>
        <div class="navbar-header pull-left">
            <form class="navbar-form" role="search">
                <div class="input-group col-xs-5">
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
            </form>
        </div>
        <div class="navbar-header pull-right">
            <ul class="nav navbar-nav navbar-right list-inline">
                <c:choose>
                    <c:when test="${not empty user}">
                        <li style="display: inline-block !important;">
                            <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/user.jsp"))}" style="color:white">
                                <span class="glyphicon glyphicon-user"></span>
                                <span class="hidden-sm hidden-xs">PROFILO</span>
                            </a>
                        </li>
                        <li style="display: inline-block !important;">
                            <a href="${pageContext.response.encodeURL(contextPath.concat("Logout"))}" style="color:white">
                                <span class="glyphicon glyphicon-log-out"></span>
                                <span class="hidden-sm hidden-xs">LOGOUT</span>
                            </a>
                        </li>
                        <li class="dropdown" style="display: inline-block !important;">
                            <a class="dropdown-toggle" data-toggle="dropdown" style="color:white" href="#">
                                <span class="glyphicon glyphicon-menu-hamburger"></span>
                                <span class="hidden-sm hidden-xs">MEN&Ugrave;</span>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/shoppingLists.jsp"))}">Le mie liste</a></li>
                                <li><a href="${pageContext.response.encodeURL(contextPath.concat("shoppingListForm.jsp"))}">Nuova lista</a></li>
                                <li><hr></li>
                                <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/products.jsp"))}">I miei prodotti</a></li>
                                <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/productsForm.jsp"))}">Aggiungi prodotto</a></li>
                                <li><hr></li>
                                <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/categories.jsp"))}">Categorie lista</a></li>
                                <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/shoppingListCategoryForm.jsp"))}">Nuova categoria lista</a></li>
                                <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/categories.jsp"))}">Categorie prodotto</a></li>
                                <li><a href="${pageContext.response.encodeURL(contextPath.concat("restricted/productCategoryForm.jsp"))}">Nuova categoria prodotto</a></li>
                            </ul>
                        </li>    
                    </c:when>
                    <c:when test="${empty user}">
                        <li style="display: inline-block !important;">
                            <a href="${pageContext.response.encodeURL(contextPath.concat("login.jsp"))}" style="color:white">
                                <span class="glyphicon glyphicon-log-out"></span>
                                <span class="hidden-sm hidden-xs">LOGIN</span></a></li>
                        <li class="dropdown" style="display: inline-block !important;">
                            <a class="dropdown-toggle" data-toggle="dropdown" style="color:white" href="#">
                                <span class="glyphicon glyphicon-menu-hamburger"></span>
                                <span class="hidden-sm hidden-xs">MEN&Ugrave;</span>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a href="${pageContext.response.encodeURL(contextPath.concat("ShoppingListPublic?res=1"))}">La mia lista</a></li>
                            </ul>
                        </li>    
                    </c:when>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
<script> getLocation();</script>
