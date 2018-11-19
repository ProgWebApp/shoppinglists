<select id="shop" name="shop" class="form-control">
    <option value="" <c:if test="${empty shoppingListCategory.shop}">selected</c:if> disabled>Selezionare un negozio...</option>
    <option value="furniture" <c:if test="${shoppingListCategory.shop=="furniture"}">checked</c:if>>Arredamento</option>
    <option value="coffee" <c:if test="${shoppingListCategory.shop=="coffee"}">checked</c:if>>Caffetteria</option>
    <option value="chocolate" <c:if test="${shoppingListCategory.shop=="chocolate"}">checked</c:if>>Cioccolateria</option>
    <option value="computer" <c:if test="${shoppingListCategory.shop=="computer"}">checked</c:if>>Computer</option>
    <option value="doityourself" <c:if test="${shoppingListCategory.shop=="doityourself"}">checked</c:if>>Faidate</option>
    <option value="chemist" <c:if test="${shoppingListCategory.shop=="chemist"}">checked</c:if>>Farmacia</option>
    <option value="ice_cream" <c:if test="${shoppingListCategory.shop=="ice_cream"}">checked</c:if>>Gelateria</option>
    <option value="garden_center" <c:if test="${shoppingListCategory.shop=="garden_center"}">checked</c:if>>Giardinaggio</option>
    <option value="toys" <c:if test="${shoppingListCategory.shop=="toys"}">checked</c:if>>Giocattoli</option>
    <option value="jawelry" <c:if test="${shoppingListCategory.shop=="jawelry"}">checked</c:if>>Gioielleria</option>
    <option value="kiosk" <c:if test="${shoppingListCategory.shop=="kiosk"}">checked</c:if>>Giornalaio</option>
    <option value="pet" <c:if test="${shoppingListCategory.shop=="pet"}">checked</c:if>>Negozio di animali</option>
    <option value="bicycle" <c:if test="${shoppingListCategory.shop=="bicycle"}">checked</c:if>>Negozio di bici</option>
    <option value="shoes" <c:if test="${shoppingListCategory.shop=="shoes"}">checked</c:if>>Negozio di scarpe</option>
    <option value="clothes" <c:if test="${shoppingListCategory.shop=="clothes"}">checked</c:if>>Negozio di vestiti</option>
    <option value="watches" <c:if test="${shoppingListCategory.shop=="watches"}">checked</c:if>>Orologeria</option>
    <option value="bakery" <c:if test="${shoppingListCategory.shop=="bakery"}">checked</c:if>>Panificio</option>
    <option value="pastry" <c:if test="${shoppingListCategory.shop=="pastry"}">checked</c:if>>Pasticceria</option>
    <option value="seafood" <c:if test="${shoppingListCategory.shop=="seafood"}">checked</c:if>>Pescheria</option>
    <option value="perfumery" <c:if test="${shoppingListCategory.shop=="perfumery"}">checked</c:if>>Profumeria</option>
    <option value="supermarket" <c:if test="${shoppingListCategory.shop=="supermarket"}">checked</c:if>>Supermercato</option>
    <option value="bag" <c:if test="${shoppingListCategory.shop=="bag"}">checked</c:if>>Valigeria</option>
</select>
