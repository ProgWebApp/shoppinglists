<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product</title>
        <%@include file="include/generalMeta.jsp" %>
        <script>
            function deleteProduct(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        window.location.href = "${pageContext.response.encodeURL(contextPath.concat("restricted/products.jsp"))}";
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Bad request!");
                    } else if (this.readyState === 4 && this.status === 403) {
                        alert("You are not allowed to delete the product!");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossible to delete the product!");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet"))}";
                xhttp.open("DELETE", url + "?productId=" + id, true);
                xhttp.send();
            }
        </script>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>Prodotto</h1>      
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp" %>
            </div>
            <div id="body">
                ${product.id}<br>
                ${product.name}<br>
                ${product.notes}<br>
                ${productCategory.name}<br>
                <img height="50px" src="${contextPath}images/productCategories/icons/${product.logoPath}"><br>
                <c:forEach items="${product.photoPath}" var="photo">
                    <img height="50px" src="${contextPath}images/products/${photo}">
                </c:forEach><br>
                <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet?res=2&productId=".concat(product.id)))}">Modifica</a>
                <span onclick="deleteProduct(${product.id})">Elimina</span><br>
                <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/products.jsp"))}">My products</a>
            </div>
            <%@include file="include/footer.jsp" %>
        </div>
    </body>
</html>
