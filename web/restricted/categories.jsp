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
                    <div class="container text-center">
                        <h1>Le mie categorie</h1>
                        <p>Riepilogo delle categorie create</p>
                    </div>
                </div>
                <%@include file="../include/navigationBar.jsp" %>
            </div>
            <div id="body">
                <div class="bod-container list-size-cust">
                    <div class="container-fluid">
                        <div class="col-sm-6">
                            <div class="list-title"> Categorie Liste della spesa </div>
                            <div class="pre-scrollable">
                                <ul class="list-group">
                                    <li>
                                        <button onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/shoppingListCategoryForm.jsp"))}'" class="list-group-item creat-but my-list-item">
                                            <div class="width-1 my-text-content">
                                                Aggiungi categoria di lista
                                            </div>
                                            <img class="list-logo-right" src="${contextPath}images/myIconsNav/plus.png">
                                        </button>
                                    </li>
                                    <c:forEach items="${shoppingListCategories}" var="shoppingListCategory">
                                        <li class="list-group-item group-item-custom my-list-item">
                                            <div>
                                                <img src="${contextPath}images/shoppingListCategories/${shoppingListCategory.logoPath}" alt="Logo" class="small-logo list-logo"> 
                                                <div class="my-text-content">
                                                    ${shoppingListCategory.name}
                                                </div>
                                            </div>
                                            <div class="icon-cont">
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/rubbish.png" onclick="" title="Elimina">
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/edit.png" onclick="${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListCategoryServlet?res=2&shoppingListCategoryId=").concat(shoppingListCategory.id))}" title="Modifica">
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="list-title"> Categorie prodotti </div>
                            <div class="pre-scrollable">
                                <ul class="list-group">
                                    <li>
                                        <button onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/productCategoryForm.jsp"))}'" class="list-group-item creat-but my-list-item">
                                            <div class="width-1 my-text-content">
                                                Aggiungi categoria di prodotto
                                            </div>
                                            <img class="list-logo-right" src="${contextPath}images/myIconsNav/plus.png">
                                        </button>
                                    </li>
                                    <c:forEach items="${productCategories}" var="productCategory">
                                        <li class="list-group-item group-item-custom my-list-item">
                                            <div onclick="window.location.href = '${contextPath}restricted/ProductCategoryServlet?res=1&productCategoryId=${productCategory.id}'" title="Visualizza">
                                                <img src="${contextPath}images/productCategories/${productCategory.logoPath}" alt="Logo" class="small-logo list-logo"> 
                                                <div class="my-text-content">
                                                    ${productCategory.name}
                                                </div>
                                            </div>
                                            <div class="icon-cont">
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/rubbish.png" onclick="" title="Elimina">
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/edit.png" onclick="${pageContext.response.encodeURL(contextPath.concat("restricted/ProductCategoryServlet?res=2&productCategoryId=").concat(productCategory.id))}" title="Modifica">
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%@include file="../include/footer.jsp" %>
        </div>
    </body>
</html>
