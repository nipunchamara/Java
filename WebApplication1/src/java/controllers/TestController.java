package controllers;

import modules.DatabaseConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "TestController", urlPatterns = {"/TestController"})
public class TestController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Servlet is working!");
        request.setAttribute("testMessage", "Controller and JSP are now connected!");
        RequestDispatcher dispatcher = request.getRequestDispatcher("manage_users.jsp");
        dispatcher.forward(request, response);
    }
}
