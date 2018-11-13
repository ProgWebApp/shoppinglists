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
    List<ShoppingList> shoppingLists = shoppingListDao.getByUserId(user.getId());
    pageContext.setAttribute("shoppingLists", shoppingLists);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Liste</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/default-element.css">
        <link rel="stylesheet" type="text/css" href="css/liste.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

        <style>

            button:focus{
                outline:none;
            }

            a.disabled {
                pointer-events: none;
                cursor: default;
            }
        </style>
    </head>
    <body>

        <div class="container-fluid">
            <div class="jumbotron">
                <h2>Liste della spesa di ${user.firstName}</h2>
            </div>

            <nav class="navbar navbar-inverse">
                <div class="container-fluid">

                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="utente.html" style="color:white"><span class="glyphicon glyphicon-user"></span> PROFILO</a></li>
                        <li><a href="mainpagenologged.html" style="color:white"><span class="glyphicon glyphicon-log-out"></span> LOGOUT</a></li>

                        <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" style="color:white" href="#"><span class="glyphicon glyphicon-menu-hamburger"></span>MEN&Ugrave;</a>
                            <ul class="dropdown-menu">
                                <li><a href="#" class="disabled">Le mie liste</a></li>
                                <li><a href="#" class="disabled">Nuova lista</a></li>
                                <li><hr></li>
                                <li><a href="#">I miei prodotti</a></li>
                                <li><a href="#">Aggiungi prodotto</a></li>
                                <li><hr></li>
                                <li><a href="#">Categorie lista</a></li>
                                <li><a href="#">Nuova categoria lista</a></li>
                                <li><a href="#">Categorie prodotto</a></li>
                                <li><a href="#">Nuova categoria prodotto</a></li>
                            </ul>
                        </li>
                    </ul>  


                    <button type="button" class="navbar-toggle" data-toggle="collapse"></button>
                    <a class="navbar-brand" style="color:white" href="mainpagelogged.html"><span class="glyphicon glyphicon-home"></span> Home</a>



                </div>
            </nav>

            <div class="col-sm-1">
            </div>
            <div class="col-sm-5">
                <div class="pre-scrollable">
                    <ul class="list-group">
                        <c:set var="i" value="0"/>    
                        <c:forEach items="${shoppingLists}" var="shoppingList">
                            <li>
                                <button type="button" class="list-group-item group-item-custom" data-toggle="collapse" data-target="#anteprima${i}">
                                    <img src="../images/shoppingList/${shoppingList.imagePath}" alt="Logo" class="small-logo" height="40px" width="40px"> 
                                    ${shoppingList.name}
                                    <a class="pull-right" style="color:red" href="#" title="Elimina"><span class="glyphicon glyphicon-remove"></span></a>
                                    <a class="pull-right" style="color:black" href="${pageContext.response.encodeURL("ShoppingListServlet?res=1&shoppingListId=".concat(shoppingList.id))}" title="Modifica"><span class="glyphicon glyphicon-list-alt" style="margin:0px 10px 0px 0px"></span></a>
                                </button>

                            </li>
                            <c:set var="i" value="${i + 1}"/>
                        </c:forEach>
                        <li>
                            <button type="button" onclick="window.location.href='${pageContext.response.encodeURL("shoppingListForm.jsp")}'" class="list-group-item list-group-item-action">Aggiungi nuova lista </button>
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

        <footer class="container-fluid text-center">
            <p>&copy; 2018, ListeSpesa.it, All right reserved</p>
        </footer>
    </body>
</html>
