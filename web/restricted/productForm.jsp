<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ProductCategoryDAO"%>
<%@page import="db.entities.ProductCategory"%>
<%@page import="java.util.List"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%! private ProductCategoryDAO productCategoryDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productCategoryDAO = daoFactory.getDAO(ProductCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get product category dao", ex);
        }
    }
%>
<%
    List<ProductCategory> categories;
    categories = productCategoryDAO.getAll();
    pageContext.setAttribute("categories", categories);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Product</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
        <script>
            function showIcons(logo, category) {
                var div = document.getElementById(logo);
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        var response = JSON.parse(this.responseText);
                        div.innerHTML = "";
                        response.icons.forEach(function (icon) {
                            var radio = '<input id="' + icon + '" type="radio" name="logo" value="' + icon + '">'
                                    + '<label for="' + icon + '">'
                                    + '<img height="50px" src="../images/productCategories/icons/' + icon + '">'
                                    + '</label>';
                            div.innerHTML += radio;
                        });
                    }
                };
                var url = "${pageContext.response.encodeURL("IconsServlet")}";
                if (category !== '') {
                    xhttp.open("GET", url + "?category=" + category, true);
                    xhttp.send();
                }
            }
        </script>    
    </head>
    <body onload="showIcons('logo', '${product.productCategoryId}')">
        <form class="form-signin" action="${pageContext.response.encodeURL("product")}" method="POST" enctype="multipart/form-data">
            <div class="text-center mb-4">
                <h3>Edit Product</h3>
            </div>
            <c:choose>
                <c:when test="${message==1}">
                    Compila i campi mancanti!
                    <c:if test="${empty product.name}">Name</c:if>
                    <c:if test="${empty product.notes}">Notes</c:if>
                    <c:if test="${empty product.productCategoryId}">Category</c:if>
                    <c:if test="${empty product.logoPath}">Logo</c:if>
                </c:when>
            </c:choose>
            <div class="form-label-group">
                <label for="name">Name: </label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Name" value="${product.name}" autofocus>
            </div>
            <div class="form-label-group">
                <label for="notes">Notes: </label>
                <input type="text" id="notes" name="notes" class="form-control" placeholder="Notes" value="${product.notes}">
            </div>
            <div class="form-label-group">
                <label for="category">Category: </label>
                <select id="category" name="category" class="form-control" onchange="showIcons('logo', this.value)">
                    <option value="" <c:if test="${empty product.productCategoryId}">selected</c:if> disabled>Select category...</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}" <c:if test="${category.id==product.productCategoryId}">selected</c:if>>${category.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-label-group">
                <c:if test="${not empty product.logoPath}">
                    <img height="50px" src="../images/productCategories/icons/${product.logoPath}">
                </c:if>
                <label for="logo">New Logo: </label>
                <div id="logo">
                </div>
            </div>
            <div class="form-label-group">
                <label for="photos">Add images: </label>
                <input type="file" id="photos" name="photos" class="form-control" multiple="multiple">
            </div>
            <div>
                <c:if test="${not empty product.photoPath}">
                    Remove images:
                    <c:forEach items="${product.photoPath}" var="photo">
                        <input type="checkbox" id="${photo}" name="removePhotos" value="${photo}">
                        <label for="${photo}"><img height="50px" src="../images/products/${photo}"></label>
                        </c:forEach>
                    </c:if>
            </div>
            <c:if test="${not empty product.id}"><input type="hidden" name="productId" value="${product.id}"></c:if>
            <button class="buttonlike" type="submit">Confirm</button>
        </form>
    </body>
</html>