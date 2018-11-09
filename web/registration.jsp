<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <title>Pagina di Registrazione</title>
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

        footer{
            background-color: #ff6336;
            color: #FFFFFF;
            padding: 25px;
        }

        .form-container{
            background-color: #ffe0cc;
            text-align:left;
            border: 2px solid #ff6336;
            padding: 45px 5px 30px 5px;
        }

        .acc-btn{
            background-color: #ff6336;
            color: #FFFFFF;
            border: 0px;
        }

    </style>
    <body>
        <br>
        <div class="container text-center">    
            <h2>Area di Registrazione</h2><br>
            <h4>Registrati per poter usufruire di tutti i servizi disponibili</h4><br>
            <br>
            <div class="col-sm-2">
            </div>
            <div class="col-sm-8">
                <div class="form-container ">
                    <form class="form-signin" action="RegistrationServlet" method="POST" enctype="multipart/form-data">
                        <c:choose>
                            <c:when test="${message==1}">
                                Compila i campi mancanti!
                                <c:if test="${empty newUser.firstName}">Nome</c:if>
                                <c:if test="${empty newUser.lastName}">Cognome</c:if>
                                <c:if test="${empty newUser.email}">Email</c:if>
                                <c:if test="${empty newUser.password}">Password</c:if>
                                <c:if test="${empty newUser.avatarPath}">Avatar</c:if>
                            </c:when>
                            <c:when test="${message==2}">
                                Email già registrata
                            </c:when>
                        </c:choose>
                        <div class="form-group">
                            <label for="nome">Nome:</label>
                            <input type="text" id="firstName" name="firstName" class="form-control" placeholder="Inserisci nome" value="${newUser.firstName}" autofocus>
                        </div>
                        <div class="form-group">
                            <label for="Cognome">Cognome:</label>
                            <input type="lastName" id="lastName" name="lastName" class="form-control" placeholder="Inserisci cognome" value="${newUser.lastName}">
                        </div>
                        <div class="form-group">
                            <label for="email">Email:</label>
                            <input type="email" id="email" name="email" class="form-control" placeholder="Inserisci Email" value="${newUser.email}">
                        </div>
                        <div class="form-group">
                            <label for="pwd">Password:</label>
                            <input type="password" id="password" name="password" class="form-control" placeholder="Inserisci password">
                        </div>
                        <div class="form-group">
                            <label for="pwd">Ripeti password:</label>
                            <input type="password" id="rep_password" name="rep_password" class="form-control" placeholder="Reinserisci password">
                        </div>
                        <div class="form-group">
                            <label for="avatar">Carica un'immagine da usare come avatar</label>
                            <input type="file" id="avatar" name="avatar" class="form-control" placeholder="Avatar">
                        </div>
                        <div class="checkbox">
                            <label><input type="checkbox" name="remember"> Ho letto e accetto i termini di utilizzo</label>
                        </div>
                        
                        <button type="submit" class="btn btn-default acc-btn">Registrati</button>
                        <br><br>
                        <a style="color:grey" href="log.jsp"> Gi&#224; iscritto? Effettua il login </a>
                    </form>
                </div>
                <h3><a style="color:black" href="mainpagenologged.html"><span class="glyphicon glyphicon-home"></span> Home</a></h3>
            </div>

        </div>
        <br>
        <br>
        <c:remove var="message" scope="session" />
        <c:remove var="newUser" scope="session" />
    </body>
</html>

