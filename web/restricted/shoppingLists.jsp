<%@page import="db.entities.User"%>
<%@page import="db.entities.Product"%>
<%@page import="db.daos.ProductDAO"%>
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
    User user = (User) request.getSession().getAttribute("user");
    List<ShoppingList> shoppingLists = new ArrayList();
    if (user != null) {
        shoppingLists.addAll(shoppingListDao.getByUserId(user.getId()));
    } else {
        String userId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("userId")) {
                    userId = cookie.getValue();
                }
            }
        }
        ShoppingList shoppingList = shoppingListDao.getByCookie(userId);
        if (shoppingList != null) {
            shoppingLists.add(shoppingList);
        }
    }
    pageContext.setAttribute("shoppingLists", shoppingLists);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Liste</title>
        <%@include file="../include/generalMeta.jsp" %>
        <style>

            button:focus{
                outline:none;
            }

            a.disabled {
                pointer-events: none;
                cursor: default;
            }
        </style>
        <script>
            function deleteList(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        var element = document.getElementById(id);
                        element.parentNode.removeChild(element);
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Bad request!");
                    } else if (this.readyState === 4 && this.status === 403) {
                        alert("You are not allowed to delete the list!");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossible to delete the list!");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListServlet"))}";
                xhttp.open("DELETE", url + "?shoppingListId=" + id, true);
                xhttp.send();
            }
        </script>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>Liste della spesa di ${user.firstName}</h1>      
                    </div>
                </div>
                <%@include file="../include/navigationBar.jsp"%>
            </div>
            <div id="body">
                <div class="container-fluid">
                    <div class="col-sm-1">
                    </div>
                    <div class="col-sm-5">
                        <div class="pre-scrollable">
                            <ul class="list-group">
                                <c:set var="i" value="0"/>    
                                <c:forEach items="${shoppingLists}" var="shoppingList">
                                    <li id="${shoppingList.id}">
                                        <button type="button" class="list-group-item group-item-custom" data-toggle="collapse" data-target="#anteprima${i}">
                                            <img src="${contextPath}images/shoppingListCategories/${shoppingList.listCategoryIcon}" alt="Logo" class="small-logo" height="40px" width="40px"> 
                                            ${shoppingList.name}${shoppingList.notifications}
                                            <a onclick="deleteList(${shoppingList.id})" class="pull-right" style="color:red" href="#" title="Elimina"><span class="glyphicon glyphicon-remove"></span></a>
                                                <c:choose>
                                                    <c:when test="${empty user}">
                                                    <a class="pull-right" style="color:black" href="${pageContext.response.encodeURL(contextPath.concat("ShoppingListPublic?res=1"))}" title="Modifica"><span class="glyphicon glyphicon-list-alt" style="margin:0px 10px 0px 0px"></span></a>                        </c:when>
                                                    <c:when test="${not empty user}">
                                                    <a class="pull-right" style="color:black" href="${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListServlet?res=1&shoppingListId=").concat(shoppingList.id))}" title="Modifica"><span class="glyphicon glyphicon-list-alt" style="margin:0px 10px 0px 0px"></span></a>                        </c:when>
                                                </c:choose>
                                        </button>
                                    </li>
                                    <c:set var="i" value="${i + 1}"/>
                                </c:forEach>
                                <li>
                                    <button type="button" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("shoppingListForm.jsp"))}'" class="list-group-item list-group-item-action">Aggiungi nuova lista </button>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-sm-5">
                        Clicca su una lista per vedere l'anteprima dei prodotti contenuti...
                        <c:set var="j" value="0" />
                        <c:forEach items="${shoppingLists}" var="shoppingList">
                            <div id="anteprima${j}" class="collapse">
                                ${shoppingList.description}
                                <%
                                    List<Product> productList = shoppingListDao.getProducts(((ShoppingList) pageContext.getAttribute("shoppingList")).getId());
                                    pageContext.setAttribute("products", productList);
                                %>
                                <c:forEach items="${products}" var="product">
                                    ${product.name}
                                </c:forEach>
                            </div>
                            <c:set var="j" value="${j + 1}"/>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <%@include file="../include/footer.jsp" %>
        </div>
    </body>
</html>
