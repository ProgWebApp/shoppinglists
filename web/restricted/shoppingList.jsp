<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Shopping List</title>
        <link rel="stylesheet" href="css/generic.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
    </head>
    <body>
        <form class="form-signin" action="${pageContext.response.encodeURL("ShoppingListServlet")}" method="POST" enctype="multipart/form-data">
            <div class="text-center mb-4">
                <h3>Edit Shopping List</h3>
            </div>
            <c:choose>
                <c:when test="${message==1}">
                    Compila i campi mancanti!
                    <c:if test="${empty shoppingList.name}">Name</c:if>
                    <c:if test="${empty shoppingList.description}">Description</c:if>
                    <c:if test="${empty shoppingList.shoppingListCategoryId}">Category</c:if>
                    <c:if test="${empty shoppingList.imagePath}">Image</c:if>
                </c:when>
            </c:choose>
            <div class="form-label-group">
                <label for="name">Name: </label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Name" value="${shoppingList.name}" autofocus>
            </div>
            <div class="form-label-group">
                <label for="description">Description: </label>
                <input type="text" id="description" name="description" class="form-control" placeholder="Description" value="${shoppingList.description}">
            </div>
            <div class="form-label-group">
                <label for="shoppingListCategory">Shopping list category: </label>
                <select id="shoppingListCategory" name="shoppingListCategory" class="form-control">
                    <option value="" <c:if test="${empty shoppingList.shoppingListCategoryId}">selected</c:if> disabled>Select shopping list category...</option>
                    <c:forEach items="${shoppingListCategories}" var="shoppingListCategory">
                        <option value="${shoppingListCategory.id}" <c:if test="${shoppingListCategory.id==shoppingList.shoppingListCategoryId}">selected</c:if>>${shoppingListCategory.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-label-group">
                <c:if test="${not empty shoppingListCategory.imagePath}">
                <img src="../images/shoppingList/<c:out value="${shoppingList.imagePath}"/>" alt="Image" height="80" width="80">
                </c:if>
                <label for="image">Image</label>
                <input type="file" id="logo" name="image" class="form-control">
            </div>
            <c:if test="${not empty shoppingList.id}"><input type="hidden" name="shoppingListId" value="${shoppingList.id}"></c:if>
                <button class="buttonlike" type="submit">Confirm</button>
            </form>
        <c:remove var="message" scope="session" />
        <c:remove var="shoppingList" scope="session" />
    </body>
</html>