<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <title>Pagina di Login</title>
        <%@include file="include/generalMeta.jsp" %>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>Area di login</h1>      
                        <p>Esegui il login per poter usufruire di tutti i servizi disponibili</p>
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp"%>
            </div>
            <div id="body">
                <div class="container text-center">   
                    <div class="col-sm-2">
                    </div>
                    <div class="col-sm-8">
                        <div class="form-container ">
                            <form action="${pageContext.response.encodeURL(contextPath.concat("LoginServlet"))}" method="POST">
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
                                    <c:when test="${message==5}">
                                        Passwors aggiornata con successo!
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
                                <button type="submit" class="btn-custom">Accedi</button>
                                <br><br>
                                <a style="color:#555" href="${pageContext.response.encodeURL(contextPath.concat("retrievePassword.jsp"))}"> Password dimenticata? </a> <br>
                                <a style="color:#555" href="${pageContext.response.encodeURL(contextPath.concat("registration.jsp"))}"> Non ancora iscritto? Registrati! </a>
                            </form>
                            <c:remove var="message" scope="session" />
                        </div>
                    </div>
                </div>
            </div>
            <%@include file="include/footer.jsp" %>
        </div>
    </body>
</html>
