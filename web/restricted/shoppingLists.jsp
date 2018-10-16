<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="db.entities.ShoppingList"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ShoppingListDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%! private ShoppingListDAO shoppingListDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListDao = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
        }
    }

%>
<%
    List<ShoppingList> shoppingLists = shoppingListDao.getAll();
    pageContext.setAttribute("shoppingLists", shoppingLists);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Shopping Lists</title>
    </head>
    <body>
        <h1>My Shopping Lists</h1>
        <c:forEach items="${shoppingLists}" var="shoppingList">
            Nome: <a href="${pageContext.response.encodeURL("shoppingList.jsp?shoppingListId=".concat(shoppingList.id))}">${shoppingList.name}</a><br>
            Description: ${shoppingList.description}<br>
            <img height="50px" src="../images/shoppingList/${shoppingList.imagePath}" alt="Image">
            <br>
        </c:forEach>
    </body>
</html>
