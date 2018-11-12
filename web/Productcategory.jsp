<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <title>Modifica categoria</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/default-element.css">
        <link rel="stylesheet" type="text/css" href="css/form.css">
        <link rel="stylesheet" type="text/css" href="css/loghi.css">
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        
    </head>
    <body>
        <div class="container text-center">    
            <h2>Area di creazione categoria Prodotto</h2><br>
            <h4>Crea una nuova tipologia di categoria per i prodotti</h4><br>
            <br>
            <div class="col-sm-2">
            </div>
            <div class="col-sm-8">
                <div class="form-container ">
                    <form class="form-signin" action="${pageContext.response.encodeURL("ProductCategoryServlet")}" method="POST" enctype="multipart/form-data">

                        <c:choose>
                            <c:when test="${message==1}">
                                Compila i campi mancanti!
                                <c:if test="${empty productCategory.name}">Name</c:if>
                                <c:if test="${empty productCategory.description}">Despcription</c:if>
                                <c:if test="${empty productCategory.logoPath}">Logo</c:if>
                            </c:when>
                        </c:choose>

                        <div class="form-group">
                            <label for="nome">Nome Categoria:</label>
                            <input type="text" id="name" name="name" class="form-control" placeholder="Inserisci nome della categoria" value="${productCategory.name}" autofocus>
                        </div>
                        <div class="form-group">
                            <label for="Cognome">Descrizione:</label>
                            <input type="text" id="description" name="description" class="form-control" placeholder="Inserisci una descrizione" value="${productCategory.description}">
                        </div>
                        <div class="form-group">
                            <img class="big-logo" src="../images/productCategories/${productCategory.logoPath}">
                            <label for="logo">Carica un logo per la categoria prodotto:</label>
                            <input type="file" id="logo" name="logo" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="logo">Carica le icone utilizzabili dai prodotti in questa categoria:</label>
                            <input type="file" id="icons" name="icons" class="form-control" multiple="multiple">
                        </div>
                        <c:if test="${not empty productCategory.iconPath}">

                            <div class="form-group">
                                <label for="categorie">Seleziona le icone che vuoi rimuovere:</label>
                                <div class="row">
                                    <c:forEach items="${productCategory.iconPath}" var="icon">
                                        <div class="container-img">
                                            <input type="checkbox" id="${icon}" name="removeIcons" value="${icon}" class="checkbox-img">
                                            <img src="../images/productCategories/icons/${icon}" class="fit-image-small img-responsive" alt="Icon">
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${not empty productCategory.id}"><input type="hidden" name="productCategoryId" value="${productCategory.id}"></c:if>
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
        <c:remove var="productCategory" scope="session" />
    </body>
</html>
