<%@page import="db.entities.ProductCategory"%>
<%@page import="db.daos.ProductCategoryDAO"%>
<%@page import="java.util.List"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ShoppingListCategoryDAO"%>
<%@page import="db.entities.ShoppingListCategory"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%! private ProductCategoryDAO productCategoryDao;
    private ShoppingListCategoryDAO shoppingListCategoryDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productCategoryDao = daoFactory.getDAO(ProductCategoryDAO.class);
            shoppingListCategoryDao = daoFactory.getDAO(ShoppingListCategoryDAO.class);
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
%>

<!DOCTYPE html>
<html>
    <head>
      <title>Le mie categorie</title>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
      <style>
         .jumbotron {
         background-color:#f1f1f1;
         margin-bottom: 0;
         text-align:center;
         padding: 40px 5px 25px 5px;
         }
         footer{
         background-color: #ff6336;
         color: #FFFFFF;
         padding: 25px;
         margin-top: 30px;
         }
         .list-button{
         display:block;
         background-color:#FFFFFF;
         padding: 1px 3px 1px 4px;
         border-radius: 3px 3px;
         margin: 0px 4px 5px 4px;
         border: 0px;
         }
         button.list-group-item-action-list{
         background-color:#B9E5FF;
         color:black;
         margin: 6px 0px 6px 0px;
         border:0px;
         }
         button.list-group-item-action-prod{
         background-color:#9AFF91;
         color:black;
         margin: 6px 0px 6px 0px;
         border:0px;
         }
         .list-group-item{
         font-size:18px;
         height: 70px;
         line-height: 50px;
         }
         .user-list-group{
         font-size:13px;
         }
         .user-list-button{
         display:block;
         background-color:#e6e6e6;
         padding: 0px 2px 0px 2px;
         border-radius: 2px 2px;
         margin: 0px 2px 3px 2px;
         border: 1px solid black;
         }
         button.user-list-group-item-action{
         background-color:#ffe0cc;
         color:black;
         margin: 6px 0px 6px 0px;
         border:0px;
         }
         .panel-heading-custom-list {
         background-color: #B9E5FF;
         padding:0px 0px 6px 7px;
         color: black;
         border: 2px solid #A0A4E5;
         }
         .panel-body-custom-list {
         border:1px solid #A0A4E5;
         margin-top:5px;
         padding:3px;
         }
         .panel-heading-custom-prod {
         background-color: #9AFF91;
         padding:0px 0px 6px 7px;
         color: black;
         border: 2px solid #3FA52B;
         }
         .panel-body-custom-prod {
         border:1px solid #3FA52B;
         margin-top:5px;
         padding:3px;
         }
         div.pre-scrollable{
         min-height:450px;
         max-height:450px;
         }
         .navbar {
         margin-bottom: 50px;
         border-radius: 0;
         }
         .navbar-inverse{
         background-color: #ff6336;
         border: 0px;
         }
         @media screen and (min-width: 1200px) {
         .navbar {
         margin-bottom: 50px;
         border-radius: 0;
         padding-right: 0px;
         padding-left: 150px;
         }}
         .dropdown-menu{
         padding-top:15px;
         }
         .fit-image{
         width: 100%;
         object-fit: cover;
         height: 250px;
         width:200px;
         }
         .small-logo{
         	width: 100%;
         	object-fit: cover;
         	height: 50px;
         	width:50px;
            float:left;
            margin-right:10px;
         }
         .dd-list{
         	padding:0px 15px 0px 15px;
         }
      </style>
   </head>
   
    <body>
      <div class="container-fluid">
         <div class="jumbotron">
            <h2>Le mie categorie</h2>
            <h4>Riepilogo delle categorie create</h4>
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
        <div class="col-sm-1">
         </div>
         <div class="col-sm-5">
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
         <div class="col-sm-5">
            <div class="panel panel-default-custom">
               <div class="panel-heading-custom-prod">
                  <h3>Categorie prodotti</h3>
               </div>
               <div class="panel-body-custom-prod">
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
                        <button type="button" class="list-group-item list-group-item-action-prod">Crea nuova categoria prodotti</button>
                     </ul>
                  </div>
               </div>
            </div>
         </div>
         <div class="col-sm-1">
         </div>
      </div>
      <footer class="container-fluid text-center">
         <p>&copy; 2018, ListeSpesa.it, All right reserved</p>
      </footer>
   </body>
</html>
