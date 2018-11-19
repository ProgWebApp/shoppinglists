<%@page import="db.daos.ProductCategoryDAO"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.exceptions.DAOFactoryException"%>
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
    pageContext.setAttribute("productCategories", categories);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Modifica categoria</title>
        <%@include file="../include/generalMeta.jsp" %>

    </head>
    <body>
        <div class="jumbotron">
            <div class="container text-center">
                <h2>Area di creazione categoria Lista</h2><br>
                <h4>Crea una nuova tipologia di categoria per le liste</h4><br>

            </div>
        </div>
        <%@include file="../include/navigationBar.jsp"%>
        <div class="container text-center">    
            <br>
            <div class="col-sm-2">
            </div>
            <div class="col-sm-8">
                <div class="form-container ">
                    <form class="form-signin" action="${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListCategoryServlet"))}" method="POST" enctype="multipart/form-data">
                        <c:choose>
                            <c:when test="${message==1}">
                                Compila i campi mancanti!
                                <c:if test="${empty shoppingListCategory.name}">Name</c:if>
                                <c:if test="${empty shoppingListCategory.description}">Description</c:if>
                                <c:if test="${empty pcss}">ProductCategories</c:if>
                            </c:when>
                        </c:choose>
                        <div class="form-group">
                            <label for="nome">Nome Categoria:</label>
                            <input type="text" id="name" name="name" class="form-control" placeholder="Nome" value="${shoppingListCategory.name}" autofocus>
                        </div>
                        <div class="form-group">
                            <label for="description">Descrizione:</label>
                            <input type="text" id="description" name="description" class="form-control" placeholder="Descrizione" value="${shoppingListCategory.description}">
                        </div>
                        <div class="form-group">
                            <c:if test="${not empty shoppingListCategory.logoPath}">
                                <img src="${contextPath}images/shoppingListCategories/<c:out value="${shoppingListCategory.logoPath}"/>" alt="Logo" height="80" width="80">
                            </c:if>
                            <label for="logo">Carica un logo per la categoria:</label>
                            <input type="file" id="logo" name="logo" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="categorie">Seleziona le categorie di prodotti che possono essere inserite in questa lista:</label>
                            <div class="checkboxes-group">
                                <c:if test="${not empty productCategories}">
                                    <c:forEach items="${productCategories}" var="productCategory">
                                        <div class="groupped-ckbox">
                                            <input type="checkbox" id="${productCategory.id}" name="productCategories" value="${productCategory.id}" <c:if test="${productCategoriesSelected.contains(productCategory)||pcss.contains(productCategory.id.toString())}">checked</c:if>>
                                            <label for="${productCategory.id}">${productCategory.name}</label>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>
                        <c:if test="${not empty shoppingListCategory.id}">
                            <input type="hidden" name="shoppingListCategoryId" value="${shoppingListCategory.id}">
                        </c:if>
                        <button type="submit" class="btn btn-default acc-btn">Invia</button>
                    </form>
                </div>
            </div>
        </div>
        <%@include file="../include/footer.jsp" %>
    </body>
</html>