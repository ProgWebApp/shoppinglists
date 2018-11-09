/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import com.google.gson.Gson;
import db.daos.ProductDAO;
import db.entities.Product;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
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
public class ProductsSearchServlet extends HttpServlet {

    private ProductDAO productDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productDao = daoFactory.getDAO(ProductDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for product storage system", ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = (String) request.getParameter("query");
        User user = (User) request.getSession().getAttribute("user");
        
        if (query != null && request.getParameter("listCategoryId")!=null ) {
            try {
                Integer shoppingListCategoryId = Integer.valueOf(request.getParameter("listCategoryId"));
                try {
                    List<Product> products = productDao.searchByName(query, shoppingListCategoryId, user.getId());
                    StringBuilder sb = new StringBuilder();
                    sb.append("{\"results\": [");
                    for(int i=0; i<products.size(); i++){
                        if(i>0){
                            sb.append(",");
                        }
                        sb.append(products.get(i).toJson());  
                    }
                    sb.append("]}");
                    PrintWriter out = response.getWriter();
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    out.print(sb);
                    out.flush();
                } catch (DAOException ex) {
                    System.out.println("dao exception"+ex.getCause().getMessage());
                }
            } catch (NumberFormatException ex) {
                System.out.println("number exception");
            }
        }else{
            System.out.println("else");
        }
    }
}
