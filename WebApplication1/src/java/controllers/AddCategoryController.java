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

@WebServlet("/addCategory")
public class AddCategoryController extends HttpServlet {

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
        
        // Get the category name from the request
        String categoryName = request.getParameter("category_name");

        // SQL query to insert the category into the database
        String sql = "INSERT INTO categories (name) VALUES (?)";

        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement statement = connection.prepareStatement(sql)) {

            // Set parameter for the SQL query
            statement.setString(1, categoryName);

            // Execute the query and check if the insertion was successful
            int result = statement.executeUpdate();

            if (result > 0) {
                // Redirect to the dashboard if category is added successfully
                response.sendRedirect("DashboardController?success=Category added successfully");
            } else {
                // Error message if the insertion fails
                response.sendRedirect("add_category.jsp?error=Error adding category");
            }
        } catch (SQLException e) {
            // Log the error to the console (for debugging)
            e.printStackTrace();
            // Send a more detailed error message to the user
            response.sendRedirect("add_category.jsp?error=Database error occurred: " + e.getMessage());
        }
    }
}
