package controllers;

import java.io.IOException;
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

@WebServlet("/updateQuantity")
public class UpdateQuantityController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the item ID and the new quantity from the form
        int itemId = Integer.parseInt(request.getParameter("id"));
        int newQty = Integer.parseInt(request.getParameter("qty"));

        // Variables to store the old quantity and the updated quantity
        int oldQty = 0;
        int updatedQty = 0;

        // SQL queries to fetch and update the item quantity in the database
        String fetchQtySql = "SELECT qty FROM items WHERE id = ?";
        String updateQtySql = "UPDATE items SET qty = ? WHERE id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement fetchQtyStmt = connection.prepareStatement(fetchQtySql);
             PreparedStatement updateQtyStmt = connection.prepareStatement(updateQtySql)) {

            // Fetch the old quantity from the database
            fetchQtyStmt.setInt(1, itemId);
            ResultSet rs = fetchQtyStmt.executeQuery();

            if (rs.next()) {
                oldQty = rs.getInt("qty");
                updatedQty = oldQty + newQty;

                // Update the quantity in the database
                updateQtyStmt.setInt(1, updatedQty);
                updateQtyStmt.setInt(2, itemId);
                int result = updateQtyStmt.executeUpdate();

                if (result > 0) {
                    // Redirect to the dashboard if the quantity is updated successfully
                    response.sendRedirect("DashboardController?success=Quantity updated successfully");
                } else {
                    // Error message if the update fails
                    response.sendRedirect("update_quantity.jsp?id=" + itemId + "&error=Error updating quantity");
                }
            } else {
                // Error message if the item is not found
                response.sendRedirect("update_quantity.jsp?id=" + itemId + "&error=Item not found");
            }
        } catch (SQLException e) {
            // Log the error to the console (for debugging)
            e.printStackTrace();
            // Send a more detailed error message to the user
            response.sendRedirect("update_quantity.jsp?id=" + itemId + "&error=Database error occurred: " + e.getMessage());
        }
    }
}
