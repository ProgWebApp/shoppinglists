<%@page import="db.entities.ProductCategory"%>
<%@page import="db.daos.ProductCategoryDAO"%>
<%@page import="java.util.List"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.factories.DAOFactory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%! private ProductCategoryDAO productCategoryDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productCategoryDao = daoFactory.getDAO(ProductCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for productcategory storage system", ex);
        }
    }

%>
<%
    List<ProductCategory> productCategories = productCategoryDao.getAll();
    pageContext.setAttribute("productCategories", productCategories);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Categories</title>
    </head>
    <body>
        <h1>My Products</h1>
        <c:forEach items="${productCategories}" var="productCategory">
            Nome: <a href="${pageContext.response.encodeURL("productCategory.jsp?productCategoryId=".concat(productCategory.id))}">${productCategory.name}</a><br>
            Description: ${productCategory.description}<br>
            <img height="50px" src="../images/productCategories/${productCategory.logoPath}">
            <br>
        </c:forEach>
    </body>
</html>
