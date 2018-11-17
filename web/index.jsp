<%@page import="db.entities.ProductCategory"%>
<%@page import="db.daos.ProductCategoryDAO"%>
<%@page import="java.util.List"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%! private ProductCategoryDAO productCategoryDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productCategoryDao = daoFactory.getDAO(ProductCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for productcategory storage system", ex);
        }
    }

%>
<%
    List<ProductCategory> productCategories = productCategoryDao.getAll();
    pageContext.setAttribute("productCategories", productCategories);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>ListeSpesa</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" crossorigin="anonymous">
        <link rel="stylesheet" type="text/css" href="/shoppinglists/css/default-element.css">
        <link rel="stylesheet" type="text/css" href="/shoppinglists/css/form.css">
        <link rel="stylesheet" type="text/css" href="/shoppinglists/css/immagini.css">
        <link rel="stylesheet" type="text/css" href="/shoppinglists/css/liste.css">
        <link rel="stylesheet" type="text/css" href="/shoppinglists/css/loghi.css">
        <link rel="stylesheet" type="text/css" href="/shoppinglists/css/main-panel.css">
        <link rel="stylesheet" type="text/css" href="/shoppinglists/css/panel-custom.css">
        <link rel="stylesheet" type="text/css" href="/shoppinglists/css/table.css">
        <link rel="stylesheet" type="text/css" href="/shoppinglists/css/tabs-nav.css">
    </head>
    <body>
        <div id="container">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>ListeSpesa</h1>      
                        <p>Crea le tue liste per portarle sempre con te</p>
                    </div>
                </div>
                <%@include file="include/navbar.jsp"%>
            </div>
            <div id="body">
                <div class="container">    
                    <c:forEach items="${productCategories}" var="productCategory">
                        <div class="col-sm-4">
                            <div class="panel panel-default-custom">
                                <c:choose>
                                    <c:when test="${not empty user}">
                                        <div class="panel-heading-custom" onclick="window.location.href = '/shoppinglists/restricted/ProductCategoryServlet?res=1&productCategoryId=${productCategory.id}'">${productCategory.name}</div>
                                    </c:when>
                                    <c:when test="${empty user}">
                                        <div class="panel-heading-custom" onclick="window.location.href = '/shoppinglists/ProductCategoryPublic?productCategoryId=${productCategory.id}'">${productCategory.name}</div>
                                    </c:when>
                                </c:choose>
                                <div class="panel-body"><img src="../images/productCategories/${productCategory.logoPath}" class="fit-image img-responsive" alt="${productCategory.name}"></div>
                                <div class="panel-footer-custom">Visualizza articoli di ${productCategory.name}</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <div id="footer">
                <%@include file="include/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
