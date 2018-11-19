<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Shopping List Category</title>
                <%@include file="include/generalMeta.jsp" %>

        <script>
            function deleteShoppingListCategory(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        window.location.href = "${pageContext.response.encodeURL(contextPath.concat("restricted/shoppingListCategories.jsp"))}";
                    }else if (this.readyState === 4 && this.status === 400) {
                        alert("Bad request!");
                    }else if (this.readyState === 4 && this.status === 403) {
                        alert("You are not allowed to delete the shopping list category!");
                    }else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossible to delete the shopping list category!");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListCategoryServlet"))}";
                xhttp.open("DELETE", url + "?shoppingListCategoryId=" + id, true);
                xhttp.send();
            }
        </script>
    </head>
    <body>
        <div class="jumbotron">
            <div class="container text-center">
                <h1>Categoria di lista della spesa</h1>      
                
            </div>
        </div>
        <%@include file="include/navigationBar.jsp"%>
        ${shoppingListCategory.id}<br>
        ${shoppingListCategory.name}<br>
        ${shoppingListCategory.description}<br>
        <img height="50px" src="${contextPath}images/shoppingListCategories/${shoppingListCategory.logoPath}"><br>
        <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListCategoryServlet?res=2&shoppingListCategoryId=").concat(shoppingListCategory.id))}">Modifica</a>
        <span onclick="deleteShoppingListCategory(${shoppingListCategory.id})">Elimina</span><br>
        <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/categories.jsp"))}">Shopping List Categories</a>
                <%@include file="include/footer.jsp" %>

    </body>
</html>