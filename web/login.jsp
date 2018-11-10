<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <title>Pagina di Login</title>
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
            input:focus {
                outline: none;
            }
        </style>
    </head>
    <body>
        <br>
        <div class="container text-center">    
            <h2>Area di Login</h2><br>
            <h4>Esegui il login per poter usufruire di tutti i servizi disponibili</h4><br>
            <br>
            <div class="col-sm-2">
            </div>
            <div class="col-sm-8">
                <div class="form-container ">
                    <form action="LoginServlet" method="POST">
                        <c:choose>
                            <c:when test="${message==1}">
                                Email o password errati
                            </c:when>
                            <c:when test="${message==2}">
                                Account non verificato tramite email, clicca sulla email ricevuta
                            </c:when>
                            <c:when test="${message==3}">
                                Registrazione effettuata, clicca sulla email ricevuta
                            </c:when>
                            <c:when test="${message==4}">
                                Il codice di controllo inserito non è valido
                            </c:when>
                        </c:choose>
                        <div class="form-group">
                            <label for="email">Email:</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="Inserisci Email" required autofocus>
                        </div>
                        <div class="form-group">
                            <label for="password">Password:</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                        </div>
                        <div class="checkbox">
                            <label><input type="checkbox" name="rememberMe" value="true"> Ricordami</label>
                        </div>      
                        <button type="submit" class="btn btn-default acc-btn">Accedi</button>
                        <br><br>
                        <a style="color:grey" href="#"> Password dimenticata? </a> <br>
                        <a style="color:grey" href="registration.jsp"> Non ancora iscritto? Registrati! </a>
                    </form>
                    <c:remove var="message" scope="session" />
                </div>
                <h3><a style="color:black" href="index.html"><span class="glyphicon glyphicon-home"></span> Home</a></h3>
            </div>

        </div>
        <br>
        <br>

    </body>
</html>
