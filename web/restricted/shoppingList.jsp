<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="db.entities.ShoppingList"%>
<%@page import="db.entities.Product"%>
<%@page import="db.entities.User"%>
<%@page import="db.exceptions.DAOFactoryException"%>
<%@page import="db.factories.DAOFactory"%>
<%@page import="db.daos.ShoppingListDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Lista Alimentari</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" crossorigin="anonymous">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js" crossorigin="anonymous"></script>
        <script>
        //FUNZIONE RICERCA E AGGIUNTA DEI PRODOTTI
        $(function () {
            function formatOption(option) {
                var res = $('<span class="optionClick" onClick="addprod()">' + option.text + '</span>');
                return res;
            }
            $("#autocomplete-2").select2({
                placeholder: "Aggiungi un prodotto",
                allowClear: true,
                ajax: {
                    url: function (request) {
                        return "ProductsSearchServlet?listCategoryId=11&query=" + request.term;
                    },
                    dataType: "json"
                },
                templateResult: formatOption
            });
            $("#autocomplete-2").val(null).trigger("change");
            $('#autocomplete-2').on("select2:select", function () {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        $("#prodotti").append("<li class=\"list-group-item justify-content-between align-items-center\">" + $('#autocomplete-2').find(":selected").text()
                                + " <a class='pull-right' style='color:red' href='ProductListServlet?shoppingListId=${shoppingList.id}&productId=" + $('#autocomplete-2').find(":selected").val() + "&action=0' title='Elimina'>"
                                + "<span class=\"glyphicon glyphicon-remove\"></span></a></li>");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossibile aggiungere il prodotto");
                    }
                };
                var url = "${pageContext.response.encodeURL("ProductListServlet")}";
                xhttp.open("GET", url + "?shoppingListId=${shoppingList.id}&productId=" + $('#autocomplete-2').find(":selected").val() + "&action=3", true);
                xhttp.send();
            });
        });
        //FUNZIONE DI RICERCA E AGGIUNTA DEGLI UTENTI
        $(function () {

            function formatOption(option) {
                var res = $('<span class="optionClick" onClick="addprod()">' + option.text + '</span>');
                return res;
            }
            $("#autocomplete-3").select2({
                placeholder: "Cerca utente...",
                allowClear: true,
                ajax: {
                    url: function (request) {
                        return "UsersSearchServlet?query=" + request.term;
                    },
                    dataType: "json"
                },
                templateResult: formatOption
            });
            $("#autocomplete-3").val(null).trigger("change");
            $('#autocomplete-3').on("select2:select", function () {


                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        $("#utenti").append("<li class=\"list-group-item justify-content-between align-items-center\">" + $('#autocomplete-3').find(":selected").text()
                                + " <a class=\"pull-right\" href=\"#\" title=\"Elimina\"><span class=\"glyphicon glyphicon-remove\" style=\"color:black;font-size:15px;margin-left:5px;\"></span></a>"
                                + " <select class=\"pull-right\">"
                                + "     <option value=\"visualizza\">Visualizza lista</option>"
                                + "     <option value=\"Modifica\">Modifica lista</option>"
                                + " </select>"
                                + " </li>")
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossibile aggiungere l'utente");
                    }
                };
                var url = "${pageContext.response.encodeURL("ShareListsServlet")}";
                xhttp.open("GET", url + "?action=1&shoppingListId=${shoppingList.id}&userId=" + $('#autocomplete-3').find(":selected").val(), true);
                xhttp.send();
            });
        });
        </script>
        <style>
            .jumbotron {
                background-color:#ffffff;
                margin-bottom: 0;
                text-align:center;
                padding: 40px 5px 25px 5px;
            }

            footer{
                background-color: #ff6336;
                color: #FFFFFF;
                padding: 25px;
                margin-top: 30px;
            }

            .list-button{
                display:block;
                background-color:#FFFFFF;
                padding: 1px 3px 1px 4px;
                border-radius: 3px 3px;
                margin: 0px 4px 5px 4px;
                border: 0px;
            }

            button.list-group-item-action{
                background-color:#ffe0cc;
                color:black;
                margin: 6px 0px 6px 0px;
                border:0px;
            }
            .list-group{
                font-size:18px;
            }
            .user-list-group{
                font-size:13px;
            }

            .user-list-button{
                display:block;
                background-color:#e6e6e6;
                padding: 0px 2px 0px 2px;
                border-radius: 2px 2px;
                margin: 0px 2px 3px 2px;
                border: 1px solid black;
            }

            button.user-list-group-item-action{
                background-color:#ffe0cc;
                color:black;
                margin: 6px 0px 6px 0px;
                border:0px;
            }

            div.pre-scrollable{
                min-height:450px;
                max-height:450px;
            }
            .navbar {
                margin-bottom: 50px;
                border-radius: 0;
            }
            @media screen and (min-width: 1200px) {
                .navbar {
                    margin-bottom: 50px;
                    border-radius: 0;
                    padding-right: 0px;
                    padding-left: 150px;
                }

                .navbar-inverse{
                    background-color: #ff6336;
                    border: 0px;
                }
                .dropdown-menu{
                    padding-top:15px;
                }
                .fit-image{
                    width: 100%;
                    object-fit: cover;
                    height: 250px;
                    width:200px;
                }

            </style>
        </head>
        <body>
            <div class="container-fluid">
                <div class="jumbotron">
                    <img src="../images/shoppingList/${shoppingList.imagePath}" class="fit-image" alt="Immagine lista">
                    <h2>${shoppingList.name}</h2>
                    <h4>Categoria: ${shoppingListCategory.name}</h4>
                    <h4>Descrizione: ${shoppingList.description}</h4>
                </div>
                <nav class="navbar navbar-inverse">
                    <div class="container-fluid">
                        <ul class="nav navbar-nav navbar-right">
                            <li><a href="utente.html" style="color:white"><span class="glyphicon glyphicon-user"></span> PROFILO</a></li>
                            <li><a href="mainpagenologged.html" style="color:white"><span class="glyphicon glyphicon-log-out"></span> LOGOUT</a></li>

                            <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" style="color:white" href="#"><span class="glyphicon glyphicon-menu-hamburger"></span>MEN&Ugrave;</a>
                                <ul class="dropdown-menu">
                                    <li><a href="#">Le mie liste</a></li>
                                    <li><a href="#">Nuova lista</a></li>
                                    <li><hr></li>
                                    <li><a href="#">I miei prodotti</a></li>
                                    <li><a href="#">Aggiungi prodotto</a></li>
                                    <li><hr></li>
                                    <li><a href="#">Categorie lista</a></li>
                                    <li><a href="#">Nuova categoria lista</a></li>
                                    <li><a href="#">Categorie prodotto</a></li>
                                    <li><a href="#">Nuova categoria prodotto</a></li>
                                </ul>
                            </li>
                        </ul>  
                        <button type="button" class="navbar-toggle" data-toggle="collapse"></button>
                        <a class="navbar-brand" style="color:white" href="mainpagelogged.html"><span class="glyphicon glyphicon-home"></span> Home</a>
                    </div>
                </nav>
                <div class="col-sm-1">
                </div>
                <div class="col-sm-5">
                    <div class="pre-scrollable">
                        <select id="autocomplete-2" name="autocomplete-2" class="form-control select2-allow-clear">
                        </select>
                        <ul id="prodotti" class="list-group">
                            <c:forEach items="${products}" var="product">
                                <li class="list-group-item justify-content-between align-items-center">${product.name} 
                                    <a class="pull-right" style="color:red" href="ProductListServlet?shoppingListId=${shoppingList.id}&productId=${product.id}&action=0" title="Elimina"><span class="glyphicon glyphicon-remove"></span></a>
                                </li>
                            </c:forEach>
                            <!--<input type="text" class="form-control" placeholder="Cerca prodotto da aggiungere...">-->
                        </ul>
                    </div>
                </div>
                <div class="col-sm-1">
                </div>
                <div class="col-sm-4">
                    <div class="row">
                        <form>
                            <div>
                                <label for="comment">Chat:</label>
                                <textarea class="form-control" rows="10" id="chat" readonly></textarea>
                            </div>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Scrivi messaggio...">
                                <div class="input-group-btn">
                                    <button class="btn btn-default" type="submit">
                                        Invia
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <br>
                    <div class="row">
                        <label> Utenti che condividono la lista: </label>
                        <select id="autocomplete-3" name="autocomplete-3" class="form-control select2-allow-clear">
                        </select>
                        <ul id="utenti" class="list-group user-list-group">
                            <c:forEach items="${users}" var="user">
                                <li class="list-group-item justify-content-between align-items-center">${user.firstName} ${user.lastName}  
                                    <a class="pull-right" href="#" title="Elimina"><span class="glyphicon glyphicon-remove" style="color:black;font-size:15px;margin-left:5px;"></span></a>
                                    <select class="pull-right">
                                        <option value="visualizza">Visualizza lista</option>
                                        <option value="Modifica">Modifica lista</option>
                                    </select>  
                                </li>
                            </c:forEach>
                        </ul>
                    </div>

                </div>

            </div>
            <footer class="container-fluid text-center">
                <p>&copy; 2018, ListeSpesa.it, All right reserved</p>
            </footer>

        </body>
    </html>