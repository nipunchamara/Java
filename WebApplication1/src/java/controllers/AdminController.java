package controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminController", urlPatterns = {"/AdminController"})
public class AdminController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "manage_users":
                    // Redirect to Manage Users page
                    response.sendRedirect("manage_users.jsp");
                    break;

                case "manage_items":
                    // Redirect to Manage Items page
                    response.sendRedirect("dashboard.jsp");
                    break;

                case "view_reports":
                    // Redirect to Reports page
                    response.sendRedirect("report.jsp");
                    break;

                case "super_admin_login":
                    // Redirect to Super Admin Login page
                    response.sendRedirect("super_admin_login.jsp");
                    break;

                case "pos_system":
                    // Redirect to POS System page
                    response.sendRedirect("pos.jsp");
                    break;

                case "employee_attendance":
                    // Redirect to Employee Attendance page
                    response.sendRedirect("employee_attendance.jsp");
                    break;

                default:
                    // Redirect back to Admin Dashboard if action is unrecognized
                    response.sendRedirect("admin_dashboard.jsp?error=Invalid action");
                    break;
            }
        } else {
            // Redirect back to Admin Dashboard if no action is provided
            response.sendRedirect("admin_dashboard.jsp?error=No action provided");
        }
    }
}
