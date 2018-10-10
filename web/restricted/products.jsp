<%@page import="java.util.List"%>
<%@page import="db.entities.Product"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    List<Product> products = productDao.getAll();
    pageContext.setAttribute("products", products);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My products</title>
    </head>
    <body>
        <h1>My Products</h1>
    <c:forEach items="${products}" var="product">
        Nome: <a href="${pageContext.response.encodeURL("product.jsp?productId=".concat(product.id))}">${product.name}</a><br>
        Note: ${product.notes}<br>
        Foto: ${product.photoPath}<br>
        <br>
    </c:forEach>
</body>
</html>
