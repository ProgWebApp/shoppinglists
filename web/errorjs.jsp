<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Error Page </title>
        <%@include file="include/generalMeta.jsp" %>
    </head>
    <body>
        <div id="containerPage">
            <div id="header">
                <div class="jumbotron">
                    <div class="container text-center">
                        <h1>An error occurred</h1> 
                    </div>
                </div>
                <%@include file="include/navigationBar.jsp"%>
            </div>
            <div id="body">
                <div class="col-sm-2">
                </div>
                <div class="col-sm-8">
                    <div class="bod-container" style="width:100%;text-align:center;margin-top:20%;">
                        <h1>Ops... you have javascript disabled. Please enable it to navagate this site.</h1>
                        When you've enabled javascript, click <a href="${contextPath}index.jsp">HERE</a>
                    </div>
                </div>
            </div>
            <%@include file="include/footer.jsp" %>
        </div>
    </body>
</html>