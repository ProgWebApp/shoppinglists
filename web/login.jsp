<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
        
        <link href="css/generic.css" rel="stylesheet">
    </head>
    <body>
        <form action="LoginServlet" method="POST">
            <div align="center">
                <h3>Authentication Area</h3>
                <p>You must authenticate to access, view, modify and share your Shopping Lists</p>
                <c:choose>
                    <c:when test="${message==1}">
                        Email o password errati
                    </c:when>
                    <c:when test="${message==2}">
                        Account non verificato tramite email
                    </c:when>
                    <c:when test="${message==3}">
                        Registrazione effettuata, clicca sulla mail ricevuta
                    </c:when>
                </c:choose>
            </div>
            <div align="center">
                <input type="email" id="email" name="email" placeholder="Email" required autofocus>
                <label for="email">Email</label>
            </div>
            <div align="center">
                <input type="password" id="password" name="password" placeholder="Password" required>
                <label for="password">Password</label>
            </div>
            <div align="center">
                <label>
                    <input type="checkbox" name="rememberMe" value="true"> Remember me
                </label>
            </div>
            <div align="center"><button type="submit" class="buttonlike">Accedi</button></div>
            <div align="center"><button type="button" class="buttonlike" onclick="window.location.href='registration.jsp'">Iscriviti</button></div>
        </form>
        <c:remove var="message" scope="session" />
    </body>
</html>