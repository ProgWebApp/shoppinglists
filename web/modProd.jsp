<%@page import="db.entities.Product"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ProductDAO"%>
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
    if (request.getSession().getAttribute("product") == null && request.getParameter("productId") != null) {
        Product product = productDao.getByPrimaryKey(Integer.valueOf(request.getParameter("productId")));
        request.getSession().setAttribute("product", product);
    }
%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <title>Modifica prodotto</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/default-element.css">
        <link rel="stylesheet" type="text/css" href="css/immagini.css">
        <link rel="stylesheet" type="text/css" href="css/form.css">
        <link rel="stylesheet" type="text/css" href="css/loghi.css">
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        
        </head>
        <body>
            <div class="container text-center">    
            <h2>Area di modifica del prodotto</h2><br>
            <h4>Modifica le caratteristiche e le immagini del prodotto</h4><br>
            <br>
            <div class="col-sm-2">
            </div>
            <div class="col-sm-8">
                <div class="form-container ">
                    <form class="form-signin" action="${pageContext.response.encodeURL("ProductServlet")}" method="POST" enctype="multipart/form-data">

                        <c:choose>
                            <c:when test="${message==1}">
                                Compila i campi mancanti!
                                <c:if test="${empty product.name}">Name</c:if>
                                <c:if test="${empty product.notes}">Notes</c:if>
                            </c:when>
                        </c:choose>
                        <div class="form-group">
                            <label for="nome">Nome prodotto:</label>
                            <input type="text" id="name" name="name" class="form-control" placeholder="Inserisci nome prodotto" value="${product.name}" autofocus>
                        </div>
                        <div class="form-group">
                            <label for="Cognome">Note:</label>
                            <input type="text" id="notes" name="notes" class="form-control" placeholder="Inserisce note" value="${product.notes}">
                        </div>
                        <div class="form-group">
                            <label for="category">Category: </label>
                            <select id="category" name="category" class="form-control" onchange="showIcons('logo', this.value)">
                                <option value="" <c:if test="${empty product.productCategoryId}">selected</c:if> disabled>Select category...</option>
                                <c:forEach items="${categories}" var="category">
                                    <option value="${category.id}" <c:if test="${category.id==product.productCategoryId}">selected</c:if>>${category.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="logo">Aggiungi nuove immagini:</label>
                            <input type="file" id="photos" name="photos" class="form-control" placeholder="Images" multiple="multiple">
                        </div>

                        <div class="form-group">
                            <label for="categorie">Seleziona le immagini che vuoi rimuovere:</label>
                            </b>            
                            <div class="row">
                                <c:forEach items="${product.photoPath}" var="photo">
                                    <div class="container-img">
                                        <input type="checkbox" id="${photo}" name="removePhotos" value="${photo}" class="checkbox-img">
                                        <img src="../images/products/${photo}" class="fit-image-small img-responsive" alt="Img Prod">
                                    </div>



                                </c:forEach>
                            </div>
                        </div>
                        <c:if test="${not empty product.id}"><input type="hidden" name="productId" value="${product.id}"></c:if>
                            <button type="submit" class="btn btn-default acc-btn">Invia</button>
                        </form>
                    </div>
                    <h3><a style="color:black" href="mainpagenologged.html"><span class="glyphicon glyphicon-home"></span> Home</a></h3>
                </div>

            </div>


            <footer class="container-fluid text-center">
                <p>&copy; 2018, ListeSpesa.it, All right reserved</p> 
            </footer>
        <c:remove var="message" scope="session" />
        <c:remove var="product" scope="session" />
    </body>
</html>
