<%@page import="db.entities.ShoppingListCategory"%>
<%@page import="java.util.List"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.daos.ShoppingListCategoryDAO"%>
<%@page import="db.factories.DAOFactory"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%! private ShoppingListCategoryDAO shoppingListCategoryDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListCategoryDAO = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get product category dao", ex);
        }
    }
%>
<%
    List<ShoppingListCategory> categories;
    categories = shoppingListCategoryDAO.getAll();
    pageContext.setAttribute("categories", categories);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Modifica Liste</title>
        <%@include file="include/generalMeta.jsp" %>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h2>Area di modifica delle liste</h2><br>
                        <h4>Modifica le caratteristiche e le immagini delle liste<br>o creane una nuova</h4><br>
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp"%>
            </div>
            <div id="body">
                <div class="container text-center">    
                    <div class="col-sm-2">
                    </div>
                    <div class="col-sm-8">
                        <div class="form-container ">
                            <c:choose>
                            <c:when test="${empty user}">
                            <form class="form-signin" action="${pageContext.response.encodeURL(contextPath.concat("ShoppingListPublic"))}" method="POST" enctype="multipart/form-data">
                            </c:when>
                            <c:when test="${not empty user}">
                            <form class="form-signin" action="${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListServlet"))}" method="POST" enctype="multipart/form-data">
                            </c:when>
                            </c:choose>
                            <c:choose>
                                <c:when test="${message==1}">
                                Compila i campi mancanti!
                                <c:if test="${empty shoppingList.name}">Name</c:if>
                                <c:if test="${empty shoppingList.description}">Description</c:if>
                                <c:if test="${empty shoppingList.listCategoryId}">Category</c:if>
                                <c:if test="${empty shoppingList.imagePath}">Image</c:if>
                                </c:when>
                                </c:choose>
                                <div class="form-group">
                                    <label for="name">Nome Lista: </label>
                                    <input type="text" id="name" name="name" class="form-control" placeholder="Nome" value="${shoppingList.name}" autofocus>
                                </div>
                                <div class="form-group">
                                    <label for="description">Descrizione Lista: </label>
                                    <input type="text" id="description" name="description" class="form-control" placeholder="Descrizione" value="${shoppingList.description}">
                                </div>
                                <div class="form-group">
                                    <label for="shoppingListCategory">Categoria della lista: </label>
                                    <select id="shoppingListCategory" name="shoppingListCategory" class="form-control">
                                        <option value="" <c:if test="${empty shoppingList.listCategoryId}">selected</c:if> disabled>Seleziona la categoria della Lista...</option>
                                        <c:forEach items="${categories}" var="category">
                                        <option value="${category.id}" <c:if test="${category.id==shoppingList.listCategoryId}">selected</c:if>>${category.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <c:if test="${not empty shoppingList.imagePath}">
                                    <img src="${contextPath}images/shoppingList/<c:out value="${shoppingList.imagePath}"/>" class="big-logo">
                                    </c:if>
                                    <label for="image">Aggiungi nuova immagine:</label>
                                    <input type="file" id="logo" name="image" class="form-control">
                                </div>
                                <c:if test="${not empty shoppingList.id}">
                                <input type="hidden" name="shoppingListId" value="${shoppingList.id}">
                                </c:if>
                                <button type="submit" class="btn-custom">Conferma</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <%@include file="include/footer.jsp" %>
        </div>
    </body>
</html>