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

@WebServlet("/addUser")
public class AddUserController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from the add user form
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phone_number");

        // Validate input fields are not null or empty
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            phoneNumber == null || phoneNumber.trim().isEmpty()) {
            
            response.sendRedirect("add_user.jsp?error=Please fill all fields");
            return;
        }
        
        // SQL query to insert user into the database
        String sql = "INSERT INTO users (username, email, password, phone_number) VALUES (?, ?, ?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            // Set parameters for the SQL query
            statement.setString(1, username);
            statement.setString(2, email);
            statement.setString(3, password);
            statement.setString(4, phoneNumber);

            // Execute the query and check if the insertion was successful
            int result = statement.executeUpdate();

            if (result > 0) {
                // Redirect to the manage users page if user is added successfully
                response.sendRedirect("ManageUsersController?success=User added successfully");
            } else {
                // Error message if the insertion fails
                response.sendRedirect("add_user.jsp?error=Error adding user");
            }
        } catch (SQLException e) {
            // Log the error to the console (for debugging)
            e.printStackTrace();
            // Send a more detailed error message to the user
            response.sendRedirect("add_user.jsp?error=Database error occurred: " + e.getMessage());
        }
    }
}
