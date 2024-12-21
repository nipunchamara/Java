package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modules.DatabaseConnection;

@WebServlet("/updateItem")
public class UpdateItemController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from the update item form
        int itemId = Integer.parseInt(request.getParameter("id"));
        String itemCategory = request.getParameter("item_category");
        String subCategory = request.getParameter("sub_category");
        String itemName = request.getParameter("item_name");
        double pricePerOne = Double.parseDouble(request.getParameter("price_per_one"));
        int qty = Integer.parseInt(request.getParameter("qty"));
        double weightPerOne = Double.parseDouble(request.getParameter("weight_per_one"));
        String qtyUpdatedDate = request.getParameter("qty_updated_date");
        String qtyUpdatedTime = request.getParameter("qty_updated_time");
        String description = request.getParameter("description");

        // SQL query to update the item details in the database
        String sql = "UPDATE items SET item_category = ?, sub_category = ?, item_name = ?, price_per_one = ?, qty = ?, weight_per_one = ?, qty_updated_date = ?, qty_updated_time = ?, description = ? WHERE id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
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
            statement.setInt(10, itemId);

            // Execute the query and check if the update was successful
            int result = statement.executeUpdate();

            if (result > 0) {
                // Redirect to the dashboard if the item is updated successfully
                response.sendRedirect("DashboardController?success=Item updated successfully");
            } else {
                // Error message if the update fails
                response.sendRedirect("update_item.jsp?id=" + itemId + "&error=Error updating item");
            }
        } catch (SQLException e) {
            // Log the error to the console (for debugging)
            e.printStackTrace();
            // Send a more detailed error message to the user
            response.sendRedirect("update_item.jsp?id=" + itemId + "&error=Database error occurred: " + e.getMessage());
        }
    }
}
