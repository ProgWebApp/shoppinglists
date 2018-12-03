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
                        <div class="panel-heading-custom list-category">
                            <h3>Categorie liste della spesa</h3>
                        </div>
                        <div class="panel-body-custom">
                            <div class="pre-scrollable">
                                <ul class="list-group category-list">
                                    <c:forEach items="${shoppingListCategories}" var="shoppingListCategory">
                                        <li class="list-group-item justify-content-between align-items-center dropdown">
                                            <div class="dropdown pull-left" style="cursor: pointer;" onclick="window.location.href = '${contextPath}restricted/ShoppingListCategoryServlet?res=1&shoppingListCategoryId=${shoppingListCategory.id}'">
                                                <img src="${contextPath}images/shoppingListCategories/${shoppingListCategory.logoPath}" class="small-logo"> 
                                                ${shoppingListCategory.name}
                                            </div>
                                            <a class="pull-right" style="color:red" href="#" title="Elimina"><span class="glyphicon glyphicon-remove"></span></a>
                                            <a class="pull-right" style="color:black;margin-right:5px;" href="${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListCategoryServlet?res=2&shoppingListCategoryId=").concat(shoppingListCategory.id))}" title="Modifica"><span class="glyphicon glyphicon-pencil"></span></a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        <button type="button" class="panel-footer-custom list-category" onclick="window.location.href='shoppingListCategoryForm.jsp'">
                            <h4>Crea nuova categoria liste</h4>
                        </button>
                    </div>

                    <div class="col-sm-5">
                        <div class="panel-heading-custom prod-category">
                            <h3>Categorie prodotti</h3>
                        </div>
                        <div class="panel-body-custom">
                            <div class="pre-scrollable">
                                <ul class="list-group category-list">
                                    <c:forEach items="${productCategories}" var="productCategory">
                                        <li class="list-group-item justify-content-between align-items-center dropdown">
                                            <div class="dropdown pull-left" style="cursor: pointer;" onclick="window.location.href = '${contextPath}restricted/ProductCategoryServlet?res=1&productCategoryId=${productCategory.id}'">
                                                <img src="${contextPath}images/productCategories/${productCategory.logoPath}" class="small-logo"> 
                                                ${productCategory.name}
                                            </div>
                                            <a class="pull-right" style="color:red" href="#" title="Elimina"><span class="glyphicon glyphicon-remove"></span></a>
                                            <a class="pull-right" style="color:black;margin-right:5px;" href="${pageContext.response.encodeURL(contextPath.concat("restricted/ProductCategoryServlet?res=2&productCategoryId=").concat(productCategory.id))}" title="Modifica"><span class="glyphicon glyphicon-pencil"></span></a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        <button type="button" class="panel-footer-custom prod-category " onclick="window.location.href='productCategoryForm.jsp'">
                            <h4>Crea nuova categoria prodotti</h4>
                        </button>
                    </div>

                    <div class="col-sm-1">
                    </div>
                </div>
            </div>
            <%@include file="../include/footer.jsp" %>
        </div>
    </body>
</html>
