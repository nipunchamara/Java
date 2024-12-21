import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;

@WebServlet("/user_dashboard")  // Ensure this matches the URL you're trying to access
public class UserDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> itemsList = new ArrayList<>();
        String errorMessage = null;

        try {
            String url = "jdbc:mysql://localhost:3306/java_db"; // Your DB details
            String user = "root"; // Your DB username
            String password = ""; // Your DB password
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            try (Connection connection = DriverManager.getConnection(url, user, password);
                 Statement stmt = connection.createStatement()) {
                
                ResultSet rs = stmt.executeQuery("SELECT name FROM items WHERE status = 'available'");
                while (rs.next()) {
                    itemsList.add(rs.getString("name"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            errorMessage = "Error fetching items: " + e.getMessage();
        }

        request.setAttribute("itemsList", itemsList);
        request.setAttribute("errorMessage", errorMessage);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user_dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
