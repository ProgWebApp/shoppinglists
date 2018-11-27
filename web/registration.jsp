<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Pagina di Registrazione</title>
        <%@include file="include/generalMeta.jsp" %>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>Area di registrazione</h1>      
                        <p>Registrati per poter usufruire di tutti i servizi disponibili</p>
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp" %>
            </div>
            <div id="body">
                <div class="container text-center"> 
                    <div class="col-sm-2">
                    </div>
                    <div class="col-sm-8">
                        <div class="form-container ">
                            <form class="form-signin" action="${pageContext.response.encodeURL(contextPath.concat("RegistrationServlet"))}" method="POST" enctype="multipart/form-data">
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
                                    <c:when test="${message==3}">
                                        Le password non corrispondono
                                    </c:when>
                                    <c:when test="${message==4}">
                                        La nuova password deve contenere un numero, un carattere maiuscolo e un carattere speciale tra @#$% e deve avere lunghezza min 6 e max 20
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
                                    <input type="password" id="password1" name="password1" class="form-control" placeholder="Inserisci password">
                                </div>
                                <div class="form-group">
                                    <label for="pwd">Ripeti password:</label>
                                    <input type="password" id="password2" name="password2" class="form-control" placeholder="Reinserisci password">
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
                                <a style="color:grey" href="${pageContext.response.encodeURL(contextPath.concat("login.jsp"))}"> Gi&#224; iscritto? Effettua il login </a>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <c:remove var="message" scope="session" />
            <c:remove var="newUser" scope="session" />
            <%@include file="include/footer.jsp" %>
        </div>
    </body>
</html>

