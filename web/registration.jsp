<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Registration Area</title>
        <link rel="stylesheet" href="css/generic.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
    </head>
    <body>
        <form class="form-signin" action="RegistrationServlet" method="POST" enctype="multipart/form-data">
            <div class="text-center mb-4">
                <h3>Registration Area</h3>
                <p>You must registrate to access, view, modify and share your Shopping Lists</p>
            </div>
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
            <div class="form-label-group">
                <input type="text" id="firstName" name="firstName" class="form-control" placeholder="First name" value="${newUser.firstName}" autofocus>
                <label for="firstName">First name</label>
            </div>
            <div class="form-label-group">
                <input type="lastName" id="lastName" name="lastName" class="form-control" placeholder="Last name" value="${newUser.lastName}">
                <label for="lastName">Last name</label>
            </div>
            <div class="form-label-group">
                <input type="email" id="email" name="email" class="form-control" placeholder="Email" value="${newUser.email}">
                <label for="email">Email</label>
            </div>
            <div class="form-label-group">
                <input type="password" id="password" name="password" class="form-control" placeholder="Password">
                <label for="password">Password</label>
            </div>
            <div class="form-label-group">
                <input type="file" id="avatar" name="avatar" class="form-control" placeholder="Avatar">
                <label for="avatar">Avatar</label>
            </div>
            <div class="checkbox mb-3">
                <label>
                    <input type="checkbox" name="rememberMe" value="true"> I agree to Terms
                </label>
            </div>
            <button class="buttonlike" type="submit">Register</button>
        </form>
        <c:remove var="message" scope="session" />
        <c:remove var="newUser" scope="session" />
    </body>
</html>