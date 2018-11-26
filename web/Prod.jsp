<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product</title>
        <%@include file="include/generalMeta.jsp" %>
        <style>

            .carousel .item {
                height: 300px;
            }




            .item img {
                position: absolute;
                top: 0;
                left: 0;
                min-height: 300px;
            }


            .carousel{
                width: 900px;
                margin: auto;
                margin-top: 25px;
                margin-bottom:25px;
            }
            .carousel .item {
                height: 300px;
                width: 900px;
            }
        </style>
        <script>
            function deleteProduct(id) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4 && this.status === 204) {
                        window.location.href = "${pageContext.response.encodeURL(contextPath.concat("restricted/products.jsp"))}";
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
                    
                        <div id="myCarousel" class="carousel slide" data-ride="carousel">
                            <ol class="carousel-indicators">
                                <c:set var = "count" scope = "session" value = "$0"/>
                                <c:forEach items="${product.photoPath}" var="photo">
                                    <c:choose>
                                        <c:when test = "${count = 0}">
                                            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                                        </c:when>

                                        <c:otherwise>
                                            <li data-target="#myCarousel" data-slide-to="<c:out value = "${count}"/>"></li>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:set var = "count" value = "$count+1"/>
                                </c:forEach>
                                <c:remove var = "count" scope = "session"/>
                            </ol>
                            <div class="carousel-inner">
                                <c:set var = "count" scope = "session" value = "$0"/>
                                <c:forEach items="${product.photoPath}" var="photo">
                                    <c:choose>
                                        <c:when test = "${count = 0}">
                                            <div class="item active">
                                                <img src="${contextPath}images/products/${photo}" alt="img-pasta" class="fit-image">
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="item">
                                                <img src="${contextPath}images/products/${photo}" alt="img-pasta" class="fit-image">
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:set var = "count" value = "$count+1"/>
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
                    
                   
                <%@include file="include/navigationBar.jsp" %>
            </div>
            <div id="body">
                
               <div class="col-sm-2">
               </div>
               <div class="col-sm-8">
                  <img src="${contextPath}images/productCategories/icons/${product.logoPath}" class="big-logo" alt="logo">
                  <h1>${product.name}</h1>
                  <br>
                  <div>
                     <h3>Categoria del prodotto:</h3>
                     <p>${productCategory.name}</p>
                     <br>
                     <h3>Descrizione:</h3>
                     <p>${product.notes}</p>
                     <br>
                     <hr>
                     <button class="btn btn-custom" type="button">Aggiungi ad una lista</button>
                        <a class="btn btn-custom" type="button" href="${pageContext.response.encodeURL(contextPath.concat("restricted/ProductServlet?res=2&productId=".concat(product.id)))}">
                  		Modifica questo prodotto
                 	</a>
                     <br>
                     <hr>
                  </div>
                  <br>
                  <br>
               </div>
           
                <span onclick="deleteProduct(${product.id})">Elimina</span><br>
                <a href="${pageContext.response.encodeURL(contextPath.concat("restricted/products.jsp"))}">My products</a>
            </div>
            <%@include file="include/footer.jsp" %>
        </div>
    </body>
</html>
