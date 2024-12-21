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

@WebServlet("/deleteItem")
public class DeleteItemController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the item ID from the request
        String id = request.getParameter("id");

        // SQL query to delete the item from the database
        String sql = "DELETE FROM items WHERE id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            // Set parameter for the SQL query
            statement.setInt(1, Integer.parseInt(id));

            // Execute the query and check if the deletion was successful
            int result = statement.executeUpdate();

            if (result > 0) {
                // Redirect to the dashboard if item is deleted successfully
                response.sendRedirect("DashboardController?success=Item deleted successfully");
            } else {
                // Error message if the deletion fails
                response.sendRedirect("DashboardController?error=Error deleting item");
            }
        } catch (SQLException e) {
            // Log the error to the console (for debugging)
            e.printStackTrace();
            // Send a more detailed error message to the user
            response.sendRedirect("DashboardController?error=Database error occurred: " + e.getMessage());
        }
    }
}
