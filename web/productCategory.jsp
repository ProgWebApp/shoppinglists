<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product Category</title>
                <%@include file="include/generalMeta.jsp" %>

        <script>
            function deleteProductCategory(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        window.location.href = "${pageContext.response.encodeURL(contextPath.concat("restricted/categories.jsp"))}";
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Bad request!");
                    } else if (this.readyState === 4 && this.status === 403) {
                        alert("You are not allowed to delete the productCategory!");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossible to delete the productCategory!");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ProductCategoryServlet"))}";
                xhttp.open("DELETE", url + "?productCategoryId=" + id, true);
                xhttp.send();
            }
        </script>
    </head>
    <body>        
        <%@include file="include/navigationBar.jsp" %>
        ${productCategory.id}<br>
        ${productCategory.name}<br>
        ${productCategory.description}<br>
        <img height="50px" src="${contextPath}images/productCategories/${productCategory.logoPath}"><br>
        <c:forEach items="${productCategory.iconPath}" var="icon">
            <img height="50px" src="${contextPath}images/productCategories/icons/${icon}">
        </c:forEach><br>
        <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/ProductCategoryServlet?res=2&productCategoryId=").concat(productCategory.id))}">Modifica</a>
        <span onclick="deleteProductCategory(${productCategory.id})">Elimina</span><br>
        <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/categories.jsp"))}">Product Categories</a>
        <c:forEach items="${products}" var="product">
            ${product.name}
        </c:forEach><br>
        <%@include file="include/footer.jsp" %>
    </body>
</html>