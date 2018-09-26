<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>TODO supply a title</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
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
        <form action="RegistrationServlet" method="POST" enctype="multipart/form-data">
            Nome: <input type="text" name="firstName" value="${param.firstName}">
            Cognome: <input type="text" name="lastName" value="${param.lastName}">
            Email: <input type="text" name="email" value="${param.email}">
            Password: <input type="password" name="password" value="${param.password}">
            Avatar: <input type="file" name="avatar">
            <input type="submit" value="Registrati"/>
        </form>
        <c:remove var="message" scope="session" />
        <c:remove var="newUser" scope="session" />
    </body>
</html>
