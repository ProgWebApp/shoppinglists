<!DOCTYPE html>
<html>
    <head>
        <title>TODO supply a title</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
        <form action="RegistrationServlet" method="POST" enctype="multipart/form-data">
            Nome: <input type="text" name="firstName">
            Cognome: <input type="text" name="lastName">
            Email: <input type="text" name="email">
            Password: <input type="password" name="password">
            Avatar: <input type="file" name="avatar">
            <input type="submit" value="Registrati"/>
        </form>
    </body>
</html>
