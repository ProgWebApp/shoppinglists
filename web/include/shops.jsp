<select id="shop" name="shop" class="form-control">
    <option value="" <c:if test="${empty shoppingListCategory.shop}">selected</c:if> disabled>Scegli un negozio...</option>
    <option value="furniture" <c:if test="${shoppingListCategory.shop.equals('furniture')}">selected</c:if>>Arredamento</option>
    <option value="coffee" <c:if test="${shoppingListCategory.shop.equals('coffee')}">selected</c:if>>Caffetteria</option>
    <option value="chocolate" <c:if test="${shoppingListCategory.shop.equals('chocolate')}">selected</c:if>>Cioccolateria</option>
    <option value="computer" <c:if test="${shoppingListCategory.shop.equals('computer')}">selected</c:if>>Computer</option>
    <option value="doityourself" <c:if test="${shoppingListCategory.shop.equals('doityourself')}">selected</c:if>>Faidate</option>
    <option value="chemist" <c:if test="${shoppingListCategory.shop.equals('chemist')}">selected</c:if>>Farmacia</option>
    <option value="greengrocer" <c:if test="${shoppingListCategory.shop.equals('greengrocer')}">selected</c:if>>Fruttivendolo</option>
    <option value="ice_cream" <c:if test="${shoppingListCategory.shop.equals('ice_cream')}">selected</c:if>>Gelateria</option>
    <option value="garden_center" <c:if test="${shoppingListCategory.shop.equals('garden_center')}">selected</c:if>>Giardinaggio</option>
    <option value="toys" <c:if test="${shoppingListCategory.shop.equals('toys')}">selected</c:if>>Giocattoli</option>
    <option value="jawelry" <c:if test="${shoppingListCategory.shop.equals('jawelry')}">selected</c:if>>Gioielleria</option>
    <option value="kiosk" <c:if test="${shoppingListCategory.shop.equals('kiosk')}">selected</c:if>>Giornalaio</option>
    <option value="pet" <c:if test="${shoppingListCategory.shop.equals('pet')}">selected</c:if>>Negozio di animali</option>
    <option value="bicycle" <c:if test="${shoppingListCategory.shop.equals('bicycle')}">selected</c:if>>Negozio di bici</option>
    <option value="shoes" <c:if test="${shoppingListCategory.shop.equals('shoes')}">selected</c:if>>Negozio di scarpe</option>
    <option value="clothes" <c:if test="${shoppingListCategory.shop.equals('clothes')}">selected</c:if>>Negozio di vestiti</option>
    <option value="watches" <c:if test="${shoppingListCategory.shop.equals('watches')}">selected</c:if>>Orologeria</option>
    <option value="bakery" <c:if test="${shoppingListCategory.shop.equals('bakery')}">selected</c:if>>Panificio</option>
    <option value="pastry" <c:if test="${shoppingListCategory.shop.equals('pastry')}">selected</c:if>>Pasticceria</option>
    <option value="seafood" <c:if test="${shoppingListCategory.shop.equals('seafood')}">selected</c:if>>Pescheria</option>
    <option value="perfumery" <c:if test="${shoppingListCategory.shop.equals('perfumery')}">selected</c:if>>Profumeria</option>
    <option value="supermarket" <c:if test="${shoppingListCategory.shop.equals('supermarket')}">selected</c:if>>Supermercato</option>
    <option value="bag" <c:if test="${shoppingListCategory.shop.equals('bag')}">selected</c:if>>Valigeria</option>
</select>
