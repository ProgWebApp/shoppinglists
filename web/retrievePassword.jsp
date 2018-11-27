<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Reset password</title>
        <%@include file="include/generalMeta.jsp" %>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>Dimenticata la password?</h1>
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
                            <form class="form-signin" action="${pageContext.response.encodeURL(contextPath.concat("ResetPasswordServlet"))}" method="POST">
                                <c:choose>
                                    <c:when test="${message==1}">
                                        L'utente cercato non esiste
                                    </c:when>
                                    <c:when test="${message==2}">
                                        Ti è stata mandata una mail per la modifica della password, controlla la tua casella di posta
                                    </c:when>
                                    <c:when test="${message==3}">
                                        C'è stato un errore, ti chiediamo di riprovare
                                    </c:when>
                                </c:choose>
                                <div class="form-group">
                                    <label for="email">Email:</label>
                                    <input type="email" id="email" name="email" class="form-control" placeholder="Inserisci Email">
                                </div>
                                <input type="hidden" name="res" value="1">
                                <button type="submit" class="btn btn-default acc-btn">Salva</button>
                                <br>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <c:remove var="message" scope="session" />
            <%@include file="include/footer.jsp" %>
        </div>
    </body>
</html>

