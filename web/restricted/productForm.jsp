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
        <title>Modifica prodotto</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="../css/default-element.css">
        <link rel="stylesheet" type="text/css" href="../css/immagini.css">
        <link rel="stylesheet" type="text/css" href="../css/form.css">
        <link rel="stylesheet" type="text/css" href="../css/loghi.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
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
        <div class="container text-center">    
            <h2>Area di modifica del prodotto</h2><br>
            <h4>Modifica le caratteristiche e le immagini del prodotto</h4><br>
            <br>
            <div class="col-sm-2">
            </div>
            <div class="col-sm-8">
                <div class="form-container ">
                    <form class="form-signin" action="${pageContext.response.encodeURL("ProductServlet")}" method="POST" enctype="multipart/form-data">
                        <c:choose>
                            <c:when test="${message==1}">
                                Compila i campi mancanti!
                                <c:if test="${empty product.name}">Name</c:if>
                                <c:if test="${empty product.notes}">Notes</c:if>
                                <c:if test="${empty product.productCategoryId}">Category</c:if>
                                <c:if test="${empty product.logoPath}">Logo</c:if>
                            </c:when>
                        </c:choose>
                        <div class="form-group">
                            <label for="nome">Nome prodotto:</label>
                            <input type="text" id="name" name="name" class="form-control" placeholder="Inserisci nome prodotto" value="${product.name}" autofocus>
                        </div>
                        <div class="form-group">
                            <label for="Cognome">Note:</label>
                            <input type="text" id="notes" name="notes" class="form-control" placeholder="Inserisce note" value="${product.notes}">
                        </div>
                        <div class="form-group">
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
                            <label for="logo">Seleziona un nuovo logo: </label>
                            <span id="logo">
                            </span>
                        </div>
                        <div class="form-group">
                            <label for="logo">Aggiungi nuove immagini:</label>
                            <input type="file" id="photos" name="photos" class="form-control" placeholder="Images" multiple="multiple">
                        </div>
                        <div>
                            <c:if test="${not empty product.photoPath}">
                                Remove images:
                                <c:forEach items="${product.photoPath}" var="photo">
                                    <div class="container-img">
                                        <input type="checkbox" id="${photo}" name="removePhotos" value="${photo}">
                                        <label for="${photo}"><img height="50px" src="../images/products/${photo}"  class="fit-image-small img-responsive" alt="Img Prod"></label>
                                    </div>
                                </c:forEach>

                            </c:if>
                        </div>
                        <c:if test="${not empty product.id}"><input type="hidden" name="productId" value="${product.id}"></c:if>
                        <button type="submit" class="btn btn-default acc-btn">Invia</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <br>
    <footer class="container-fluid text-center">
        <p>&copy; 2018, ListeSpesa.it, All right reserved</p> 
    </footer>
</body>
</html>