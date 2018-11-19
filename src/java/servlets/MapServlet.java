/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ShoppingListCategoryDAO;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.console;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author pberi
 */
public class MapServlet extends HttpServlet {

    private ShoppingListCategoryDAO shoppingListCategoryDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            shoppingListCategoryDAO = daoFactory.getDAO(ShoppingListCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for user storage system", ex);
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /*String json = "{\"shops\":[\"deli\", \"florist\"]}";
        //String json = "{\"shops\":[]}";
        PrintWriter out = response.getWriter();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        out.print(json);
        out.flush();*/
        User user = (User) request.getSession().getAttribute("user");
        String userId = null;
        if (user == null) {
            Cookie[] cookies = request.getCookies();
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("userId")) {
                    userId = cookie.getValue();
                }
            }
        }
        if (user == null && userId == null) {
            response.setStatus(400);
            return;
        }
        System.out.println("titto a posto");
        try {
            List<String> shops = new ArrayList();
            if (user != null) {
                shops.addAll(shoppingListCategoryDAO.getShopsByUser(user.getId()));
            }
            if (userId != null) {
                String shop = shoppingListCategoryDAO.getShopByCookie(userId);
                if (shop != null) {
                    shops.add(shop);
                }
            }

            String json = "{\"shops\":[";

            for (int i = 0; i < shops.size(); i++) {
                if (i > 0) {
                    json += ", ";
                }
                json += "\"" + shops.get(i) + "\"";
            }
            json += "]}";
            PrintWriter out = response.getWriter();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            out.print(json);
            out.flush();
        } catch (DAOException ex) {
            System.out.println("impossibile trovare i negozi");
            Logger.getLogger(MapServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
