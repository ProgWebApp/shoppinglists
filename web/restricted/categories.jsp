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
        <script>
            function deleteProductCategory(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        var element = document.getElementById("prod" + id);
                        element.parentNode.removeChild(element);
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
            function deleteShoppingListCategory(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        var element = document.getElementById("list" + id);
                        element.parentNode.removeChild(element);
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Bad request!");
                    } else if (this.readyState === 4 && this.status === 403) {
                        alert("You are not allowed to delete the shoppingListCategory!");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossible to delete the shoppingListCategory!");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListCategoryServlet"))}";
                xhttp.open("DELETE", url + "?shoppingListCategoryId=" + id, true);
                xhttp.send();
            }
        </script>
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
                            <label class="list-title"> Categorie Liste della spesa </label>
                            <div class="pre-scrollable">
                                <ul class="list-group">
                                    <c:forEach items="${shoppingListCategories}" var="shoppingListCategory">
                                        <li class="list-group-item group-item-custom my-list-item">
                                            <div class="list-element" style="cursor:default;">
                                                <img src="${contextPath}images/shoppingListCategories/${shoppingListCategory.logoPath}" alt="Logo" class="medium-logo list-logo"> 
                                                <div class="my-text-content">
                                                    ${shoppingListCategory.name}
                                                </div>
                                            </div>
                                            <div class="list-actions">
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/rubbish.png" onclick="" title="Elimina">
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/edit.png" onclick="${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListCategoryServlet?res=2&shoppingListCategoryId=").concat(shoppingListCategory.id))}" title="Modifica">
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>

                        <div class="col-sm-6">
                            <label class="list-title"> Categorie prodotti </label>
                            <div class="pre-scrollable">
                                <ul class="list-group">
                                    <c:forEach items="${productCategories}" var="productCategory">
                                        <li class="list-group-item group-item-custom my-list-item">
                                            <div class="list-element" onclick="window.location.href = '${contextPath}restricted/ProductCategoryServlet?res=1&productCategoryId=${productCategory.id}'" title="Visualizza">
                                                <img src="${contextPath}images/productCategories/${productCategory.logoPath}" alt="Logo" class="medium-logo list-logo"> 
                                                <div class="my-text-content">
                                                    ${productCategory.name}
                                                </div>
                                            </div>
                                            <div class="list-actions">
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
