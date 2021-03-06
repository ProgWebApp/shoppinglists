<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="it">
    <head>
        <title>Utente</title>
        <%@include file="../include/generalMeta.jsp" %>
        <script>
            function deleteUser() {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        window.location.href = "${pageContext.response.encodeURL(contextPath.concat("index.jsp"))}";
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Bad request!");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossible to delete the user!");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/UserServlet"))}";
                xhttp.open("DELETE", url, true);
                xhttp.send();
            }
        </script>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container">
                        <h1>${user.firstName} ${user.lastName}</h1>
                    </div>
                </div>
                <%@include file="../include/navigationBar.jsp" %>
            </div>
            <div id="body">
                <div class="bod-container">
                    <div class="row">
                        <div class="text-center col-sm-6">
                            <div class="avatarContainer">
                                <img class="avatar-img" src="${contextPath}images/avatars/<c:out value="${user.avatarPath}"/>" alt="Avatar">
                                <label class="avatar-input-img" for="avatar">
                                    Modifica immagine
                                </label>
                            </div>
                            <form action="${pageContext.response.encodeURL(contextPath.concat("restricted/UserServlet"))}" method="POST" enctype="multipart/form-data">
                                <c:choose>
                                    <c:when test="${message==11}">
                                        Impossibile aggiornare il campo
                                    </c:when>
                                </c:choose>
                                <input type="file" name="avatar" id="avatar" class="form-control" onchange="this.form.submit()">
                                <input type="hidden" name="changeAvatar" value=1>
                            </form>
                        </div>
                        <div class=" text-center col-sm-6">
                            <h3>Informazioni personali</h3>
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
                            <button class="btn-del"  data-toggle="modal" data-target="#myModal">Elimina account</button>
                        </div>
                    </div>
                    <br><hr class="divisore"><br>
                    <div class="row text-center">
                        <div class="col-sm-6">
                            <form action="${pageContext.response.encodeURL(contextPath.concat("restricted/UserServlet"))}" method="POST">
                                <h3>Modifica <b>nome</b> e <b>cognome</b></h3>
                                <c:choose>
                                    <c:when test="${message==21}">
                                        Nome e cognome obbligatori
                                    </c:when>
                                    <c:when test="${message==22}">
                                        Impossibile aggiornare i dati
                                    </c:when>
                                    <c:when test="${message==23}">
                                        Utente aggiornato
                                    </c:when>
                                </c:choose>
                                <table class="table table-custom">
                                    <tbody>
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
                                                    <input type="text" name="lastName" class="form-control" id="lastname" placeholder="Last name" value="<c:out value="${user.lastName}"/>">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <input type="hidden" name="changeName" value="1">
                                                <button onclick="this.form.submit()" class="btn-custom">Salva</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                        <div class="col-sm-6">
                            <form action="${pageContext.response.encodeURL(contextPath.concat("restricted/UserServlet"))}" method="POST">
                                <h3>Modifica <b>password</b></h3>
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
                                        Impossibile aggiornare la password
                                    </c:when>
                                    <c:when test="${message==35}">
                                        Password aggiornata
                                    </c:when>
                                    <c:when test="${message==36}">
                                        La nuova password deve contenere un numero, un carattere maiuscolo e un carattere speciale tra @#$% e deve avere lunghezza min 6 e max 20
                                    </c:when>
                                </c:choose>
                                <table class="table table-custom">
                                    <tbody>
                                        <tr>
                                            <td>Vecchia Password</td>
                                            <td>
                                                <div class="input-group ">
                                                    <input type="password" name="oldPassword" id="oldPassword" class="form-control" placeholder="Vecchia password">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Nuova Password</td>
                                            <td>
                                                <div class="input-group ">
                                                    <input type="password" name="newPassword1" id="newPassword1" class="form-control" placeholder="Nuova password">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Conferma Password</td>
                                            <td>
                                                <div class="input-group ">
                                                    <input type="password" name="newPassword2" id="newPassword2" class="form-control" placeholder="Ripeti password">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <input type="hidden" name="changePassword" value=1>
                                                <button onclick="this.form.submit()" class="btn-custom">Salva</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <c:remove var="message" scope="session" />
            <%@include file="../include/footer.jsp" %>
        </div>
        <div class="modal fade" id="myModal" role="elimina">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Attenzione</h4>
                    </div>
                    <div class="modal-body">
                        <p>Sei sicuro di voler eliminare questo Profilo? Cos� facendo non sar� pi� possibile recuperare le liste e i prodotti creati</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-del"  onclick="deleteUser()">Elimina</button>
                        <button type="button" class="btn-custom" data-dismiss="modal">Annulla</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
