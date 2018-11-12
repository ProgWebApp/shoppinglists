<%@page import="db.entities.ProductCategory"%>
<%@page import="db.daos.ProductCategoryDAO"%>
<%@page import="java.util.List"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ShoppingListCategoryDAO"%>
<%@page import="db.entities.ShoppingListCategory"%>
<%@page import="db.entities.User"%>
<%@page import="db.daos.ProductDAO"%>
<%@page import="db.entities.Product"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%! private ProductCategoryDAO productCategoryDao;
    private ShoppingListCategoryDAO shoppingListCategoryDao;
    private ProductDAO productDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productCategoryDao = daoFactory.getDAO(ProductCategoryDAO.class);
            shoppingListCategoryDao = daoFactory.getDAO(ShoppingListCategoryDAO.class);
            productDao = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for productcategory storage system", ex);
        }

    }

%>
<%
    List<ProductCategory> productCategories = productCategoryDao.getAll();
    pageContext.setAttribute("productCategories", productCategories);

    List<ShoppingListCategory> shoppingListCategories = shoppingListCategoryDao.getAll();
    pageContext.setAttribute("shoppingListCategories", shoppingListCategories);

    User user = (User) request.getSession().getAttribute("user");
    List<Product> products;
    if (user.isAdmin()) {
        products = productDao.getPublic();
    } else {
        products = productDao.getByUser(user.getId());
    }
    pageContext.setAttribute("products", products);
%>

<!DOCTYPE html>
<html lang="it">
    <head>
        <title>I miei prodotti</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/default-element.css">
        <link rel="stylesheet" type="text/css" href="css/liste.css">
        <link rel="stylesheet" type="text/css" href="css/panel-custom.css">
        <link rel="stylesheet" type="text/css" href="css/tabs-nav.css">
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        
    </head>
    <body>
        <div class="container-fluid">
            <div class="jumbotron">
                <h2>Le mie creazioni</h2>
                <h4>Riepilogo delle categorie e dei prodotti che hai creato</h4>
            </div>
            <nav class="navbar navbar-inverse">
                <div class="container-fluid">
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="utente.html" style="color:white"><span class="glyphicon glyphicon-user"></span> PROFILO</a></li>
                        <li><a href="mainpagenologged.html" style="color:white"><span class="glyphicon glyphicon-log-out"></span> LOGOUT</a></li>
                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" style="color:white" href="#"><span class="glyphicon glyphicon-menu-hamburger"></span>MEN&Ugrave;</a>
                            <ul class="dropdown-menu">
                                <li><a href="#">Le mie liste</a></li>
                                <li><a href="#">Nuova lista</a></li>
                                <li>
                                    <hr>
                                </li>
                                <li><a href="#">I miei prodotti</a></li>
                                <li><a href="#">Aggiungi prodotto</a></li>
                                <li>
                                    <hr>
                                </li>
                                <li><a href="#">Categorie lista</a></li>
                                <li><a href="#">Nuova categoria lista</a></li>
                                <li><a href="#">Categorie prodotto</a></li>
                                <li><a href="#">Nuova categoria prodotto</a></li>
                            </ul>
                        </li>
                    </ul>
                    <a class="navbar-brand" style="color:white" href="mainpagelogged.html"><span class="glyphicon glyphicon-home"></span> Home</a>
                </div>
            </nav>
            <ul class="nav nav-tabs nav-justified">

                <li class="nav-elem active"><a data-toggle="tab" href="#catList">Categorie lista</a></li>
                <li class="nav-elem"><a data-toggle="tab" href="#catProd">Categorie prodotti</a></li>
                <li class="nav-elem"><a data-toggle="tab" href="#prods">I miei prodotti</a></li>
            </ul>

            <div class="col-sm-3">
            </div>

            <div class="col-sm-6">

                <div class="tab-content">

                    <div id="catList" class="tab-pane fade in active">
                        <div class="panel panel-default-custom">
                            <div class="panel-heading-custom-list">
                                <h3>Categorie liste della spesa</h3>
                            </div>
                            <div class="panel-body-custom-list">
                                <div class="pre-scrollable">
                                    <ul class="list-group">
                                        <c:forEach items="${shoppingListCategories}" var="shoppingListCategory">
                                            <li class="list-group-item justify-content-between align-items-center dropdown">
                                                <div class="dropdown pull-left" style="cursor: pointer;" data-toggle="dropdown">
                                                    <img src="../images/shoppingListCategories/${shoppingListCategory.logoPath}" alt="Logo" class="small-logo"> 
                                                    ${shoppingListCategory.name}
                                                </div>
                                                <ul class="dropdown-menu dd-list">
                                                    <li>Descrizione: ${shoppingListCategory.description}
                                                </ul>
                                                <a class="pull-right" style="color:red" href="#" title="Elimina"><span class="glyphicon glyphicon-remove"></span></a>
                                                <a class="pull-right" style="color:black;margin-right:5px;" href="${pageContext.response.encodeURL("shoppingListCategory.jsp?shoppingListCategoryId=".concat(shoppingListCategory.id))}" title="Modifica"><span class="glyphicon glyphicon-pencil"></span></a>
                                            </li>
                                        </c:forEach>
                                        <button type="button" class="list-group-item list-group-item-action-list">Crea nuova categoria liste</button>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                
                <div id="catProd" class="tab-pane fade">
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom-list">
                            <h3>Categorie prodotti</h3>
                        </div>
                        <div class="panel-body-custom-list">
                            <div class="pre-scrollable">
                                <c:forEach items="${productCategories}" var="productCategory">
                                    <li class="list-group-item justify-content-between align-items-center dropdown">
                                        <div class="dropdown pull-left" style="cursor: pointer;" data-toggle="dropdown">
                                            <img src="../images/productCategories/${productCategory.logoPath}" alt="Logo" class="small-logo"> 
                                            ${productCategory.name}
                                        </div>
                                        <ul class="dropdown-menu dd-list">
                                            <li>Descrizione: ${productCategory.description}
                                        </ul>
                                        <a class="pull-right" style="color:red" href="#" title="Elimina"><span class="glyphicon glyphicon-remove"></span></a>
                                        <a class="pull-right" style="color:black;margin-right:5px;" href="${pageContext.response.encodeURL("Productcategory.jsp?productCategoryId=".concat(productCategory.id))}" title="Modifica"><span class="glyphicon glyphicon-pencil"></span></a>
                                    </li>
                                </c:forEach>
                                <button type="button" class="list-group-item list-group-item-action-list">Crea nuova categoria prodotti</button>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                

                <div id="prods" class="tab-pane fade">

                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom-list">
                            <h3>Prodotti</h3>
                        </div>
                        <div class="panel-body-custom-list">
                            <div class="pre-scrollable">
                                <ul class="list-group">
                                    <c:forEach items="${products}" var="product">
                                        <li class="list-group-item justify-content-between align-items-center dropdown">
                                            <div class="dropdown pull-left" style="cursor: pointer;" data-toggle="dropdown">
                                                <img src="../images/productCategories/icons/${product.logoPath}" class="small-logo" alt="img">
                                                ${product.name}
                                            </div>
                                            <ul class="dropdown-menu dd-list">
                                                <li>Note: ${product.notes}
                                            </ul>
                                            <a class="pull-right" style="color:red" href="#" title="Elimina"><span class="glyphicon glyphicon-remove"></span></a>
                                            <a class="pull-right" style="color:black;margin-right:5px;" href="${pageContext.response.encodeURL("product?res=1&productId=".concat(product.id))}" title="Modifica"><span class="glyphicon glyphicon-pencil"></span></a>
                                        </li>
                                    </c:forEach>
                                    <button type="button" href="${pageContext.response.encodeURL("product?res=2")}" class="list-group-item list-group-item-action-list">Crea nuovo prodotto</button>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
</div>
            </div>

        </div>
        <footer class="container-fluid text-center">
            <p>&copy; 2018, ListeSpesa.it, All right reserved</p>
        </footer>
    </body>
</html>
