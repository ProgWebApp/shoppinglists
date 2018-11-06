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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <style>
            .navbar {
                margin-bottom: 50px;
                border-radius: 0;
            }

            .navbar-inverse{
                background-color: #ff6336;
                border: 0px;

            }

            .container-img {
                position: relative;
                width: 150px; 
                height: 150px; 
                float: left; 
                margin-left: 20px; 
            }

            .checkbox-img { 
                position: absolute; 
                top: 0px; 
                right: 0px;
                height: 20px;
                width: 20px;
            }

            .fit-image{
                width: 100%;
                object-fit: cover;
                height: 150px;
                width:150px;
            }
            footer{
                background-color: #A0A4E5;
                color: black;
                padding: 25px;
            }

            .form-container{
                background-color: #B9E5FF;
                text-align:left;
                border: 2px solid #A0A4E5;
                padding: 45px 5px 30px 5px;
            }
            .checkboxes-group{
                font: 15px monospace;
                padding: 10px 10px 0px 10px;
                display: flex;
                flex-wrap: wrap;
            }
            .groupped-ckbox{
                flex: 0 0 30%; 
                margin: 5px;
            }
            @media screen  and (max-width:525px){
                .groupped-ckbox{ 
                    flex: 1 0 48%;
                    margin: 5px;
                }}
            </style>
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
                                        <img src="../images/products/${photo}" class="fit-image img-responsive" alt="Img Prod">
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
