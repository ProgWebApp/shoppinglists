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
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron" style="background-image: url('https://www.liberoquotidiano.it/resizer/610/-1/true/1540320662458.jpg--carne__lo_studio_scientifico_che_ribalta_tutto__perche_fa_bene_alla_salute.jpg?1540320831000')">
                    <div class="container text-center">
                        <h1>${productCategory.name}</h1>      
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp" %>
            </div>
            <div id="body">
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
                <div class="container">    
                    <c:forEach items="${products}" var="product">
                        <div class="col-sm-2">
                            <div class="panel panel-default-custom">
                                <div class="panel-heading-custom" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("ProductPublic?productId=").concat(product.id))}'">${product.name}</div>
                                
                                <!--<c:choose>
                                    <c:when test="${product.isReserved()}">
                                        <div class="panel-heading-custom" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet?res=1&productId=").concat(product.id))}'">${product.name}</div>
                                    </c:when>
                                    <c:when test="${not product.isReserved()}">
                                        <div class="panel-heading-custom" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("ProductPublic?productId=").concat(product.id))}'">${product.name}</div>
                                    </c:when>
                                </c:choose>-->
                                <div class="panel-body"><img src="${contextPath}/images/productCategories/${productCategory.logoPath}" class="fit-image img-responsive" alt="${product.name}"></div>
                                <div class="panel-footer-custom"></div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <%@include file="include/footer.jsp" %>
        </div>
    </body>
</html>
