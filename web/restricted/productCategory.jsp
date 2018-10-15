<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Product Category</title>
        <link rel="stylesheet" href="css/generic.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
    </head>
    <body>
        <form class="form-signin" action="${pageContext.response.encodeURL("ProductCategoryServlet")}" method="POST" enctype="multipart/form-data">
            <div class="text-center mb-4">
                <h3>Edit Product Category</h3>
            </div>
            <c:choose>
                <c:when test="${message==1}">
                    Compila i campi mancanti!
                    <c:if test="${empty productCategory.name}">Name</c:if>
                    <c:if test="${empty productCategory.description}">Despcription</c:if>
                    <c:if test="${empty productCategory.logoPath}">Logo</c:if>
                </c:when>
            </c:choose>
            <div class="form-label-group">
                <label for="name">Name: </label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Name" value="${productCategory.name}" autofocus>
            </div>
            <div class="form-label-group">
                <label for="notes">Description: </label>
                <input type="text" id="description" name="description" class="form-control" placeholder="Description" value="${productCategory.description}">
            </div>
            <div class="form-label-group">
                <img height="50px" src="../images/productCategories/${productCategory.logoPath}">
                <label for="logo">New Logo: </label>
                <input type="file" id="logo" name="logo" class="form-control">
            </div>
            <div class="form-label-group">
                <label for="icons">Add icons: </label>
                <input type="file" id="icons" name="icons" class="form-control" multiple="multiple">
            </div>
            <div>
                <c:if test="${not empty productCategory.iconPath}">
                    Remove icons:
                    <c:forEach items="${productCategory.iconPath}" var="icon">
                        <input type="checkbox" id="${icon}" name="removeIcons" value="${icon}">
                        <label for="${icon}"><img height="50px" src="../images/productCategories/icons/${icon}"></label>
                    </c:forEach>
                </c:if>
            </div>
            <c:if test="${not empty productCategory.id}"><input type="hidden" name="productCategoryId" value="${productCategory.id}"></c:if>
                <button class="buttonlike" type="submit">Confirm</button>
            </form>
        <c:remove var="message" scope="session" />
        <c:remove var="productCategory" scope="session" />
    </body>
</html>