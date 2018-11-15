<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <title>Utente</title>
        <%@include file="../include/generalMeta.jsp" %>
        
    </head>
    <body>
        <div class="jumbotron">
            <div class="container">
                <img src="../images/avatars/<c:out value="${user.avatarPath}"/>" alt="Avatar">
                <p>${user.firstName} ${user.lastName}</p>
                <form action="${pageContext.response.encodeURL("UserServlet")}" method="POST" enctype="multipart/form-data">
                    <input type="file" name="avatar" id="avatar" >
                    <input type="hidden" name="changeAvatar" value=1>
                            <button class="btn btn-custom" type="submit" >Salva</button>
                </form>
            </div>
        </div>
        <%@include file="../include/navigationBar.jsp" %>
        <div class="row">
            <div class="col-sm-3">
            </div>

            <div class="container-fluid text-center col-sm-6">
                <h3>Informazioni personali</h3>
                <br>

                <div class="container-fluid">
                    <table class="table table-custom">
                        <tbody>
                            <tr>
                                <td><b>Nome</b></td>
                                <td>${user.firstName}</td>
                            </tr>
                            <tr>
                                <td><b>Cognome</b></td>
                                <td>${user.lastName}</td>
                            </tr>
                            <tr>
                                <td><b>Email</b></td>
                                <td>${user.email}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="container-fluid text-center">
                    <h3>Modifica i tuoi dati</h3>
                    <br>
                    <div class="container-fluid">
                        <form action="${pageContext.response.encodeURL("UserServlet")}" method="POST">
                            <c:choose>
                                <c:when test="${message==21}">
                                    Nome e cognome obbligatori
                                </c:when>
                                <c:when test="${message==22}">
                                    Utente aggiornato
                                </c:when>
                            </c:choose>
                            <table class="table table-custom">
                                <tbody>
                                    <tr>
                                        <td colspan="2">
                                            <h4>Modifica <b>nome</b> e <b>cognome</b></h4>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nome</td>
                                        <td>
                                            <div class="input-group ">
                                                <input type="text" class="form-control" name="firstName" id="firstname" placeholder="First name" value="<c:out value="${user.firstName}"/>">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Cognome</td>
                                        <td>
                                            <div class="input-group">
                                                <input type="text" name="lastName" class="form-control" id="lastname" placeholder="Last name" value="<c:out value="${user.lastName}"/>"autofocus>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <input type="hidden" name="changeName" value="1">
                            
                                            <button type="submit" class="btn btn-custom">Invia</button>
                                            <button type="button" class="btn btn-custom" data-dismiss="modal">Annulla</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                        <form action="${pageContext.response.encodeURL("UserServlet")}" method="POST">
                            <c:choose>
                                <c:when test="${message==31}">
                                    Completare tutti i campi
                                </c:when>
                                <c:when test="${message==32}">
                                    La vecchia password non corrisponde

                                </c:when>
                                <c:when test="${message==33}">
                                    Le nuove password non corrispondono
                                </c:when>
                                <c:when test="${message==34}">
                                    Password aggiornata
                                </c:when>
                            </c:choose>

                            <table class="table table-custom">
                                <tbody>
                                    <tr>
                                        <td colspan="2">
                                            <h4>Modifica <b>password</b></h4>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nuova Password</td>
                                        <td>
                                            <div class="input-group ">
                                                <input type="password" name="newPassword" id="newpassword" placeholder="Nuova password">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Conferma Password</td>
                                        <td>
                                            <div class="input-group ">
                                                <input type="password" name="newPassword2" id="newpassword2" placeholder="Ripeti password">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <input type="hidden" name="changePassword" value=1>
                            
                                            <button type="submit" class="btn btn-custom">Invia</button>
                                            <button type="button" class="btn btn-custom" data-dismiss="modal">Annulla</button>
                                        </td>
                                    </tr>

                                </tbody>
                            </table>
                        </form>
                        <form action="UserServlet" method="POST">
                            MODIFICARE CON RICHIESTA ASINC JAVASCRIPT
                            <input type="hidden" name="deleteUser" value="1">
                            <button class="btn btn-custom" type="submit">Elimina</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
         <%@include file="../include/footer.jsp" %>
    </body>
</html>