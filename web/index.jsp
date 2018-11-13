<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>ListeSpesa</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/default-element.css">
        <link rel="stylesheet" type="text/css" href="css/main-panel.css">
        <link rel="stylesheet" type="text/css" href="css/immagini.css">
    </head>
    <body>

        <div class="jumbotron">
            <div class="container text-center">
                <h1>ListeSpesa</h1>      
                <p>Crea le tue liste per portarle sempre con te</p>
            </div>
        </div>

        <nav class="navbar navbar-inverse">
            <div class="container-fluid">

                <ul class="nav navbar-nav navbar-right">
                    <c:choose>
                        <c:when test="${not empty user}">
                            <li><a href="${pageContext.response.encodeURL("restricted/user.jsp")}" style="color:white"><span class="glyphicon glyphicon-user"></span> PROFILO</a></li>
                            <li><a href="${pageContext.response.encodeURL("Logout")}" style="color:white"><span class="glyphicon glyphicon-log-out"></span> LOGOUT</a></li>
                        </c:when>
                        <c:when test="${empty user}">
                            <li><a href="login.jsp" style="color:white"><span class="glyphicon glyphicon-log-out"></span> LOGIN</a></li>
                        </c:when>
                    </c:choose>
                    <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" style="color:white" href="#"><span class="glyphicon glyphicon-menu-hamburger"></span>MEN&Ugrave;</a>
                        <ul class="dropdown-menu">
                            <li><a href="#">Le mie liste</a></li>
                            <li><a href="#">Nuova lista</a></li>
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


                <form class="navbar-form" role="search">
                    <div class="input-group col-xs-5">
                        <input type="text" class="form-control" placeholder="Cerca Prodotti..." id="cerca">
                        <div class="input-group-btn">
                            <button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search"></i></button>
                        </div>
                    </div>
                </form>


            </div>
        </nav>

        <div class="container">    
            <div class="row">
                <div class="col-sm-4">
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">FERRAMENTA</div>
                        <div class="panel-body"><a href="#"><img src="ferra.jpg" class="fit-image img-responsive" alt="Ferramenta"></a></div>
                        <div class="panel-footer-custom">Visualizza articoli di ferramenta</div>
                    </div>
                </div>
                <div class="col-sm-4"> 
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">ALIMENTARI</div>
                        <div class="panel-body"><a href="#"><img src="alimentare.jpg" class="fit-image img-responsive" alt="Image"></a> </div>
                        <div class="panel-footer-custom">Visualizza articoli di alimentari</div>
                    </div>
                </div>
                <div class="col-sm-4"> 
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">FARMACIA</div>
                        <div class="panel-body"><img src="farmacia.jpg" class="fit-image img-responsive" alt="Image"></div>
                        <div class="panel-footer-custom">Visualizza articoli di categoria</div>
                    </div>
                </div>
            </div>
        </div><br>

        <div class="container">    
            <div class="row">
                <div class="col-sm-4">
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">CATEGORIA</div>
                        <div class="panel-body"><img src="https://placehold.it/150x80?text=IMAGE" class="fit-image img-responsive" alt="Image"></div>
                        <div class="panel-footer-custom">Visualizza articoli di categoria</div>
                    </div>
                </div>
                <div class="col-sm-4"> 
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">CATEGORIA</div>
                        <div class="panel-body"><img src="https://placehold.it/150x80?text=IMAGE" class="fit-image img-responsive" alt="Image"></div>
                        <div class="panel-footer-custom">Visualizza articoli di categoria</div>
                    </div>
                </div>
                <div class="col-sm-4"> 
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">CATEGORIA</div>
                        <div class="panel-body"><img src="https://placehold.it/150x80?text=IMAGE" class="fit-image img-responsive" alt="Image"></div>
                        <div class="panel-footer-custom">Visualizza articoli di categoria</div>
                    </div>
                </div>
            </div>
        </div><br><br>

        <footer class="container-fluid text-center">
            <p>&copy; 2018, ListeSpesa.it, All right reserved</p>  

        </footer>
    </body>
</html>