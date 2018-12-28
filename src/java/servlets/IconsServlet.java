package servlets;

import db.daos.ProductCategoryDAO;
import db.entities.ProductCategory;
import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import db.factories.DAOFactory;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class IconsServlet extends HttpServlet {

    private ProductCategoryDAO productCategoryDao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        try {
            productCategoryDao = daoFactory.getDAO(ProductCategoryDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for productCategory storage system", ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer productCategoryId;
        ProductCategory productCategory;
        try {
            productCategoryId = Integer.valueOf(request.getParameter("category"));
        } catch (RuntimeException ex) {
            response.sendError(403);
            return;
        }
        if (productCategoryId != null) {
            try {
                productCategory = productCategoryDao.getByPrimaryKey(productCategoryId);
                List<String> icons = new ArrayList<>(productCategory.getIconPath());
                String json = "{\"icons\":[";
                for (int i = 0; i < icons.size(); i++) {
                    if (i > 0) {
                        json += ", ";
                    }
                    json += "\"" + icons.get(i) + "\"";
                }
                json += "]}";
                PrintWriter out = response.getWriter();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                out.print(json);
                out.flush();
            } catch (DAOException ex) {
                response.sendError(500);
            }
        }
    }
}
