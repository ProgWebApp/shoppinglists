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
        <title>Edit Shopping List</title>
        <link rel="stylesheet" href="css/generic.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
    </head>
    <body>
        <form class="form-signin" action="${pageContext.response.encodeURL("ShoppingListServlet")}" method="POST" enctype="multipart/form-data">
            <div class="text-center mb-4">
                <h3>Edit Shopping List</h3>
            </div>
            <c:choose>
                <c:when test="${message==1}">
                    Compila i campi mancanti!
                    <c:if test="${empty shoppingList.name}">Name</c:if>
                    <c:if test="${empty shoppingList.description}">Description</c:if>
                    <c:if test="${empty shoppingList.listCategoryId}">Category</c:if>
                    <c:if test="${empty shoppingList.imagePath}">Image</c:if>
                </c:when>
            </c:choose>
            <div class="form-label-group">
                <label for="name">Name: </label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Name" value="${shoppingList.name}" autofocus>
            </div>
            <div class="form-label-group">
                <label for="description">Description: </label>
                <input type="text" id="description" name="description" class="form-control" placeholder="Description" value="${shoppingList.description}">
            </div>
            <div class="form-label-group">
                <label for="shoppingListCategory">Shopping list category: </label>
                <select id="shoppingListCategory" name="shoppingListCategory" class="form-control">
                    <option value="" <c:if test="${empty shoppingList.listCategoryId}">selected</c:if> disabled>Select shopping list category...</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}" <c:if test="${category.id==shoppingList.listCategoryId}">selected</c:if>>${category.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-label-group">
                <c:if test="${not empty shoppingList.imagePath}">
                <img src="../images/shoppingList/<c:out value="${shoppingList.imagePath}"/>" alt="Image" height="80" width="80">
                </c:if>
                <label for="image">Image</label>
                <input type="file" id="logo" name="image" class="form-control">
            </div>
            <c:if test="${not empty shoppingList.id}"><input type="hidden" name="shoppingListId" value="${shoppingList.id}"></c:if>
                <button class="buttonlike" type="submit">Confirm</button>
            </form>
        <c:remove var="message" scope="session" />
        <c:remove var="shoppingList" scope="session" />
    </body>
</html>