<%@page import="db.entities.ShoppingListCategory"%>
<%@page import="java.util.List"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ShoppingListCategoryDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%! private ShoppingListCategoryDAO shoppingListCategoryDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListCategoryDao = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
        }
    }

%>
<%
    List<ShoppingListCategory> shoppingListCategories = shoppingListCategoryDao.getAll();
    pageContext.setAttribute("shoppingListCategories", shoppingListCategories);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Shopping List Categories</title>
        <%@include file="../include/generalMeta.jsp" %>

    </head>
    <body>
        <div class="jumbotron">
            <div class="container text-center">
                <h1>Categorie di liste della spesa</h1>      

            </div>
        </div>
        <%@include file="../include/navigationBar.jsp"%>

        <c:forEach items="${shoppingListCategories}" var="shoppingListCategory">
            Nome: <a href="${pageContext.response.encodeURL("ShoppingListCategoryServlet?res=1&shoppingListCategoryId=".concat(shoppingListCategory.id))}">${shoppingListCategory.name}</a><br>
            Description: ${shoppingListCategory.description}<br>
            <img height="50px" src="../images/shoppingListCategories/${shoppingListCategory.logoPath}" alt="Logo">
            <br>
        </c:forEach>
        <a href="${pageContext.response.encodeURL("shoppingListCategoryForm.jsp")}">Aggiungi categoria di lista della spesa</a>
        <%@include file="../include/footer.jsp" %>
    </body>
</html>