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
        
        </div>
        <div>
            <form action="UserServlet" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="changeAvatar" value=1>
                <div >
                    <img src="../images/<c:out value="${user.avatarPath}"/>" alt="Avatar" height="80" width="80">
                </div>
                <div>
                    <input type="file" name="avatar" id="avatar" >
                    <label for="avatar">Avatar</label>
                    <img src="${avatarPath}">
                </div>
                <button type="submit" >Save</button>
            </form>
        </div>
        <div>
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

                <input type="text" name="lastName" id="lastname" placeholder="Last name" value="<c:out value="${user.lastName}"/>" required autofocus>
                <label for="lastname">Last name</label>


                <input type="text" name="firstName" id="firstname" placeholder="First name" value="<c:out value="${user.firstName}"/>" required>
                <label for="firstname">Name</label>



                <button type="submit" >Save</button>
                <button type="button" data-dismiss="modal">Cancel</button>

            </form>
        </div>
        <div>
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


                <input type="password" name="oldPassword" id="oldpassword" placeholder="Old password" required>
                <label for="oldpassword">Old Password</label>

                <input type="password" name="newPassword" id="newpassword" placeholder="New password" required>
                <label for="newpassword">New Password</label>

                <input type="password" name="newPassword2" id="newpassword2" placeholder="New password" required>
                <label for="newpassword2">Confirm New Password</label>

                <button type="submit">Save</button>
                <button type="button" data-dismiss="modal">Cancel</button>

            </form>
        </div>
        <div>
            <form action="UserServlet" method="POST">
                <input type="hidden" name="deleteUser" value="1">
                <button type="submit">Elimina</button>
            </form>

            <div align="center">
                <a href="mainpage.html" class="buttonlike-pagecontrol"> Back </a>
            </div>
        </div>
    </body>
</html>
