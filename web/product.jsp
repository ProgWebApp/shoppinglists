<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product</title>
        <%@include file="include/generalMeta.jsp" %>
        <style>
            .carousel .item {
                height: 350px;
            }
            .item img {
                position: absolute;
                top: 0;
                left: 0;
                min-height: 350px;
            }
            .carousel-control{
                color: #fff !important;
                text-decoration: none;
                filter: alpha(opacity=90);
                outline: 0;
                opacity: .7;}

            .carousel {
                margin-top: 15px;
            }

        </style>
        <script>
            function addProdToList(prod, list) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 200) {
                        document.getElementById('to-list-btn').setAttribute( "onclick", "window.location.href = '${contextPath}restricted/ShoppingListServlet?res=1&shoppingListId=" + list + "';event.stopPropagation();");
                        $("#addModal").modal("show");
                        } else if (this.readyState === 4 && this.status === 403) {
                        alert("Non hai il permesso per la modifica della lista");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Errore del server, impossibile modificare i permessi");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("ProductListServlet"))}";
                xhttp.open("GET", url + "?action=3&productId=" + prod + "&shoppingListId=" + list, true);
                xhttp.send();
            }
            function deleteProduct(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        window.location.href = "${pageContext.response.encodeURL(contextPath.concat("products.jsp"))}";
                    } else if (this.readyState === 4 && this.status === 400) {
                        alert("Bad request!");
                    } else if (this.readyState === 4 && this.status === 403) {
                        alert("You are not allowed to delete the product!");
                    } else if (this.readyState === 4 && this.status === 500) {
                        alert("Impossible to delete the product!");
                    }
                };
                var url = "${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet"))}";
                xhttp.open("DELETE", url + "?productId=" + id, true);
                xhttp.send();
            }
            
        </script>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>${product.name}</h1>
                        <h4>Categoria: ${productCategory.name}</h4>
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp" %>
            </div>
            <div id="body">
                <div class="row">
                    <div class="col-sm-1">
                    </div>
                    <div class="col-sm-5">
                        <div class="bod-container">
                            <div style="height: 100px;">
                                <img src="${contextPath}images/productCategories/icons/${product.logoPath}" alt="logo" class="big-logo">
                            </div>
                            <hr>
                            <div>
                                <h3>Descrizione:</h3>
                                <p>${product.notes}</p>
                                <br>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${not empty shoppingLists}">
                            <hr class="divisore">
                                        <label>Scegli a quale lista vuoi aggiungere:</label>
                                        <select id="selectList" onchange="addProdToList(${product.id}, this.value)">
                                            <option disabled selected hidden>Aggiungi ad una lista...</option>
                                            <c:forEach items="${shoppingLists}" var="shoppingList">
                                                <option value="${shoppingList.id}">${shoppingList.name}</option>
                                            </c:forEach>
                                        </select>
                                        <br>
                            <hr class="divisore">
                                    </c:when>
                                    <c:when test="${not empty myList}">
                            <hr class="divisore">
                                        <button class="btn-custom" type="button" onclick="addProdToList(${product.id}, ${myList})">Aggiungi alla mia lista</button>
                            <hr class="divisore">
                                    </c:when>
                                </c:choose>
                            </div>
                            <div>
                                <c:if test="${modifiable}">
                                    <button class="btn-custom" onclick="window.location.href = '${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet?res=2&productId=".concat(product.id)))}'">Modifica</button>
                                    <button class="btn-del" data-toggle="modal" data-target="#myModal">Elimina</button>                            
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-5">
                        <div id="myCarousel" class="carousel slide" data-ride="carousel">
                            <ol class="carousel-indicators">
                                <c:set var = "count" value = "0"/>
                                <c:forEach items="${product.photoPath}" var="photo">
                                    <c:choose>
                                        <c:when test = "${count == 0}">
                                            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                                            </c:when>

                                        <c:otherwise>
                                            <li data-target="#myCarousel" data-slide-to="<c:out value = "${count}"/>"></li>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:set var = "count" value = "${count+1}"/>
                                    </c:forEach>
                            </ol>
                            <div class="carousel-inner">
                                <c:set var = "count" value = "0"/>
                                <c:forEach items="${product.photoPath}" var="photo">
                                    <c:choose>
                                        <c:when test = "${count == 0}">
                                            <div class="item active">
                                                <img src="${contextPath}images/products/${photo}" alt="img-prodotto" class="fit-image">
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="item">
                                                <img src="${contextPath}images/products/${photo}" alt="img-prodotto" class="fit-image">
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:set var = "count" value = "${count+1}"/>
                                </c:forEach>
                                <c:remove var = "count" scope = "session"/>
                            </div>
                            <a class="left carousel-control" href="#myCarousel" data-slide="prev">
                                <span class="glyphicon glyphicon-chevron-left"></span>
                                <span class="sr-only">Previous</span>
                            </a>
                            <a class="right carousel-control" href="#myCarousel" data-slide="next">
                                <span class="glyphicon glyphicon-chevron-right"></span>
                                <span class="sr-only">Next</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <%@include file="include/footer.jsp" %>
        </div>
        <div class="modal fade" id="myModal" role="elimina">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Attenzione</h4>
                    </div>
                    <div class="modal-body">
                        <p>Sei sicuro di voler eliminare questo prodotto? Cos� facendo esso verr� rimosso da tutte le liste in cui � presente</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-del" onclick="deleteProduct(${product.id})">Elimina</button>
                        <button type="button" class="btn-custom" data-dismiss="modal">Annulla</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="addModal" role="recap">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Aggiunto</h4>
                    </div>
                    <div class="modal-body">
                        <p>Il prodotto � stato aggiunto con successo</p>
                    </div>
                    <div class="modal-footer">
                        <button id="to-list-btn" type="button" class="btn-custom" onclick="">Vai alla lista</button>
                        <button type="button" class="btn-custom" data-dismiss="modal">Indietro</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
