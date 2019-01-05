<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Modifica categoria</title>
        <%@include file="../include/generalMeta.jsp" %>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h2>Categoria di prodotto</h2><br>
                        <h4>Crea o modifica la categoria di prodotto</h4><br>
                    </div>
                </div>    
                <%@include file="../include/navigationBar.jsp" %>
            </div>
            <div id="body">
                <div class="container text-center">
                    <div class="col-sm-2"></div>
                    <div class="col-sm-8">
                        <div class="form-container ">
                            <form class="form-signin" action="${pageContext.response.encodeURL(contextPath.concat("restricted/ProductCategoryServlet"))}" method="POST" enctype="multipart/form-data">
                                <c:choose>
                                    <c:when test="${message==1}">
                                        Compila i campi mancanti!
                                        <c:if test="${empty productCategory.name}">Name</c:if>
                                        <c:if test="${empty productCategory.description}">Despcription</c:if>
                                        <c:if test="${empty productCategory.logoPath}">Logo</c:if>
                                    </c:when>
                                </c:choose>
                                <div class="form-group">
                                    <label for="name">Nome:</label>
                                    <input type="text" id="name" name="name" class="form-control" placeholder="Inserisci nome della categoria" value="${productCategory.name}" autofocus>
                                </div>
                                <div class="form-group">
                                    <label for="description">Descrizione:</label>
                                    <textarea id="description" name="description" class="form-control" placeholder="Inserisci una descrizione">${productCategory.description}</textarea>
                                </div>
                                <div class="form-group">
                                    <c:if test="${not empty productCategory.logoPath}">
                                        <img class="logo" src="${contextPath}images/productCategories/${productCategory.logoPath}">
                                    </c:if>
                                    <label for="logo">Immagine:</label>
                                    <input type="file" id="logo" name="logo" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label for="logo">Aggiungi icone per la categoria:</label>
                                    <input type="file" id="icons" name="icons" class="form-control" multiple="multiple">
                                </div>
                                <c:if test="${not empty productCategory.iconPath}">
                                    <div class="form-group">
                                        <label for="categorie">Seleziona le icone da rimuovere:</label>
                                        <div class="row">
                                            <c:forEach items="${productCategory.iconPath}" var="icon">
                                                <div class="container-logo">
                                                    <input type="checkbox" id="${icon}" name="removeIcons" value="${icon}" class="input-img input-hide">
                                                    <label for="${icon}"><img src="${contextPath}images/productCategories/icons/${icon}" class="fit-logo img-responsive" alt="Icon"></label>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty productCategory.id}"><input type="hidden" name="productCategoryId" value="${productCategory.id}"></c:if>
                                    <button type="submit" class="btn-custom">Salva</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            <%@include file="../include/footer.jsp" %>
        </div>
    </body>
</html>
