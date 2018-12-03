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
        <script src="${contextPath}jquery-ui-1.12.1/jquery-ui.js"></script>

        <script>
            /* FUNZIONE RICERCA E AGGIUNTA PRODOTTI */
            $(function () {
                $("#searchAddProducts").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: <c:if test="${not empty user}">"${pageContext.response.encodeURL(contextPath.concat("restricted/ProductsSearchServlet"))}"</c:if><c:if test="${empty user}">"${pageContext.response.encodeURL(contextPath.concat("ProductsSearchPublic"))}"</c:if>,
                                    dataType: "json",
                            data: {
                                shoppingListId: ${shoppingList.id},
                                query: request.term
                            },
                            success: function (data) {
                                response(data);
                            },
                            error(e) {
                                console.log("Error: " + e);
                            }
                        });
                    },
                    response: function (event, ui) {
            <c:if test="${not empty user}">
                        ui.content.push({label: "Aggiungi \"" + $("#searchAddProducts").val() + "\" ai miei prodotti", value: 0});
            </c:if>
                    },
                    select: function (event, ui) {
                        if (ui.item.value === 0) {
                            var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/productForm.jsp?name="))}" + $("#searchAddProducts").val();
                            window.location.href = url;
                        } else {
                            $("#searchAddProducts").val(ui.item.label);
                            $.ajax({
                                url: "${pageContext.response.encodeURL(contextPath.concat("ProductListServlet"))}",
                                data: {
                                    shoppingListId: ${shoppingList.id},
                                    productId: ui.item.value,
                                    action: 3
                                },
                                success: function (data) {
                                    $("#emptyProducts").hide();
                                    $("#prodotti").append("<li id=" + data.product.id + " class=\"list-group-item justify-content-between align-items-center my-list-item\">" +
                                            "<input type=\"checkbox\" id=\"checkbox_" + data.product.id + "\" onclick=\"checkProduct(" + data.product.id + ")\" >" +
                                            "<label for=\"checkbox_" + data.product.id + "\">" +
                                            "<img src=\"${contextPath}images/productCategories/icons/" + data.product.logoPath + "\" class=\"medium-logo\">" +
                                            "<div class=\"my-text-content\">" + data.product.name + "</div>" +
                                            "</label>" +
                                            "<img class=\"list-logo-right\" src=\"${contextPath}images/myIconsNav/rubbish.png\" onclick=\"deleteProduct(" + data.product.id + ")\">" +
                                            "</li>");
                                    $("#searchAddProducts").val("");
                                },
                                error() {
                                    alert("L'utente non ha i permessi per la modifica della lista");
                                }
                            });
                        }
                        return false;
                    },
                    focus: function () {
                        return false;
                    }
                });
                $("#searchAddProducts").keypress(function (e) {
                    if (e.which === 13 && $("#searchAddProducts").val() !== "") {
                        var url = "${pageContext.response.encodeURL(contextPath.concat("products.jsp?query="))}" + $("#searchAddProducts").val();
                        window.location.href = url;
                    }
                });
            });

            /* RIMOZIONE PRODOTTO DALLA LISTA */
            function deleteProduct(productId) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        var element = document.getElementById(productId);
                        if (element.parentNode.getElementsByTagName("li").length == 1) {
                            $("#emptyProducts").show();
                        }
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

            /* FUNZIONE DI RICERCA E AGGIUNTA DEGLI UTENTI */
            $(function () {
                $("#searchUsers").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: "${pageContext.response.encodeURL(contextPath.concat("restricted/UsersSearchServlet"))}",
                            dataType: "json",
                            data: {
                                query: request.term
                            },
                            success: function (data) {
                                response(data);
                            },
                            error(xhr, status, err) {
                                alert("L'utente non ha i permessi per la modifica della lista");
                            }
                        });
                    },
                    select: function (event, ui) {
                        $("#searchUsers").val(ui.item.label);
                        $.ajax({
                            url: "${pageContext.response.encodeURL(contextPath.concat("restricted/ShareListsServlet"))}",
                            data: {
                                shoppingListId: ${shoppingList.id},
                                userId: ui.item.value,
                                action: 1,
                            },
                            success: function () {
                                $("#utenti").append("<li id=\"" + ui.item.value + "\"class=\"list-group-item justify-content-between align-items-center\">" + ui.item.label
                                        + " <span class=\"pull-right glyphicon glyphicon-remove\" title=\"Elimina\" style=\"color:black;font-size:15px;margin-left:5px;\" onclick=\"deleteUser(" + ui.item.value + ")\"></span>"
                                        + " <select class=\"pull-right\" onchange=\"changePermissions(" + ui.item.value + ", this.value)\">"
                                        + "     <option value=1>Visualizza lista</option>"
                                        + "     <option value=2>Modifica lista</option>"
                                        + " </select>"
                                        + " </li>");
                                $("#searchUsers").val("");
                            },
                            error(xhr, status, err) {
                                alert("L'utente non ha i permessi per la modifica della lista");
                            }
                        });
                        return false;
                    },
                    focus: function () {
                        return false;
                    }
                });
            });
            /* MODIFICA PERMESSI UTENTI */
            function changePermissions(userId, permissions) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        if (permissions === 0) {
                            var element = document.getElementById(userId);
                            element.parentNode.removeChild(element);
                        }
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Non hai il permesso per la modifica della lista");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Errore del server, impossibile modificare i permessi");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ShareListsServlet"))}";
                var action = 2;
                if (permissions === 0) {
                    action = 0;
                }
                if (userId !== '' && permissions !== '') {
                    xhttp.open("GET", url + "?action=" + action + "&shoppingListId=${shoppingList.id}&userId=" + userId + "&permissions=" + permissions, true);
                    xhttp.send();
                }
            }
            /* SETTA UN PRODOTTO COME SETTATO/NON SETTATO */
            function checkProduct(productId) {
                $.ajax({
                    url: "${pageContext.response.encodeURL(contextPath.concat("ProductListServlet"))}",
                    data: {
                        shoppingListId: ${shoppingList.id},
                        productId: productId,
                        action: function () {
                            if ($("#checkbox_" + productId).is(":checked")) {
                                return 1;
                            } else {
                                return 2;
                            }
                        }
                    },
                    success: function (data) {
                        return false;
                    },
                    error(xhr, status, error) {
                        console.log(error);
                        alert("L'utente non ha i permessi per la modifica della lista");
                        if ($("#checkbox_" + productId).is(":checked")) {
                            $("#checkbox_" + productId).prop('checked', false);
                        } else {
                            $("#checkbox_" + productId).prop('checked', false);
                        }
                    }
                });
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
            /* ELIMINAZIONE DELLA LISTA */
            function deleteShoppingList(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        window.location.href = "${pageContext.response.encodeURL(contextPath.concat("restricted/shoppingLists.jsp"))}";
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Bad request!");
                    } else if (this.readyState === 4 && this.status === 403) {
                        alert("You are not allowed to delete the product!");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossible to delete the product!");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListServlet"))}";
                xhttp.open("DELETE", url + "?shoppinListId=" + id, true);
                xhttp.send();
            }
        </script>
    </head>
    <body <c:if test="${permissions==1||permissions==2}">onload="scrollChat()"</c:if>>
            <div id="containerPage">
                <div id="header">
                    <div class="jumbotron">
                        <h1>${shoppingList.name}</h1>
                    <p>Categoria: ${shoppingListCategory.name}</p>
                </div>
                <%@include file="include/navigationBar.jsp"%>
            </div>
            <div id="body">
                <div class="container-fluid">
                    <c:choose>
                        <c:when test="${empty user}">
                            <div class="col-sm-3">
                            </div>
                            <div class="col-sm-5">
                                <div class="row">
                                    <div class="col-sm-6">    
                                        <!--<div class="pull-left">-->
                                        <img class="shoppingList-img" src="${contextPath}/images/shoppingList/<c:out value="${shoppingList.imagePath}"/>">
                                    </div>
                                    <div class="col-sm-6">
                                        <h4>Descrizione: ${shoppingList.description}</h4>
                                        <button class="btn-custom right clickable" onclick="deleteShoppingList(${shoppingList.id})">Elimina</button>
                                        <button class="btn-custom right clickable" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("ShoppingListPublic?res=2"))}'">Modifica</button>
                                    </div>
                                </div>
                                <br>
                                <input type="text" id="searchAddProducts" name="searchAddProducts" class="form-control">

                                <div class="pre-scrollable">
                                    <ul id="prodotti" class="list-group">
                                        <div id="emptyProducts" style="<c:if test="${not empty products}">display:none;</c:if>">Nessun prodotto in lista</div>
                                        <c:forEach items="${products}" var="product">
                                            <li id="${product.id}" class="list-group-item justify-content-between align-items-center my-list-item">
                                                <input type="checkbox" id="checkbox_${product.id}" <c:if test="${not product.necessary}">checked</c:if> onclick="checkProduct(${product.id})">
                                                <label for="checkbox_${product.id}">
                                                    <img src="${contextPath}images/productCategories/icons/${product.logoPath}" class="medium-logo">
                                                    <div class="my-text-content">
                                                        ${product.name}
                                                    </div>
                                                </label>
                                                <img class="list-logo-right" src="${contextPath}images/myIconsNav/rubbish.png" onclick='deleteProduct(${product.id})'>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${not empty user}">
                            <div class="col-sm-1">
                            </div>
                            <div class="col-sm-5">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <!--<div class="pull-left">-->
                                        <img class="shoppingList-img" src="${contextPath}/images/shoppingList/<c:out value="${shoppingList.imagePath}"/>">
                                    </div>
                                    <div class="col-sm-6">
                                        <h4>Descrizione: ${shoppingList.description}</h4>
                                        <c:if test="${permissions==2}">
                                            <button class="btn-custom right" onclick="deleteShoppingList(${shoppingList.id})">Elimina</button>
                                            <button class="btn-custom right" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/ShoppingListServlet?res=2&shoppingListId=".concat(shoppingListId.id)))}'">Modifica</button>
                                        </c:if>
                                    </div>
                                </div>
                                <br>
                                <c:if test="${permissions==2}">
                                    <input type="text" id="searchAddProducts" name="searchAddProducts" class="form-control" placeholder="Aggiungi prodotto...">
                                </c:if>
                                <div class="pre-scrollable">
                                    <ul id="prodotti" class="list-group">
                                        <div id="emptyProducts" style="<c:if test="${not empty products}">display:none;</c:if>">Nessun prodotto in lista</div>
                                        <c:forEach items="${products}" var="product">
                                            <li id="${product.id}" class="list-group-item justify-content-between align-items-center my-list-item">                                                    
                                                <input type="checkbox" id="checkbox_${product.id}" <c:if test="${not product.necessary}">checked</c:if> onclick="checkProduct(${product.id})">
                                                <label for="checkbox_${product.id}">
                                                    <img src="${contextPath}images/productCategories/icons/${product.logoPath}" class="medium-logo">
                                                    <div class="my-text-content">
                                                        ${product.name}
                                                    </div>
                                                </label>
                                                <c:if test="${permissions==2}">
                                                    <img class="list-logo-right" src="${contextPath}images/myIconsNav/rubbish.png" onclick='deleteProduct(${product.id})'>
                                                </c:if>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                            <div class="col-sm-5">
                                <div class="row">
                                    <div class="form-control chat" id="messageBoard">
                                        <c:forEach items="${messages}" var="message">
                                            <div class="message<c:if test="${message.senderId==user.id}"> message-right</c:if>">
                                                <c:if test="${message.senderId!=user.id}">
                                                    <span style="font-weight: bold">${message.senderName}</span>
                                                    <br>
                                                </c:if>
                                                ${message.body}
                                            </div>
                                        </c:forEach>
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
                                    <c:if test="${permissions==2}">
                                        <input type="text" id="searchUsers" name="searchUsers" class="form-control" placeholder="Condividi...">
                                    </c:if>
                                    <div class="pre-scrollable">
                                        <ul id="utenti" class="list-group user-list-group">
                                            <c:forEach items="${users}" var="user">
                                                <li id="${user.id}" class="list-group-item justify-content-between align-items-center my-list-item">
                                                    <div class="my-text-content">
                                                        ${user.firstName} ${user.lastName}
                                                    </div>
                                                    <c:if test="${permissions==2}">
                                                        <div class="my-text-content pull-right">
                                                            <select onchange="changePermissions(${user.id}, this.value)">
                                                                <option value=1 <c:if test="${user.permissions==1}">selected</c:if>>Visualizza</option>
                                                                <option value=2 <c:if test="${user.permissions==2}">selected</c:if>>Modifica</option>
                                                                <option value=0 >Rimuovi</option>
                                                                </select> 
                                                            </div>
                                                    </c:if>
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
