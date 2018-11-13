<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
    /* FUNZIONE RICERCA PRODOTTI */
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
                    return "ProductsSearchServlet?query=" + request.term;

                },
                dataType: "json"
            },
            templateResult: formatOption
        });
        $("#searchProducts").val(null).trigger("change");
        $('#searchProducts').on("select2:select", function () {
            var url = "${pageContext.response.encodeURL("ProductServlet?res=1&productId=")}" + $('#searchProducts').find(":selected").val();
            console.log(url);
            window.location.href = url;
        });
    });
</script>
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <ul class="nav navbar-nav navbar-right">
            <c:choose>
                <c:when test="${not empty user}">
                    <li><a href="User.jsp" style="color:white"><span class="glyphicon glyphicon-user"></span> PROFILO</a></li>
                    <li><a href="Logout" style="color:white"><span class="glyphicon glyphicon-log-out"></span> LOGOUT</a></li>
                    </c:when>
                    <c:when test="${empty user}">
                    <li><a href="login.jsp" style="color:white"><span class="glyphicon glyphicon-log-out"></span> LOGIN</a></li>
                    </c:when>
                </c:choose>
            <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" style="color:white" href="#"><span class="glyphicon glyphicon-menu-hamburger"></span>MEN&Ugrave;</a>
                <ul class="dropdown-menu">
                    <li><a href="${pageContext.response.encodeURL("shoppingLists.jsp")}">Le mie liste</a></li>
                    <li><a href="${pageContext.response.encodeURL("shoppingListForm.jsp")}">Nuova lista</a></li>
                    <li><hr></li>
                    <li><a href="${pageContext.response.encodeURL("products.jsp")}">I miei prodotti</a></li>
                    <li><a href="${pageContext.response.encodeURL("productsForm.jsp")}">Aggiungi prodotto</a></li>
                    <li><hr></li>
                    <li><a href="${pageContext.response.encodeURL("shoppingListCategories.jsp")}">Categorie lista</a></li>
                    <li><a href="${pageContext.response.encodeURL("shoppingListCategoryForm.jsp")}">Nuova categoria lista</a></li>
                    <li><a href="${pageContext.response.encodeURL("productsCategories.jsp")}">Categorie prodotto</a></li>
                    <li><a href="${pageContext.response.encodeURL("productCategory.jsp")}">Nuova categoria prodotto</a></li>
                </ul>
            </li>
        </ul>
        <button type="button" class="navbar-toggle" data-toggle="collapse"></button>
        <a class="navbar-brand" style="color:white" href="../index.jsp"><span class="glyphicon glyphicon-home"></span> Home</a>
        <form class="navbar-form" role="search">
            <div class="input-group col-xs-5">
                <select id="searchProducts" name="searchProducts" class="form-control select2-allow-clear">
                </select>
                <!--<input type="text" class="form-control" placeholder="Cerca Prodotti..." id="cerca">
                <div class="input-group-btn">
                    <button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search"></i></button>
                </div>-->
            </div>
        </form>
                
    </div>
</nav>