<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title> Users List</title>
        <link href="css/generic.css" rel="stylesheet">
    </head>
    <body>
        <br>          


        <div>
            <h3>Profile </h3>
            <br>
            <br>
            <br>
            <br>
        </div>
        <div>

            
            <form action="UserServlet" method="POST">
                <input type="hidden" name="changeAvatar" value=1>
                <div >
                    <input type="file" name="avatar" id="avatar">
                    <label for="avatar">Avatar</label>
                    <img src="${avatarPath}">
                </div><br>
            </form>
            <form action="UserServlet" method="POST">
                <c:choose>
                    <c:when test="${message==21}">
                        Nome e cognome obbligatori
                    </c:when>
                    <c:when test="${message==22}">
                        Utente aggiornato
                    </c:when>
                </c:choose>
                <input type="hidden" name="changeName" value="1">
                <div>
                    <input type="text" name="lastName" id="lastname" placeholder="Last name" value="<c:out value="${user.lastName}"/>" required autofocus>
                    <label for="lastname">Last name</label>
                </div><br>
                <div>
                    <input type="text" name="firstName" id="firstname" placeholder="First name" value="<c:out value="${user.firstName}"/>" required>
                    <label for="firstname">Name</label>
                </div><br>
                </div>
                <div>
                    <button type="submit" >Save</button>
                    <button type="button" data-dismiss="modal">Cancel</button>
                </div>
            </form>

            <br><br>
            <form action="UserServlet" method="POST">
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
                <input type="hidden" name="changePassword" value=1>
                <div>
                    <div >
                        <input type="password" name="oldPassword" id="oldpassword" placeholder="Old password" required>
                        <label for="oldpassword">Old Password</label>
                    </div>
                    <br>
                    <div >
                        <input type="password" name="newPassword" id="newpassword" placeholder="New password" required>
                        <label for="newpassword">New Password</label>
                    </div>
                    <br>
                    <div>
                        <input type="password" name="newPassword2" id="newpassword2" placeholder="New password" required>
                        <label for="newpassword2">Confirm New Password</label>
                    </div>
                    <br>
                    <button type="submit">Save</button>
                    <button type="button" data-dismiss="modal">Cancel</button>
                </div>
            </form>
            <div>
                <br>
                <br>


                <div align="center">
                    <a href="mainpage.html" class="buttonlike-pagecontrol"> Back </a>
                </div>
            </div>
    </body>
</html>
