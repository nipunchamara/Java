package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/addItem")
public class AddItemController extends HttpServlet {

    private static final String URL = "jdbc:mysql://localhost:3306/java_db";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    static {
        try {
            // Explicitly load the MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("MySQL JDBC driver not found", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from the add item form
        String itemCategory = request.getParameter("item_category_name");
        String subCategory = request.getParameter("sub_category");
        String itemName = request.getParameter("item_name");
        double pricePerOne = Double.parseDouble(request.getParameter("price_per_one"));
        int qty = Integer.parseInt(request.getParameter("qty"));
        double weightPerOne = Double.parseDouble(request.getParameter("weight_per_one"));
        String qtyUpdatedDate = request.getParameter("qty_updated_date");
        String qtyUpdatedTime = request.getParameter("qty_updated_time");
        String description = request.getParameter("description");

        // SQL query to insert the item into the database
        String sql = "INSERT INTO items (item_category, sub_category, item_name, price_per_one, qty, weight_per_one, qty_updated_date, qty_updated_time, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement statement = connection.prepareStatement(sql)) {

            // Set parameters for the SQL query
            statement.setString(1, itemCategory);
            statement.setString(2, subCategory);
            statement.setString(3, itemName);
            statement.setDouble(4, pricePerOne);
            statement.setInt(5, qty);
            statement.setDouble(6, weightPerOne);
            statement.setString(7, qtyUpdatedDate);
            statement.setString(8, qtyUpdatedTime);
            statement.setString(9, description);

            // Execute the query and check if the insertion was successful
            int result = statement.executeUpdate();

            if (result > 0) {
                // Redirect to the dashboard if item is added successfully
                response.sendRedirect("DashboardController?success=Item added successfully");
            } else {
                // Error message if the insertion fails
                response.sendRedirect("add_item.jsp?error=Error adding item");
            }
        } catch (SQLException e) {
            // Log the error to the console (for debugging)
            e.printStackTrace();
            // Send a more detailed error message to the user
            response.sendRedirect("add_item.jsp?error=Database error occurred: " + e.getMessage());
        }
    }
}
