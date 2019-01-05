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
        <title>Prodotto</title>
        <%@include file="../include/generalMeta.jsp" %>
        <script>
            function showIcons(logo, category) {
                var div = document.getElementById(logo);
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        var response = JSON.parse(this.responseText);
                        div.innerHTML = "";
                        response.icons.forEach(function (icon) {
                            var radio = '<div class="container-logo">'
                                    + '<input id="' + icon + '" type="radio" name="logo" value="' + icon + '" class="input-img input-hide">'
                                    + '<label for="' + icon + '">'
                                    + '<img src="${contextPath}images/productCategories/icons/' + icon + '" class="fit-logo img-responsive">'
                                    + '</label>'
                                    + '</div>';
                            div.innerHTML += radio;
                        });
                        div.innerHTML += "<div style=\"clear: both;\"></div>";
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/IconsServlet"))}";
                if (category !== '') {
                    xhttp.open("GET", url + "?category=" + category, true);
                    xhttp.send();
                }
            }
        </script>    
    </head>
    <body onload="showIcons('logo', '${product.productCategoryId}')">
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>Prodotto</h1>
                        <h4>Crea o modifica il prodotto</h4>
                    </div>
                </div>
                <%@include file="../include/navigationBar.jsp" %>
            </div>
            <div id="body">
                <div class="container text-center">
                    <div class="col-sm-2">
                    </div>
                    <div class="col-sm-8">
                        <div class="form-container">
                            <form class="form-signin" action="${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet"))}" method="POST" enctype="multipart/form-data">
                                <c:choose>
                                    <c:when test="${message==1}">
                                        Compila i campi mancanti!
                                        <c:if test="${empty product.name}">Name</c:if>
                                        <c:if test="${empty product.notes}">Note</c:if>
                                        <c:if test="${empty product.productCategoryId}">Categoria</c:if>
                                        <c:if test="${empty product.logoPath}">Logo</c:if>
                                    </c:when>
                                </c:choose>
                                <div class="form-group">
                                    <label for="nome">Nome:</label>
                                    <input type="text" id="name" name="name" class="form-control" placeholder="Inserisci nome prodotto" value="${product.name}${param.name}" autofocus>
                                </div>
                                <div class="form-group">
                                    <label for="Note">Note:</label>
                                    <textarea id="notes" name="notes" class="form-control" placeholder="Inserisce note">${product.notes}</textarea>
                                </div>
                                <div class="form-group">
                                    <label for="category">Categoria:</label>
                                    <select id="category" name="category" class="form-control" onchange="showIcons('logo', this.value)">
                                        <option value="" <c:if test="${empty product.productCategoryId}">selected</c:if> disabled>Scegli categoria...</option>
                                        <c:forEach items="${categories}" var="category">
                                            <option value="${category.id}" <c:if test="${category.id==product.productCategoryId}">selected</c:if>>${category.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <c:if test="${not empty product.logoPath}">
                                        <img class="small-logo" src="${contextPath}images/productCategories/icons/${product.logoPath}">
                                    </c:if>
                                    <label for="logo">Scegli logo: </label>
                                    <div id="logo">

                                    </div>
                                </div>
                                <br>
                                <div class="form-group">
                                    <label for="logo">Aggiungi immagini:</label>
                                    <input type="file" id="photos" name="photos" class="form-control" placeholder="Images" multiple="multiple">
                                </div>
                                <div>
                                    <c:if test="${not empty product.photoPath}">
                                        <div class="form-group">
                                            <label for="categorie">Seleziona le immagini da rimuovere:</label>
                                            <div class="row">
                                                <c:forEach items="${product.photoPath}" var="photo">
                                                    <div class="container-logo">
                                                        <input type="checkbox" id="${photo}" name="removePhotos" value="${photo}" class="input-img input-hide">
                                                        <label for="${photo}"><img class="fit-logo img-responsive" src="${contextPath}images/products/${photo}" alt="Img Prod"></label>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                                <c:if test="${not empty product.id}">
                                    <input type="hidden" name="productId" value="${product.id}">
                                </c:if>
                                <button type="submit" class="btn-custom">Salva</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <%@include file="../include/footer.jsp" %>
        </div>
    </body>
</html>
