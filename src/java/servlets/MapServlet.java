/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import db.daos.ShoppingListCategoryDAO;
import db.entities.User;
import db.exceptions.DAOException;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.console;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author pberi
 */
public class MapServlet extends HttpServlet {

    private ShoppingListCategoryDAO shoppingListCategoryDAO;

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
        String json = "{\"shops\":[\"deli\", \"florist\"]}";
        //String json = "{\"shops\":[]}";
        PrintWriter out = response.getWriter();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        out.print(json);
        out.flush();
        /*User user = (User) request.getSession().getAttribute("user");
        try {
            List<String> shops = shoppingListCategoryDAO.getShopsByUser(user);
            String json = "{\"shops\":[";

            for (int i = 0; i < shops.size(); i++) {
                if(i>0){ json+=", "; }
                json += "\"" + shops.get(i) + "\"";
            }
            json += "]}";
            PrintWriter out = response.getWriter();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            out.print(json);
            out.flush();
        } catch (DAOException ex) {
            Logger.getLogger(MapServlet.class.getName()).log(Level.SEVERE, null, ex);
        }*/
    }
}
