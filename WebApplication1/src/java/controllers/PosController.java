package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modules.DatabaseConnection;

@WebServlet("/PosController")
public class PosController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("getSubcategories".equals(action)) {
            String category = request.getParameter("category");
            getSubcategories(category, response);
        } else if ("getItems".equals(action)) {
            String subcategory = request.getParameter("subcategory");
            getItems(subcategory, response);
        }
    }

    private void getSubcategories(String category, HttpServletResponse response) throws IOException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement("SELECT DISTINCT sub_category FROM items WHERE item_category = ?")) {
            
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    out.print(",");
                }
                out.print("\"" + rs.getString("sub_category") + "\"");
                first = false;
            }
            out.print("]");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void getItems(String subcategory, HttpServletResponse response) throws IOException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement("SELECT id, item_name, price_per_one FROM items WHERE sub_category = ?")) {
            
            stmt.setString(1, subcategory);
            ResultSet rs = stmt.executeQuery();

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    out.print(",");
                }
                out.print("{");
                out.print("\"id\":" + rs.getInt("id") + ",");
                out.print("\"item_name\":\"" + rs.getString("item_name") + "\",");
                out.print("\"price_per_one\":" + rs.getDouble("price_per_one"));
                out.print("}");
                first = false;
            }
            out.print("]");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
