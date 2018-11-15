<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product</title>
                <%@include file="../include/generalMeta.jsp" %>

        <script>
            function deleteProduct(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        window.location.href = "${pageContext.response.encodeURL("products.jsp")}";
                    }else if (this.readyState === 4 && this.status === 400) {
                        alert("Bad request!");
                    }else if (this.readyState === 4 && this.status === 403) {
                        alert("You are not allowed to delete the product!");
                    }else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossible to delete the product!");
                    }
                };
                var url = "${pageContext.response.encodeURL("ProductServlet")}";
                xhttp.open("DELETE", url + "?productId=" + id, true);
                xhttp.send();
            }
        </script>
    </head>
    <body>       
        <%@include file="../include/navigationBar.jsp" %>
        ${product.id}<br>
        ${product.name}<br>
        ${product.notes}<br>
        ${productCategory.name}<br>
        <img height="50px" src="../images/productCategories/icons/${product.logoPath}"><br>
        <c:forEach items="${product.photoPath}" var="photo">
            <img height="50px" src="../images/products/${photo}">
        </c:forEach><br>
        <a href="${pageContext.response.encodeURL("product?res=2&productId=".concat(product.id))}">Modifica</a>
        <span onclick="deleteProduct(${product.id})">Elimina</span><br>
        <a href="${pageContext.response.encodeURL("products.jsp")}">My products</a>
            <%@include file="../include/footer.jsp" %>
</body>
</html>