<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
  <title>Modifica categoria</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <style>
    	.navbar {
      margin-bottom: 50px;
      border-radius: 0;
    }
    
    .navbar-inverse{
    	background-color: #ff6336;
    	border: 0px;
       
    }
    
    footer{
    	background-color: #A0A4E5;
    	color: black;
    	padding: 25px;
	}
    
  	.form-container{
    	background-color: #B9E5FF;
        text-align:left;
        border: 2px solid #A0A4E5;
        padding: 45px 5px 30px 5px;
    }
    .checkboxes-group{
    	 font: 15px monospace;
         padding: 10px 10px 0px 10px;
         display: flex;
  		 flex-wrap: wrap;
    }
    .groupped-ckbox{
    	flex: 0 0 30%; 
 		margin: 5px;
    }
    @media screen  and (max-width:525px){
  	.groupped-ckbox{ 
    	flex: 1 0 48%;
 		margin: 5px;
    }}
  </style>
</head>
    <body>
        <div class="container text-center">    
  <h2>Area di creazione categoria Lista</h2><br>
  <h4>Crea una nuova tipologia di categoria per le liste</h4><br>
  <br>
  <div class="col-sm-2">
  </div>
  <div class="col-sm-8">
    <div class="form-container ">
        <form class="form-signin" action="${pageContext.response.encodeURL("ShoppingListCategoryServlet")}" method="POST" enctype="multipart/form-data">
            <c:choose>
                <c:when test="${message==1}">
                    Compila i campi mancanti!
                    <c:if test="${empty shoppingListCategory.name}">Name</c:if>
                    <c:if test="${empty shoppingListCategory.description}">Description</c:if>
                </c:when>
            </c:choose>
            <div class="form-group">
                <label for="nome">Nome Categoria:</label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Nome" value="${shoppingListCategory.name}" autofocus>
            </div>
           <div class="form-group">
                <label for="descrizione">Descrizione:</label>
                <input type="text" id="description" name="description" class="form-control" placeholder="Descrizione" value="${shoppingListCategory.description}">
            </div>
            <div class="form-group">
                <c:if test="${not empty shoppingListCategory.logoPath}">
                <img src="../images/shoppingListCategories/<c:out value="${shoppingListCategory.logoPath}"/>" alt="Logo" height="80" width="80">
                </c:if>
                <label for="logo">Carica un logo per la categoria:</label>
                <input type="file" id="logo" name="logo" class="form-control">
            </div>
            <div class="form-group">
                <label for="categorie">Seleziona le categorie di prodotti che possono essere inserite in questa lista:</label>
                <div class="checkboxes-group">
                <c:if test="${not empty productCategories}">
                    <c:forEach items="${productCategories}" var="productCategory">
                        <div class="groupped-ckbox"><input type="checkbox" id="${productCategory.id}" name="productCategories" value="${productCategory.id}" <c:if test="${productCategorySelected.contains(productCategory)}">checked</c:if>> ${productCategory.name}</div>
                    </c:forEach>
                </c:if>
                </div>
                    <c:forEach items="${productCategorySelected}" var="productCategorySelected">${productCategorySelected.name}</c:forEach>
            </div>
            <c:if test="${not empty shoppingListCategory.id}"><input type="hidden" name="shoppingListCategoryId" value="${shoppingListCategory.id}"></c:if>
                <button type="submit" class="btn btn-default acc-btn">Invia</button>
            </form>
    </div>
    <h3><a style="color:black" href="mainpagenologged.html"><span class="glyphicon glyphicon-home"></span> Home</a></h3>
  </div>
  
</div>


<footer class="container-fluid text-center">
  <p>&copy; 2018, ListeSpesa.it, All right reserved</p> 
</footer>
        <c:remove var="message" scope="session" />
        <c:remove var="shoppingListCategory" scope="session" />
    </body>
</html>
