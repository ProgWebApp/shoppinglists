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
                        <h1>Reset della password</h1>      
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
                                        Le password non corrispondono
                                    </c:when>
                                    <c:when test="${message==2}">
                                        La nuova password deve contenere un numero, un carattere maiuscolo e un carattere speciale tra @#$% e deve avere lunghezza min 6 e max 20
                                    </c:when>
                                </c:choose>
                                <div class="form-group">
                                    <label for="password1">Password:</label>
                                    <input type="password" id="password1" name="password1" class="form-control" placeholder="Inserisci password">
                                </div>
                                <div class="form-group">
                                    <label for="password2">Ripeti password:</label>
                                    <input type="password" id="password2" name="password2" class="form-control" placeholder="Reinserisci password">
                                </div>
                                <input type="hidden" name="check" value="${check}">
                                <input type="hidden" name="res" value="2">
                                <button type="submit" class="btn-custom">Salva</button>
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

