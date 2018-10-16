/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ShoppingListDAO;
import db.entities.ShoppingList;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
@MultipartConfig
public class ShoppingListServlet extends HttpServlet {

    private ShoppingListDAO shoppingListDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListDao = daoFactory.getDAO(ShoppingListDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shopping-list storage system", ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     *
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        ShoppingList shoppingList = new ShoppingList();
        Integer userId = user.getId();
        Integer shoppingListId = null;
        if (request.getParameter("shoppingListId")!=null) {
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
            try {
                shoppingList = shoppingListDao.getByPrimaryKey(shoppingListId);
                shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
            } catch (DAOException ex) {
                throw new ServletException("Impossible to get the shoppingList", ex);
            }
        }
        
        /* ID */
        shoppingList.setId(shoppingListId);

        /* NAME */
        String shoppingListName = request.getParameter("name");
        shoppingList.setName(shoppingListName);
        
        /* DESCRIPTION */
        String shoppingListDescription = request.getParameter("description");
        shoppingList.setDescription(shoppingListDescription);
        
        /* CATEGORY */
        Integer shoppingListCategoryId;
        boolean emptyListCategory = false;
        try{
            shoppingListCategoryId = Integer.valueOf(request.getParameter("shoppingListCategory"));
            shoppingList.setListCategoryId(shoppingListCategoryId);
        }catch(NumberFormatException ex){
            shoppingList.setListCategoryId(null);
            emptyListCategory = true;
        }
        /* LOGO */
        Part imageFilePart = request.getPart("image");
        Boolean emptyImage = false;
        if (shoppingListId == null && imageFilePart.getSize() == 0) {
            emptyImage = true;
            shoppingList.setImagePath(null);
        }
        /* CONTROLLO CAMPI VUOTI */
        if (shoppingListName.isEmpty() || shoppingListDescription.isEmpty() || emptyListCategory || emptyImage) {
            request.getSession().setAttribute("message", 1);
            request.getSession().setAttribute("shoppingList", shoppingList);
            response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/shoppingList.jsp"));
            return;
        }
        
        /* OWNER */
        if (shoppingListId == null) {
            shoppingList.setOwnerId(userId);
        }
        
        
        /* LOGO */
        //carico il logo solo se è stato specificato
        if (imageFilePart.getSize() > 0) {
            String imageFileName = UUID.randomUUID().toString() + Paths.get(imageFilePart.getSubmittedFileName()).getFileName().toString(); //MSIE  fix.
            String imagesFolder = "images/shoppingList";
            imagesFolder = getServletContext().getRealPath(imagesFolder);
            File imageDirectory = new File(imagesFolder);
            imageDirectory.mkdirs();
            imageFilePart.write(imagesFolder + File.separator + imageFileName);
            shoppingList.setImagePath(imageFileName);
        }

        /* INSERT OR UPDATE */
        try {
            if (shoppingListId == null) {
                shoppingListId = shoppingListDao.insert(shoppingList);
                shoppingListDao.addMember(shoppingListId, userId, 2);
                if (!user.isAdmin()) {
                    //productDao.addLinkWithUser(productId, userId); //solo per prodotti privati
                }
            } else {
                shoppingListDao.update(shoppingList);
            }
        } catch (DAOException ex) {
            throw new ServletException("Impossible to insert or update the shoppingList", ex);
        }
        response.sendRedirect(response.encodeRedirectURL(request.getAttribute("contextPath") + "restricted/shoppingLists.jsp"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer shoppingListId = null;
        try {
            shoppingListId = Integer.valueOf(request.getParameter("shoppingListId"));
        } catch (RuntimeException ex) {
            //TODO: log the exception
        }
        if (shoppingListId != null) {
            try {
                shoppingListDao.delete(shoppingListId);
            } catch (DAOException ex) {
                Logger.getLogger(ShoppingListServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
