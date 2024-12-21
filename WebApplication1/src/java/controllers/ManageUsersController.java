package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ManageUsersController", urlPatterns = {"/ManageUsersController"})
public class ManageUsersController extends HttpServlet {

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<String[]> userList = new ArrayList<>();
        String errorMessage = null;
        
        // Fetch users from the database
        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD)) {
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id, username, email, phone_number FROM users");

            while (rs.next()) {
                String[] user = new String[4];
                user[0] = String.valueOf(rs.getInt("id"));
                user[1] = rs.getString("username");
                user[2] = rs.getString("email");
                user[3] = rs.getString("phone_number");
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Error fetching user details: " + e.getMessage();
        }

        // Print the userList size and contents
        System.out.println("User List Size: " + userList.size());
        for (String[] user : userList) {
            System.out.println("User: " + user[0] + ", " + user[1] + ", " + user[2] + ", " + user[3]);
        }

        // Set userList and errorMessage as attributes
        request.setAttribute("userList", userList);
        request.setAttribute("errorMessage", errorMessage);

        // Forward the request to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("manage_users.jsp");
        dispatcher.forward(request, response);
    }
}
