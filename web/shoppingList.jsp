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
        <%@include file="include/generalMeta.jsp" %>
        <script>
            /* FUNZIONE RICERCA E AGGIUNTA DEI PRODOTTI */
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
            <c:choose>
                <c:when test="${empty user}">
                            return "${pageContext.response.encodeURL(contextPath.concat("ProductsSearchPublic?shoppingListId=").concat(shoppingList.id).concat("&query="))}" + request.term;
                </c:when>
                <c:when test="${not empty user}">
                            return "${pageContext.response.encodeURL(contextPath.concat("ProductsSearchServlet?shoppingListId=").concat(shoppingList.id).concat("&query="))}" + request.term;
                </c:when>
            </c:choose>
                        },
                        dataType: "json"
                    },
                    templateResult: formatOption,
                    width: '100%'
                });
                $("#autocomplete-2").val(null).trigger("change");
                $('#autocomplete-2').on("select2:select", function () {
                    var xhttp = new XMLHttpRequest();
                    xhttp.onreadystatechange = function () {
                        if (this.readyState === 4 && this.status === 200) {
                            $("#prodotti").append("<li id=" + $('#autocomplete-2').find(":selected").val() + " class=\"list-group-item justify-content-between align-items-center\">" + $('#autocomplete-2').find(":selected").text()
                                    + " <span class='pull-right glyphicon glyphicon-remove' style='color:red' onclick='deleteProduct(" + $('#autocomplete-2').find(":selected").val() + ")' title='Elimina'>"
                                    + "</span></li>");
                        } else if (this.readyState === 4 && this.status === 500) {
                            alert("Impossibile aggiungere il prodotto");
                        }
                    };
                    var url = "${pageContext.response.encodeURL(contextPath.concat("ProductListServlet"))}";
                    xhttp.open("GET", url + "?shoppingListId=${shoppingList.id}&productId=" + $('#autocomplete-2').find(":selected").val() + "&action=3", true);
                    xhttp.send();
                });
            });
            /* FUNZIONE DI RICERCA E AGGIUNTA DEGLI UTENTI */
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
                            return "${pageContext.response.encodeURL(contextPath.concat("restricted/UsersSearchServlet?query="))}" + request.term;
                        },
                        dataType: "json"
                    },
                    templateResult: formatOption,
                    width: '100%'
                });
                $("#autocomplete-3").val(null).trigger("change");
                $('#autocomplete-3').on("select2:select", function () {
                    var xhttp = new XMLHttpRequest();
                    xhttp.onreadystatechange = function () {

                        if (this.readyState === 4 && this.status === 200) {
                            $("#utenti").append("<li id=\"" + $('#autocomplete-3').find(":selected").val() + "\"class=\"list-group-item justify-content-between align-items-center\">" + $('#autocomplete-3').find(":selected").text()
                                    + " <span class=\"pull-right glyphicon glyphicon-remove\" title=\"Elimina\" style=\"color:black;font-size:15px;margin-left:5px;\" onclick=\"deleteUser(" + $('#autocomplete-3').find(":selected").val() + ")\"></span>"
                                    + " <select class=\"pull-right\" onchange=\"changePermissions(" + $('#autocomplete-3').find(":selected").text() + ", this.value)\">"
                                    + "     <option value=1>Visualizza lista</option>"
                                    + "     <option value=2>Modifica lista</option>"
                                    + " </select>"
                                    + " </li>")
                        } else if (this.readyState === 4 && this.status === 500) {
                            alert("Impossibile aggiungere l'utente");
                        }
                    };
                    var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ShareListsServlet"))}";
                    xhttp.open("GET", url + "?action=1&shoppingListId=${shoppingList.id}&userId=" + $('#autocomplete-3').find(":selected").val(), true);
                    xhttp.send();
                });
            });
            /* MODIFICA ASINCRONA DEI PERMESSI DEGLI UTENTI */
            function changePermissions(userId, permission) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Non hai il permesso per la modifica della lista");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Errore del server, impossibile modificare i permessi");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ShareListsServlet"))}";
                if (userId !== '' && permission !== '') {
                    xhttp.open("GET", url + "?action=2&shoppingListId=${shoppingList.id}&userId=" + userId + "&permission=" + permission, true);
                    xhttp.send();
                }
            }
            /* RIMUOVI UN PRODOTTO DALLA LISTA */
            function deleteProduct(productId) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        var element = document.getElementById(productId);
                        element.parentNode.removeChild(element);
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Non hai il permesso per la modifica della lista");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Errore del server, impossibile modificare i prodotti");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("ProductListServlet"))}";
                if (productId !== '') {
                    xhttp.open("GET", url + "?action=0&shoppingListId=${shoppingList.id}&productId=" + productId, true);
                    xhttp.send();
                }
            }
            /* ANNULLA CONDIVISIONE CON UN UTENTE */
            function deleteUser(userId) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        var element = document.getElementById(userId);
                        element.parentNode.removeChild(element);
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Non hai il permesso per la modifica della lista");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Errore del server, impossibile rimuovere l'utente");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ShareListsServlet"))}";
                if (userId !== '') {
                    xhttp.open("GET", url + "?action=0&shoppingListId=${shoppingList.id}&userId=" + userId, true);
                    xhttp.send();
                }
            }
            /* AGGIUNTA MESSAGGIO */
            function addMessage() {
                var input = document.getElementById("newtext");
                text = input.value;
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        var element = document.getElementById("messageBoard");
                        element.innerHTML += "<div class='message message-right'>" + text + "</div>";
                        input.value = '';
                        element.scrollTop = element.scrollHeight - element.clientHeight;
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Non hai il permesso per la modifica della lista");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Errore del server, impossibile rimuovere l'utente");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/MessagesServlet"))}";
                console.log(url);
                xhttp.open("GET", "MessagesServlet?shoppingListId=${shoppingList.id}&body=" + text, true);
                xhttp.send();
            }
            /* SCROLLA LA CHAT VERSO IL BASSO */
            function scrollChat() {
                var element = document.getElementById("messageBoard");
                element.scrollTop = element.scrollHeight - element.clientHeight;
            }
        </script>
    </head>
    <body onload="scrollChat()">
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron" style="background-image: url('${contextPath}images/shoppingList/${shoppingList.imagePath}');">


                    <h2>${shoppingList.name}</h2>
                    <h4>Categoria: ${shoppingListCategory.name}</h4>
                    <h4>Descrizione: ${shoppingList.description}</h4>

                </div>
                <%@include file="include/navigationBar.jsp"%>
            </div>
            <div id="body">
                <div class="container-fluid">
                    <c:choose>
                        <c:when test="${empty user}">
                            <div class="col-sm-3">
                            </div>
                            <div class="col-sm-5 pre-scrollable">
                                <select id="autocomplete-2" name="autocomplete-2" class="form-control select2-allow-clear">
                                </select>
                                <ul id="prodotti" class="list-group">
                                    <c:forEach items="${products}" var="product">
                                        <li id="${product.id}" class="list-group-item justify-content-between align-items-center">${product.name} 
                                            <span class="pull-right glyphicon glyphicon-remove" style="color:red" onclick='deleteProduct(${product.id})' title="Elimina"></span>
                                        </li>
                                    </c:forEach>
                                    <!--<input type="text" class="form-control" placeholder="Cerca prodotto da aggiungere...">-->
                                </ul>
                            </div>
                    </c:when>
                    <c:when test="${not empty user}">
                        <div class="col-sm-1">
                        </div>
                        <div class="col-sm-5 pre-scrollable">
                            <select id="autocomplete-2" name="autocomplete-2" class="form-control select2-allow-clear">
                            </select>
                            <ul id="prodotti" class="list-group">
                                <c:forEach items="${products}" var="product">
                                    <li id="${product.id}" class="list-group-item justify-content-between align-items-center">${product.name} 
                                        <span class="pull-right glyphicon glyphicon-remove" style="color:red" onclick='deleteProduct(${product.id})' title="Elimina"></span>
                                    </li>
                                </c:forEach>
                                <!--<input type="text" class="form-control" placeholder="Cerca prodotto da aggiungere...">-->
                            </ul>
                        </div>
                        <div class="col-sm-1">
                        </div>
                        <div class="col-sm-4">
                            <div class="row">
                                <div>
                                    <label for="comment">Chat:</label>
                                    <div class="form-control chat" id="messageBoard">
                                        <c:forEach items="${messages}" var="message">
                                            <div class="message<c:if test="${message.senderId==user.id}"> message-right</c:if>">${message.body}</div>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="input-group">
                                    <input id="newtext" class="form-control" type="text">
                                    <div class="input-group-btn">
                                        <button class="btn btn-default" onclick="addMessage()">Invia</button>
                                    </div>
                                </div>
                            </div>
                            <br>
                            <div class="row">
                                <ul id="utenti" class="list-group user-list-group">
                                    <li class="list-group-item justify-content-between align-items-center">
                                        <label> Utenti che condividono la lista: </label>
                                        <select id="autocomplete-3" name="autocomplete-3" class="form-control select2-allow-clear">
                                        </select>
                                    </li>
                                    <c:forEach items="${users}" var="user">
                                        <li id="${user.id}" class="list-group-item justify-content-between align-items-center">${user.firstName} ${user.lastName}  
                                            <span class="pull-right glyphicon glyphicon-remove" title="Elimina" style="color:black;font-size:15px;margin-left:5px;" onclick="deleteUser(${user.id})"></span>
                                            <select class="pull-right" onchange="changePermissions(${user.id}, this.value)">
                                                <option value=1 <c:if test="${user.permissions==1}">selected</c:if>>Visualizza lista</option>
                                                <option value=2 <c:if test="${user.permissions==2}">selected</c:if>>Modifica lista</option>
                                                </select>  
                                            </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        <br>
                        <div class="row">
                            <ul id="utenti" class="list-group user-list-group">
                                <li class="list-group-item justify-content-between align-items-center"><label> Utenti che condividono la lista: </label></li>
                                <li class="list-group-item justify-content-between align-items-center">
                                    <select id="autocomplete-3" name="autocomplete-3" class="form-control select2-allow-clear">
                                    </select>
                                </li>
                                <c:forEach items="${users}" var="user">
                                    <li id="${user.id}" class="list-group-item justify-content-between align-items-center">${user.firstName} ${user.lastName}  
                                        <span class="pull-right glyphicon glyphicon-remove" title="Elimina" style="color:black;font-size:15px;margin-left:5px;" onclick="deleteUser(${user.id})"></span>
                                        <select class="pull-right" onchange="changePermissions(${user.id}, this.value)">
                                            <option value=1 <c:if test="${user.permissions==1}">selected</c:if>>Visualizza lista</option>
                                            <option value=2 <c:if test="${user.permissions==2}">selected</c:if>>Modifica lista</option>
                                            </select>  
                                        </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
                    </c:when>
                </c:choose>
            </div>
        </div>
        <%@include file="include/footer.jsp" %>
    </div>
</body>
</html>
