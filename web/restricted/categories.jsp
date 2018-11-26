<%@page import="db.entities.ProductCategory"%>
<%@page import="db.daos.ProductCategoryDAO"%>
<%@page import="java.util.List"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ShoppingListCategoryDAO"%>
<%@page import="db.entities.ShoppingListCategory"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%! private ProductCategoryDAO productCategoryDao;
    private ShoppingListCategoryDAO shoppingListCategoryDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productCategoryDao = daoFactory.getDAO(ProductCategoryDAO.class);
            shoppingListCategoryDao = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for productcategory storage system", ex);
        }

    }

%>
<%
    List<ProductCategory> productCategories = productCategoryDao.getAll();
    pageContext.setAttribute("productCategories", productCategories);

    List<ShoppingListCategory> shoppingListCategories = shoppingListCategoryDao.getAll();
    pageContext.setAttribute("shoppingListCategories", shoppingListCategories);
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Le mie categorie</title>
        <%@include file="../include/generalMeta.jsp"%>
    </head>

    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <h2>Le mie categorie</h2>
                    <h4>Riepilogo delle categorie create</h4>
                </div>
                <%@include file="../include/navigationBar.jsp" %>
            </div>
            <div id="body">
                <div class="container-fluid">
                    <div class="col-sm-1">
                    </div>
                    
                    <div class="col-sm-5">
                        <div class="panel-heading-custom-list">
                            <h3>Categorie liste della spesa</h3>
                        </div>
                        <div class="panel-body-custom-list">
                            <div class="pre-scrollable">
                                <ul class="list-group">
                                    <c:forEach items="${shoppingListCategories}" var="shoppingListCategory">
                                        <li class="list-group-item justify-content-between align-items-center dropdown">
                                            <div class="dropdown pull-left" style="cursor: pointer;" data-toggle="dropdown">
                                                <img src="${contextPath}images/shoppingListCategories/${shoppingListCategory.logoPath}" alt="Logo" class="small-logo"> 
                                                ${shoppingListCategory.name}
                                            </div>
                                            <ul class="dropdown-menu dd-list">
                                                <li>Descrizione: ${shoppingListCategory.description}
                                            </ul>
                                            <a class="pull-right" style="color:red" href="#" title="Elimina"><span class="glyphicon glyphicon-remove"></span></a>
                                            <a class="pull-right" style="color:black;margin-right:5px;" href="${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListCategoryServlet?res=2&shoppingListCategoryId=").concat(shoppingListCategory.id))}" title="Modifica"><span class="glyphicon glyphicon-pencil"></span></a>
                                        </li>
                                    </c:forEach>
                                    <button type="button" class="list-group-item list-group-item-action-list">Crea nuova categoria liste</button>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-sm-5">
                        <div class="panel-heading-custom-prod">
                            <h3>Categorie prodotti</h3>
                        </div>
                        <div class="panel-body-custom-prod">
                            <div class="pre-scrollable">
                                <ul class="list-group">
                                    <c:forEach items="${productCategories}" var="productCategory">
                                        <li class="list-group-item justify-content-between align-items-center dropdown">
                                            <div class="dropdown pull-left" style="cursor: pointer;" data-toggle="dropdown">
                                                <img src="${contextPath}images/productCategories/${productCategory.logoPath}" alt="Logo" class="small-logo"> 
                                                ${productCategory.name}
                                            </div>
                                            <ul class="dropdown-menu dd-list">
                                                <li>Descrizione: ${productCategory.description}
                                            </ul>
                                            <a class="pull-right" style="color:red" href="#" title="Elimina"><span class="glyphicon glyphicon-remove"></span></a>
                                            <a class="pull-right" style="color:black;margin-right:5px;" href="${pageContext.response.encodeURL(contextPath.concat("restricted/ProductCategoryServlet?res=2&productCategoryId=").concat(productCategory.id))}" title="Modifica"><span class="glyphicon glyphicon-pencil"></span></a>
                                        </li>
                                    </c:forEach>
                                    <button type="button" class="list-group-item list-group-item-action-prod">Crea nuova categoria prodotti</button>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-sm-1">
                    </div>
                </div>
            </div>
            <%@include file="../include/footer.jsp" %>
        </div>
    </body>
</html>
