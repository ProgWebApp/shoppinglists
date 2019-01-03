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
            function deleteList(list) {
                document.getElementById('to-list-btn').onclick = function() { deleteShoppingListCategory(list);};
                $("#myModal2").modal("show");
            }
            function deleteprod(prod) {
                document.getElementById('to-prod-btn').onclick = function() { deleteProductCategory(prod);};
                $("#myModal").modal("show");
            }
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
                            <button type="button" class="list-btn-custom" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/shoppingListCategoryForm.jsp"))}'">Crea nuova categoria liste</button>
                            <div class="pre-scrollable">
                                <ul class="list-group">
                                    <c:forEach items="${shoppingListCategories}" var="shoppingListCategory">
                                        <li id="list${shoppingListCategory.id}" class="list-group-item group-item-custom my-list-item">
                                            <div class="list-element" style="cursor:default;">
                                                <div class="my-text-content">
                                                    ${shoppingListCategory.name}
                                                </div>
                                            </div>
                                            <div class="list-actions">
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/rubbish.png" onclick="deleteList(${shoppingListCategory.id})" title="Elimina">
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/edit.png" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListCategoryServlet?res=2&shoppingListCategoryId=").concat(shoppingListCategory.id))}'" title="Modifica">
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <label class="list-title"> Categorie prodotti </label>
                            <button type="button" class="list-btn-custom" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/productCategoryForm.jsp"))}'">Crea nuova categoria prodotti</button>
                            <div class="pre-scrollable">
                                <ul class="list-group">
                                    <c:forEach items="${productCategories}" var="productCategory">
                                        <li id="prod${productCategory.id}" class="list-group-item group-item-custom my-list-item">
                                            <div class="list-element" onclick="window.location.href = '${contextPath}restricted/ProductCategoryServlet?res=1&productCategoryId=${productCategory.id}'" title="Visualizza">
                                                <div class="my-text-content">
                                                    ${productCategory.name}
                                                </div>
                                            </div>
                                            <div class="list-actions">
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/rubbish.png" onclick="deleteprod(${productCategory.id})" title="Elimina">
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/edit.png" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/ProductCategoryServlet?res=2&productCategoryId=").concat(productCategory.id))}'" title="Modifica">
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
        <div class="modal fade" id="myModal" role="elimina">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Attenzione!</h4>
                    </div>
                    <div class="modal-body">
                        <p>Sei sicuro di voler eliminare questa categoria? Così facendo esso verranno eliminati anche tutti i prodotti appartenenti</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" id="to-prod-btn" class="btn-del" data-dismiss="modal">Elimina</button>
                        <button type="button" class="btn-custom" data-dismiss="modal">Annulla</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="myModal2" role="elimina">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Attenzione!</h4>
                    </div>
                    <div class="modal-body">
                        <p>Sei sicuro di voler eliminare questa categoria? Così facendo esso verranno eliminate anche tutte le liste appartenenti</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" id="to-list-btn" class="btn-del" data-dismiss="modal">Elimina</button>
                        <button type="button" class="btn-custom" data-dismiss="modal">Annulla</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
