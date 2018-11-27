<%@page import="db.entities.User"%>
<%@page import="java.util.List"%>
<%@page import="db.entities.Product"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%! private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productDAO = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
        }
    }
%>
<%
    User user = (User) request.getSession().getAttribute("user");
    String query = request.getParameter("query");
    System.out.println("query: "+query);
    List<Product> products;
    System.out.println("user: "+user);
    if (user == null) {
        if (query.isEmpty()) {
            products = productDAO.getPublic();
        } else {
            products = productDAO.searchByName(query, null);
        }
    } else {
        if (query==null || query.isEmpty()) {
            if(user.isAdmin()){
                products = productDAO.getPublic();
            }else{
                products = productDAO.getByUser(user.getId());
            }
        } else {
            products = productDAO.searchByName(query, user.getId());
        }
    }
    request.setAttribute("products", products);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My products</title>
        <%@include file="include/generalMeta.jsp" %>

    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>I miei prodotti</h1>      
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp" %>
            </div>
            <div id="body" class="myContainer row">
                <c:forEach items="${products}" var="product">
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <c:choose>
                            <c:when test="${not empty user}">
                                <div class="panel panel-default-custom" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet?res=1&productId=").concat(product.id))}'">
                                </c:when>
                                <c:when test="${empty user}">
                                    <div class="panel panel-default-custom" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("ProductPublic?productId=").concat(product.id))}'">
                                    </c:when>
                                </c:choose>
                                <div class="panel-heading-custom" >
                                    <img src="${contextPath}images/productCategories/icons/${product.logoPath}" alt="Logo" class="small-logo" height="40px" width="40px"> 
                                    ${product.name}
                                </div>
                                <c:forEach items="${product.photoPath}" var="photo" end="0">
                                    <img class="item fit-image img-responsive" src="${contextPath}images/products/${photo}"  alt="${product.name}">
                                </c:forEach>
                                <div class="panel-footer-custom"></div>
                            </div>
                        </div>
                    </c:forEach>
                    <br>
                    <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/productForm.jsp"))}">Aggiungi prodotto</a>
                </div>
                <%@include file="include/footer.jsp" %>
            </div>
    </body>
</html>
