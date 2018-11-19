<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Modifica categoria</title>
                <%@include file="../include/generalMeta.jsp" %>


    </head>
    <body>
        <div class="container text-center">    
            <h2>Area di creazione categoria Prodotto</h2><br>
            <h4>Crea una nuova tipologia di categoria per i prodotti</h4><br>
                    <%@include file="../include/navigationBar.jsp" %>

            <div class="col-sm-2">
            </div>
            <div class="col-sm-8">
                <div class="form-container ">
                    <form class="form-signin" action="${pageContext.response.encodeURL(contextPath.concat("ProductCategoryServlet"))}" method="POST" enctype="multipart/form-data">
                        <c:choose>
                            <c:when test="${message==1}">
                                Compila i campi mancanti!
                                <c:if test="${empty productCategory.name}">Name</c:if>
                                <c:if test="${empty productCategory.description}">Despcription</c:if>
                                <c:if test="${empty productCategory.logoPath}">Logo</c:if>
                            </c:when>
                        </c:choose>
                        <div class="form-group">
                            <label for="name">Nome Categoria:</label>
                            <input type="text" id="name" name="name" class="form-control" placeholder="Inserisci nome della categoria" value="${productCategory.name}" autofocus>
                        </div>
                        <div class="form-group">
                            <label for="description">Descrizione:</label>
                            <input type="text" id="description" name="description" class="form-control" placeholder="Inserisci una descrizione" value="${productCategory.description}">
                        </div>
                        <div class="form-group">
                            <c:if test="${not empty productCategory.logoPath}">
                                <img class="logo" src="${contextPath}images/productCategories/${productCategory.logoPath}">
                            </c:if>
                            <label for="logo">Carica un logo per la categoria prodotto:</label>
                            <input type="file" id="logo" name="logo" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="logo">Carica le icone utilizzabili dai prodotti in questa categoria:</label>
                            <input type="file" id="icons" name="icons" class="form-control" multiple="multiple">
                        </div>
                        <c:if test="${not empty productCategory.iconPath}">
                            <div class="form-group">
                                <label for="categorie">Seleziona le icone che vuoi rimuovere:</label>
                                <div class="row">
                                    <c:forEach items="${productCategory.iconPath}" var="icon">
                                        <div class="container-logo">
                                            <input type="checkbox" id="${icon}" name="removeIcons" value="${icon}" class="checkbox-img">
                                            <label for="${icon}"><img src="${contextPath}images/productCategories/icons/${icon}" class="fit-logo img-responsive" alt="Icon"></label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${not empty productCategory.id}"><input type="hidden" name="productCategoryId" value="${productCategory.id}"></c:if>
                        <button type="submit" class="btn btn-default acc-btn">Invia</button>
                    </form>
                </div>
            </div>
        </div>
        <br>
                <%@include file="../include/footer.jsp" %>

    </body>
</html>