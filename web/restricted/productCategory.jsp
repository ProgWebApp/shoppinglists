<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product Category</title>
        <script>
            function deleteProductCategory(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        window.location.href = "${pageContext.response.encodeURL("productCategories.jsp")}";
                    }else if (this.readyState === 4 && this.status === 400) {
                        alert("Bad request!");
                    }else if (this.readyState === 4 && this.status === 403) {
                        alert("You are not allowed to delete the productCategory!");
                    }else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossible to delete the productCategory!");
                    }
                };
                var url = "${pageContext.response.encodeURL("ProductCategoryServlet")}";
                xhttp.open("DELETE", url + "?productCategoryId=" + id, true);
                xhttp.send();
            }
        </script>
    </head>
    <body>
        ${productCategory.id}<br>
        ${productCategory.name}<br>
        ${productCategory.description}<br>
        <img height="50px" src="../images/productCategories/${productCategory.logoPath}"><br>
        <c:forEach items="${productCategory.iconPath}" var="icon">
            <img height="50px" src="../images/productCategories/icons/${icon}">
        </c:forEach><br>
        <a href="${pageContext.response.encodeURL("ProductCategoryServlet?res=2&productCategoryId=".concat(productCategory.id))}">Modifica</a>
        <span onclick="deleteProductCategory(${productCategory.id})">Elimina</span><br>
        <a href="${pageContext.response.encodeURL("productCategories.jsp")}">Product Categories</a>
    </body>
</html>