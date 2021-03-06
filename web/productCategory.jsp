<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product Category</title>
        <%@include file="include/generalMeta.jsp" %>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron" >
                    <div class="container text-center">
                        <h1>${productCategory.name}</h1> 
                        <h4>Riepilogo dei prodotti di questa categoria</h4>
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp" %>
            </div>
            <div id="body">
                <div class="row">
                    <div class="elem-container-left">
                        <div style="overflow: auto;">  
                            <div class="elem-img">
                                <img src="${contextPath}images/productCategories/${productCategory.logoPath}" alt="img-cat">
                            </div>
                            <div class="elem-text">
                                <h3>Descrizione della categoria:</h3>
                                <p>${productCategory.description}</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="invis-container">
                    <div class="container-fluid">
                        <div class="row">
                            <div style="margin-right:10px; margin-left:10px; float:right;">
                                <c:choose>
                                    <c:when test="${empty user}">
                                        <form action="${contextPath}ProductCategoryPublic" method="GET">
                                            <input type="hidden" name="productCategoryId" value="${productCategory.id}">
                                        </c:when>
                                        <c:when test="${not empty user}">
                                            <form action="${contextPath}restricted/ProductCategoryServlet" method="GET">
                                                <input type="hidden" name="productCategoryId" value="${productCategory.id}">
                                                <input type="hidden" name="res" value="1"> 
                                            </c:when>
                                        </c:choose>
                                        <select class="select-custom" name="order" onchange="this.form.submit()">
                                            <option value="1" <c:if test="${order==1}">selected</c:if>>Nome prodotto AZ</option> 
                                            <option value="2" <c:if test="${order==2}">selected</c:if>>Nome prodotto ZA</option>  
                                            </select>
                                            <div style="float:right;">
                                                <button type="button" class="btn-custom" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/productForm.jsp"))}'">
                                                Crea prodotto
                                            </button>
                                        </div>
                                    </form>
                            </div>
                        </div>
                        <div class="row">
                            <c:forEach items="${products}" var="product">
                                <c:choose>
                                    <c:when test="${not empty user}">
                                        <div class="panel-default-prods" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet?res=1&productId=").concat(product.id))}'">
                                        </c:when>
                                        <c:when test="${empty user}">
                                            <div class="panel-default-prods" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("ProductPublic?productId=").concat(product.id))}'">
                                            </c:when>
                                        </c:choose>
                                        <div class="panel-heading-prods">
                                            <img style="display:block;" src="${contextPath}images/productCategories/icons/${product.logoPath}" alt="Logo" class="medium-logo"> 
                                            <div class="panel-heading-title"> ${product.name}</div>
                                        </div>
                                        <div class="panel-body-prods" >
                                            <c:forEach items="${product.photoPath}" var="photo" end="0">
                                                <img class="fit-image img-responsive" src="${contextPath}images/products/${photo}" alt="${product.name}">
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                <%@include file="include/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
