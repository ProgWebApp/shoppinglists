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
    Integer order;
    if (request.getParameter("order") != null) {
        order = Integer.valueOf(request.getParameter("order"));
    } else {
        order = 1;
    }
    String query = request.getParameter("query");
    List<Product> products;
    if (user == null) {
        if (query == null || query.isEmpty()) {
            products = productDAO.getPublic(order);
        } else {
            products = productDAO.searchByName(query, null, order);
        }
    } else {
        if (query == null || query.isEmpty()) {
            if (user.isAdmin()) {
                products = productDAO.getPublic(order);
            } else {
                products = productDAO.getByUser(user.getId(), order);
            }
        } else {
            products = productDAO.searchByName(query, user.getId(), order);
        }
    }
    pageContext.setAttribute("products", products);
    pageContext.setAttribute("query", query);
    pageContext.setAttribute("order", order);
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
            <div id="body" >
                <div class="row">
                    <div style="float:right;">
                        <button class="btn-custom" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/productForm.jsp"))}'">Aggiungi prodotto</button>
                    </div>
                    <div style="margin-right:10px;float:right;">
                        <form action="products.jsp" method="GET">
                            <select class="select-custom" name="order" onchange="this.form.submit()">
                                <option value="1" <c:if test="${order==1}">selected</c:if>>Nome prodotto A-Z</option> 
                                <option value="2" <c:if test="${order==2}">selected</c:if>>Nome prodotto Z-A</option> 
                                <option value="3" <c:if test="${order==3}">selected</c:if>>Nome categoria A-Z</option>
                                <option value="4" <c:if test="${order==4}">selected</c:if>>Nome categoria Z-A</option>     
                                </select>
                                <input type="hidden" name="query" value="${query}">
                        </form>
                    </div>
                </div>
                <div class="container-fluid" style="margin-top:25px;">
                    <c:forEach items="${products}" var="product">

                        <c:choose>
                            <c:when test="${not empty user}">
                                <div class="panel-default-prods" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet?res=1&productId=").concat(product.id))}'">
                                </c:when>
                                <c:when test="${empty user}">
                                    <div class="panel-default-prods" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("ProductPublic?productId=").concat(product.id))}'">
                                    </c:when>
                                </c:choose>
                                <div class="panel-heading-prods" >
                                    <img style="display:block;" src="${contextPath}images/productCategories/icons/${product.logoPath}" alt="Logo" class="medium-logo"> 
                                    <div class="panel-heading-title">${product.name}</div>
                                </div>
                                <div class="panel-body-prods" >
                                    <c:forEach items="${product.photoPath}" var="photo" end="0">
                                        <img class="fit-image img-responsive" src="${contextPath}images/products/${photo}"  alt="${product.name}">
                                    </c:forEach>
                                </div>
                            </div>

                        </c:forEach>

                    </div>
                </div>
                <%@include file="include/footer.jsp" %>
            </div>
    </body>
</html>
