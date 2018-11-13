<%@page import="db.daos.ProductCategoryDAO"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.entities.ProductCategory"%>
<%@page import="java.util.List"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%! private ProductCategoryDAO productCategoryDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productCategoryDAO = daoFactory.getDAO(ProductCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get product category dao", ex);
        }
    }
%>
<%
    List<ProductCategory> categories;
    categories = productCategoryDAO.getAll();
    pageContext.setAttribute("productCategories", categories);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Modifica categoria</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="../css/default-element.css">
        <link rel="stylesheet" type="text/css" href="../css/form.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    </head>
    <body>
        <div class="container text-center">    
            <h2>Area di creazione categoria Lista</h2><br>
            <h4>Crea una nuova tipologia di categoria per le liste</h4><br>
            <br>
            <div class="col-sm-2">
            </div>
            <div class="col-sm-8">
                <div class="form-container ">
                    <form class="form-signin" action="${pageContext.response.encodeURL("ShoppingListCategoryServlet")}" method="POST" enctype="multipart/form-data">
                        <c:choose>
                            <c:when test="${message==1}">
                                Compila i campi mancanti!
                                <c:if test="${empty shoppingListCategory.name}">Name</c:if>
                                <c:if test="${empty shoppingListCategory.description}">Description</c:if>
                            </c:when>
                        </c:choose>
                        <div class="form-group">
                            <label for="nome">Nome Categoria:</label>
                            <input type="text" id="name" name="name" class="form-control" placeholder="Nome" value="${shoppingListCategory.name}" autofocus>
                        </div>
                        <div class="form-group">
                            <label for="description">Descrizione:</label>
                            <input type="text" id="description" name="description" class="form-control" placeholder="Descrizione" value="${shoppingListCategory.description}">
                        </div>
                        <div class="form-group">
                            <c:if test="${not empty shoppingListCategory.logoPath}">
                                <img src="../images/shoppingListCategories/<c:out value="${shoppingListCategory.logoPath}"/>" alt="Logo" height="80" width="80">
                            </c:if>
                            <label for="logo">Carica un logo per la categoria:</label>
                            <input type="file" id="logo" name="logo" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="categorie">Seleziona le categorie di prodotti che possono essere inserite in questa lista:</label>
                            <div class="checkboxes-group">
                                <c:if test="${not empty productCategories}">
                                    <c:forEach items="${productCategories}" var="productCategory">
                                        <div class="groupped-ckbox">
                                            <input type="checkbox" id="${productCategory.id}" name="productCategories" value="${productCategory.id}" <c:if test="${productCategorySelected.contains(productCategory)}">checked</c:if>>
                                            <label for="${productCategory.id}">${productCategory.name}</label>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>
                        <c:if test="${not empty shoppingListCategory.id}">
                            <input type="hidden" name="shoppingListCategoryId" value="${shoppingListCategory.id}">
                        </c:if>
                        <button type="submit" class="btn btn-default acc-btn">Invia</button>
                    </form>
                </div>
            </div>
        </div>
        <br>
        <footer class="container-fluid text-center">
            <p>&copy; 2018, ListeSpesa.it, All right reserved</p> 
        </footer>
    </body>
</html>