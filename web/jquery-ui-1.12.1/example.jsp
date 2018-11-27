<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="us">
    <head>
        <meta charset="utf-8">
        <%@include file="../include/generalMeta.jsp"%>
        <!--<script src="external/jquery/jquery.js"></script>-->
        <script src="jquery-ui.js"></script>
        <title>jQuery UI Example Page</title>
        <!--<link href="jquery-ui.css" rel="stylesheet">-->
        <style>
            body{
                font-family: "Trebuchet MS", sans-serif;
                margin: 50px;
            }
            .demoHeaders {
                margin-top: 2em;
            }
            #dialog-link {
                padding: .4em 1em .4em 20px;
                text-decoration: none;
                position: relative;
            }
            #dialog-link span.ui-icon {
                margin: 0 5px 0 0;
                position: absolute;
                left: .2em;
                top: 50%;
                margin-top: -8px;
            }
            #icons {
                margin: 0;
                padding: 0;
            }
            #icons li {
                margin: 2px;
                position: relative;
                padding: 4px 0;
                cursor: pointer;
                float: left;
                list-style: none;
            }
            #icons span.ui-icon {
                float: left;
                margin: 0 4px;
            }
            .fakewindowcontain .ui-widget-overlay {
                position: absolute;
            }
            select {
                width: 200px;
            }
        </style>
        
    </head>
    <body>

        <h1>Welcome to jQuery UI!</h1>

        <div class="ui-widget">
            <p>This page demonstrates the widgets and theme you selected in Download Builder. Please make sure you are using them with a compatible jQuery version.</p>
        </div>

        <h1>YOUR COMPONENTS:</h1>

        <!-- Autocomplete -->
        <h2 class="demoHeaders">Autocomplete</h2>
        <div>
            <input id="autocomplete" title="type &quot;a&quot;">
            <br>
            <h6>Mio esempio</m6>
                <input id="searchProducts">

                </div>




                <script>
                    var availableTags = [
                        "ActionScript",
                        "AppleScript",
                        "Asp",
                        "BASIC",
                        "C",
                        "C++",
                        "Clojure",
                        "COBOL",
                        "ColdFusion",
                        "Erlang",
                        "Fortran",
                        "Groovy",
                        "Haskell",
                        "Java",
                        "JavaScript",
                        "Lisp",
                        "Perl",
                        "PHP",
                        "Python",
                        "Ruby",
                        "Scala",
                        "Scheme"
                    ];
                    $("#autocomplete").autocomplete({
                        source: availableTags
                    });

                    $(function () {

                        $("#searchProducts").autocomplete({
                            source: function (request, response) {
                                $.ajax({
                                    url: "../ProductsSearchPublic",
                                    dataType: "json",
                                    data: {
                                        query: request.term
                                    },
                                    success: function (data) {
                                        response(data);
                                    },
                                    error(xhr, status, error) {
                                        console.log("error: " + error);
                                    }
                                });
                            },
                            select: function (event, ui) {
                                window.location.href = "../index.jsp";
                            }
                        });
                    });
                </script>
                </body>
                </html>
