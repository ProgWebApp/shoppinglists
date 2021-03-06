<%@page import="db.entities.ProductCategory"%>
<%@page import="db.daos.ProductCategoryDAO"%>
<%@page import="java.util.List"%>
<%@page import="db.exceptions.DAOFactoryException"%>
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
        <title>ListeSpesa</title>
        <%@include file="include/generalMeta.jsp"%>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>ListeSpesa</h1>      
                        <h4>Crea le tue liste per portarle sempre con te</h4>
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp"%>
            </div>
            <div id="body" >
                <div class="container-fluid">
                    <c:forEach items="${productCategories}" var="productCategory">
                        <c:choose>
                            <c:when test="${not empty user}">
                                <div class="panel-default-prods" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/ProductCategoryServlet?res=1&productCategoryId=").concat(productCategory.id))}'">

                                </c:when>
                                <c:when test="${empty user}">
                                    <div class="panel-default-prods" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("ProductCategoryPublic?productCategoryId=").concat(productCategory.id))}'">
                                    </c:when>
                                </c:choose>
                                <div class="panel-heading-prods" >
                                    <div class="panel-heading-title"> 
                                        ${productCategory.name}
                                    </div>
                                </div>
                                <div class="panel-body-prods">
                                    <img src="${contextPath}images/productCategories/${productCategory.logoPath}" class="fit-image img-responsive" alt="${productCategory.name}">
                                </div>
                            </div>

                        </c:forEach>
                    </div>
                </div>
                <%@include file="include/footer.jsp" %>
            </div>
    </body>
</html>
