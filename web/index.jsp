<!DOCTYPE html>
<html>
    <head>
        <title>ListeSpesa</title>
        <%@include file="include/generalMeta.jsp" %>
    </head>
    <body>

        <div class="jumbotron">
            <div class="container text-center">
                <h1>ListeSpesa</h1>      
                <p>Crea le tue liste per portarle sempre con te</p>
            </div>
        </div>

        <%@include file="include/navigationBar.jsp"%>

        <div class="container">    
            <div class="row">
                <div class="col-sm-4">
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">FERRAMENTA</div>
                        <div class="panel-body"><a href="#"><img src="ferra.jpg" class="fit-image img-responsive" alt="Ferramenta"></a></div>
                        <div class="panel-footer-custom">Visualizza articoli di ferramenta</div>
                    </div>
                </div>
                <div class="col-sm-4"> 
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">ALIMENTARI</div>
                        <div class="panel-body"><a href="#"><img src="alimentare.jpg" class="fit-image img-responsive" alt="Image"></a> </div>
                        <div class="panel-footer-custom">Visualizza articoli di alimentari</div>
                    </div>
                </div>
                <div class="col-sm-4"> 
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">FARMACIA</div>
                        <div class="panel-body"><img src="farmacia.jpg" class="fit-image img-responsive" alt="Image"></div>
                        <div class="panel-footer-custom">Visualizza articoli di categoria</div>
                    </div>
                </div>
            </div>
        </div><br>

        <div class="container">    
            <div class="row">
                <div class="col-sm-4">
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">CATEGORIA</div>
                        <div class="panel-body"><img src="https://placehold.it/150x80?text=IMAGE" class="fit-image img-responsive" alt="Image"></div>
                        <div class="panel-footer-custom">Visualizza articoli di categoria</div>
                    </div>
                </div>
                <div class="col-sm-4"> 
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">CATEGORIA</div>
                        <div class="panel-body"><img src="https://placehold.it/150x80?text=IMAGE" class="fit-image img-responsive" alt="Image"></div>
                        <div class="panel-footer-custom">Visualizza articoli di categoria</div>
                    </div>
                </div>
                <div class="col-sm-4"> 
                    <div class="panel panel-default-custom">
                        <div class="panel-heading-custom">CATEGORIA</div>
                        <div class="panel-body"><img src="https://placehold.it/150x80?text=IMAGE" class="fit-image img-responsive" alt="Image"></div>
                        <div class="panel-footer-custom">Visualizza articoli di categoria</div>
                    </div>
                </div>
            </div>
        </div><br><br>
        <%@include file="include/footer.jsp" %>
    </body>
</html>
