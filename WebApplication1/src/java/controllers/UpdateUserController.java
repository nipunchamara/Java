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

@WebServlet("/updateUser")
public class UpdateUserController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from the update user form
        String id = request.getParameter("id");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone_number");

        // Validate input fields are not null or empty
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phoneNumber == null || phoneNumber.trim().isEmpty()) {
            
            response.sendRedirect("update_user.jsp?id=" + id + "&error=Please fill all fields");
            return;
        }
        
        // SQL query to update user in the database
        String sql = "UPDATE users SET username = ?, email = ?, phone_number = ? WHERE id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            // Set parameters for the SQL query
            statement.setString(1, username);
            statement.setString(2, email);
            statement.setString(3, phoneNumber);
            statement.setInt(4, Integer.parseInt(id));

            // Execute the query and check if the update was successful
            int result = statement.executeUpdate();

            if (result > 0) {
                // Redirect to the manage users page if user is updated successfully
                response.sendRedirect("ManageUsersController?success=User updated successfully");
            } else {
                // Error message if the update fails
                response.sendRedirect("update_user.jsp?id=" + id + "&error=Error updating user");
            }
        } catch (SQLException e) {
            // Log the error to the console (for debugging)
            e.printStackTrace();
            // Send a more detailed error message to the user
            response.sendRedirect("update_user.jsp?id=" + id + "&error=Database error occurred: " + e.getMessage());
        }
    }
}
