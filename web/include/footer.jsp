<footer class="site-footer container-fluid text-center" id="footer">
    <p>&copy; 2018, ListeSpesa.it, All right reserved</p>  
</footer>

<script>
    window.onscroll = function() {stickit()};
    var navbar = document.getElementById("mynavbar");
    var bod = document.getElementById("body");
    var sticky = navbar.offsetTop;
    
    function stickit() {
    if (window.pageYOffset >= sticky) {
    navbar.classList.add("sticky");
    bod.classList.add("stickybody");
    } else {
    navbar.classList.remove("sticky");
    bod.classList.remove("stickybody");
    }
    }
</script>