<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Shopping List Category</title>
        <link rel="stylesheet" href="css/generic.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
    </head>
    <body>
        <form class="form-signin" action="${pageContext.response.encodeURL("ShoppingListCategoryServlet")}" method="POST" enctype="multipart/form-data">
            <div class="text-center mb-4">
                <h3>Edit Shopping List Category</h3>
            </div>
            <c:choose>
                <c:when test="${message==1}">
                    Compila i campi mancanti!
                    <c:if test="${empty shoppingListCategory.name}">Name</c:if>
                    <c:if test="${empty shoppingListCategory.description}">Description</c:if>
                </c:when>
            </c:choose>
            <div class="form-label-group">
                <label for="name">Name: </label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Name" value="${shoppingListCategory.name}" autofocus>
            </div>
            <div class="form-label-group">
                <label for="description">Description: </label>
                <input type="text" id="description" name="description" class="form-control" placeholder="Description" value="${shoppingListCategory.description}">
            </div>
            <div class="form-label-group">
                <c:if test="${not empty shoppingListCategory.logoPath}">
                <img src="../images/shoppingListCategories/<c:out value="${shoppingListCategory.logoPath}"/>" alt="Logo" height="80" width="80">
                </c:if>
                <label for="logo">Logo</label>
                <input type="file" id="logo" name="logo" class="form-control">
            </div>
            <div class="form-label-group">
                <label for="productCategory">Select product category</label>
                <c:if test="${not empty productCategories}">
                    <c:forEach items="${productCategories}" var="productCategory">
                        <input type="checkbox" id="${productCategory.id}" name="productCategories" value="${productCategory.id}">
                        <label for="${productCategory.id}">${productCategory.name}</label>
                    </c:forEach>
                </c:if>
            </div>
            <c:if test="${not empty shoppingListCategory.id}"><input type="hidden" name="shoppingListCategoryId" value="${shoppingListCategory.id}"></c:if>
                <button class="buttonlike" type="submit">Confirm</button>
            </form>
        <c:remove var="message" scope="session" />
        <c:remove var="shoppingListCategory" scope="session" />
    </body>
</html>