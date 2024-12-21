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

@WebServlet("/addSubCategory")
public class AddSubCategoryController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the category ID and subcategory name from the request
        String categoryId = request.getParameter("category_id");
        String subCategoryName = request.getParameter("sub_category_name");

        // Debugging: Print the received form data
        System.out.println("Received categoryId: " + categoryId);
        System.out.println("Received subCategoryName: " + subCategoryName);

        // Validate input fields are not null or empty
        if (categoryId == null || categoryId.trim().isEmpty() ||
            subCategoryName == null || subCategoryName.trim().isEmpty()) {
            
            response.sendRedirect("add_sub_category.jsp?error=Please fill all fields");
            return;
        }

        // SQL query to insert the subcategory into the database
        String sql = "INSERT INTO sub_categories (category_id, sub_category_name) VALUES (?, ?)";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            // Debugging: Print connection status
            System.out.println("Database connection established: " + (connection != null));

            // Set parameters for the SQL query
            statement.setInt(1, Integer.parseInt(categoryId));
            statement.setString(2, subCategoryName);

            // Execute the query and check if the insertion was successful
            int result = statement.executeUpdate();

            // Debugging: Print the result of the query execution
            System.out.println("Insert result: " + result);

            if (result > 0) {
                // Redirect to the dashboard if subcategory is added successfully
                response.sendRedirect("DashboardController?success=Subcategory added successfully");
            } else {
                // Error message if the insertion fails
                response.sendRedirect("add_sub_category.jsp?error=Error adding subcategory");
            }
        } catch (SQLException e) {
            // Log the error to the console (for debugging)
            e.printStackTrace();
            // Send a more detailed error message to the user
            response.sendRedirect("add_sub_category.jsp?error=Database error occurred: " + e.getMessage());
        }
    }
}
