<select id="shop" name="shop" class="form-control">
    <option value="" <c:if test="${empty shoppingListCategory.shop}">selected</c:if> disabled>Scegli un negozio...</option>
    <option value="furniture" <c:if test="${shoppingListCategory.shop=="furniture"}">selected</c:if>>Arredamento</option>
    <option value="coffee" <c:if test="${shoppingListCategory.shop=="coffee"}">selected</c:if>>Caffetteria</option>
    <option value="chocolate" <c:if test="${shoppingListCategory.shop=="chocolate"}">selected</c:if>>Cioccolateria</option>
    <option value="computer" <c:if test="${shoppingListCategory.shop=="computer"}">selected</c:if>>Computer</option>
    <option value="doityourself" <c:if test="${shoppingListCategory.shop=="doityourself"}">selected</c:if>>Faidate</option>
    <option value="chemist" <c:if test="${shoppingListCategory.shop=="chemist"}">selected</c:if>>Farmacia</option>
    <option value="greengrocer" <c:if test="${shoppingListCategory.shop=="greengrocer"}">selected</c:if>>Fruttivendolo</option>
    <option value="ice_cream" <c:if test="${shoppingListCategory.shop=="ice_cream"}">selected</c:if>>Gelateria</option>
    <option value="garden_center" <c:if test="${shoppingListCategory.shop=="garden_center"}">selected</c:if>>Giardinaggio</option>
    <option value="toys" <c:if test="${shoppingListCategory.shop=="toys"}">selected</c:if>>Giocattoli</option>
    <option value="jawelry" <c:if test="${shoppingListCategory.shop=="jawelry"}">selected</c:if>>Gioielleria</option>
    <option value="kiosk" <c:if test="${shoppingListCategory.shop=="kiosk"}">selected</c:if>>Giornalaio</option>
    <option value="pet" <c:if test="${shoppingListCategory.shop=="pet"}">selected</c:if>>Negozio di animali</option>
    <option value="bicycle" <c:if test="${shoppingListCategory.shop=="bicycle"}">selected</c:if>>Negozio di bici</option>
    <option value="shoes" <c:if test="${shoppingListCategory.shop=="shoes"}">selected</c:if>>Negozio di scarpe</option>
    <option value="clothes" <c:if test="${shoppingListCategory.shop=="clothes"}">selected</c:if>>Negozio di vestiti</option>
    <option value="watches" <c:if test="${shoppingListCategory.shop=="watches"}">selected</c:if>>Orologeria</option>
    <option value="bakery" <c:if test="${shoppingListCategory.shop=="bakery"}">selected</c:if>>Panificio</option>
    <option value="pastry" <c:if test="${shoppingListCategory.shop=="pastry"}">selected</c:if>>Pasticceria</option>
    <option value="seafood" <c:if test="${shoppingListCategory.shop=="seafood"}">selected</c:if>>Pescheria</option>
    <option value="perfumery" <c:if test="${shoppingListCategory.shop=="perfumery"}">selected</c:if>>Profumeria</option>
    <option value="supermarket" <c:if test="${shoppingListCategory.shop=="supermarket"}">selected</c:if>>Supermercato</option>
    <option value="bag" <c:if test="${shoppingListCategory.shop=="bag"}">selected</c:if>>Valigeria</option>
</select>
