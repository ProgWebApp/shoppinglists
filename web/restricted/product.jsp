<%@page import="db.entities.Product"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ProductDAO"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%! private ProductDAO productDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productDao = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
        }
    }
%>
<%
    if (request.getSession().getAttribute("product") == null && request.getParameter("productId") != null) {
        Product product = productDao.getByPrimaryKey(Integer.valueOf(request.getParameter("productId")));
        request.getSession().setAttribute("product", product);
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Product</title>
        <link rel="stylesheet" href="css/generic.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
    </head>
    <body>
        <form class="form-signin" action="${pageContext.response.encodeURL("ProductServlet")}" method="POST">
            <div class="text-center mb-4">
                <h3>Edit Product</h3>
            </div>
            <c:choose>
                <c:when test="${message==1}">
                    Compila i campi mancanti!
                    <c:if test="${empty product.name}">Name</c:if>
                    <c:if test="${empty product.notes}">Notes</c:if>
                </c:when>
            </c:choose>
            <div class="form-label-group">
                <input type="text" id="name" name="name" class="form-control" placeholder="Name" value="${product.name}" autofocus>
                <label for="name">Name</label>
            </div>
            <div class="form-label-group">
                <input type="text" id="notes" name="notes" class="form-control" placeholder="Notes" value="${product.notes}">
                <label for="notes">Notes</label>
            </div>
            <c:if test="${not empty product.id}"><input type="hidden" name="productId" value="${product.id}"></c:if>
                <button class="buttonlike" type="submit">Confirm</button>
            </form>
        <c:remove var="message" scope="session" />
        <c:remove var="product" scope="session" />
    </body>
</html>