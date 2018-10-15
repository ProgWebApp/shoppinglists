<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Product</title>
        <link rel="stylesheet" href="css/generic.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.8/css/all.css" crossorigin="anonymous">
        <script>
            function showLogos(logo, category){
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        console.log(this.responseText);
                    }
                };
                xhttp.open("GET", "${pageContext.response.encodeURL("LogosServlet")}", true);
                xhttp.send("category=" + category);
            }
            }
        </script>    
    </head>
    <body>
        <form class="form-signin" action="${pageContext.response.encodeURL("ProductServlet")}" method="POST" enctype="multipart/form-data">
            <div class="text-center mb-4">
                <h3>Edit Product</h3>
            </div>
            <c:choose>
                <c:when test="${message==1}">
                    Compila i campi mancanti!
                    <c:if test="${empty product.name}">Name</c:if>
                    <c:if test="${empty product.notes}">Notes</c:if>
                    <c:if test="${empty product.productCategoryId}">Category</c:if>
                </c:when>
            </c:choose>
            <div class="form-label-group">
                <label for="name">Name: </label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Name" value="${product.name}" autofocus>
            </div>
            <div class="form-label-group">
                <label for="notes">Notes: </label>
                <input type="text" id="notes" name="notes" class="form-control" placeholder="Notes" value="${product.notes}">
            </div>
            <div class="form-label-group">
                <label for="category">Category: </label>
                <select id="category" name="category" class="form-control" onchange="showLogos(logo, this.value)">
                    <option value="" <c:if test="${empty product.productCategoryId}">selected</c:if> disabled>Select category...</option>
                    <c:forEach items="${categories}" var="category">
                        <option value="${category.id}" <c:if test="${category.id==product.productCategoryId}">selected</c:if>>${category.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-label-group">
                <img height="50px" src="../images/productCategories/${product.logoPath}">
                <label for="logo">New Logo: </label>
                <select id="logo" name="logo" class="form-control">
                </select>
            </div>
            <div class="form-label-group">
                <label for="photos">Add images: </label>
                <input type="file" id="photos" name="photos" class="form-control" multiple="multiple">
            </div>
            <div>
                <c:if test="${not empty product.photoPath}">
                    Remove images:
                    <c:forEach items="${product.photoPath}" var="photo">
                        <input type="checkbox" id="${photo}" name="removePhotos" value="${photo}">
                        <label for="${photo}"><img height="50px" src="../images/products/${photo}"></label>
                    </c:forEach>
                </c:if>
            </div>
            <c:if test="${not empty product.id}"><input type="hidden" name="productId" value="${product.id}"></c:if>
                <button class="buttonlike" type="submit">Confirm</button>
            </form>
        <c:remove var="message" scope="session" />
        <c:remove var="product" scope="session" />
    </body>
</html>