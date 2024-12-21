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

@WebServlet(name = "DashboardController", urlPatterns = {"/DashboardController"})
public class DashboardController extends HttpServlet {

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
        List<String[]> itemList = new ArrayList<>();
        String errorMessage = null;
        
        // Fetch items from the database
        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD)) {
            if (connection != null) {
                System.out.println("Connected to the database!");
            } else {
                System.out.println("Failed to make connection!");
                errorMessage = "Failed to make connection!";
            }
            
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM items");

            while (rs.next()) {
                String[] item = new String[10];
                item[0] = String.valueOf(rs.getInt("id"));
                item[1] = rs.getString("item_category");
                item[2] = rs.getString("sub_category");
                item[3] = rs.getString("item_name");
                item[4] = String.valueOf(rs.getDouble("price_per_one"));
                item[5] = String.valueOf(rs.getInt("qty"));
                item[6] = String.valueOf(rs.getDouble("weight_per_one"));
                item[7] = String.valueOf(rs.getDate("qty_updated_date"));
                item[8] = String.valueOf(rs.getTime("qty_updated_time"));
                item[9] = rs.getString("description");
                itemList.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Error fetching item details: " + e.getMessage();
        }

        // Debugging: Print the itemList size and contents
        System.out.println("Item List Size: " + itemList.size());
        for (String[] item : itemList) {
            System.out.println("Item: " + item[0] + ", " + item[1] + ", " + item[2] + ", " + item[3] + ", " + item[4] + ", " + item[5] + ", " + item[6] + ", " + item[7] + ", " + item[8] + ", " + item[9]);
        }

        // Set itemList and errorMessage as attributes
        request.setAttribute("itemList", itemList);
        request.setAttribute("errorMessage", errorMessage);

        // Forward the request to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
