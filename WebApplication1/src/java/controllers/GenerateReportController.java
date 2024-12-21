package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modules.DatabaseConnection;

@WebServlet("/GenerateReportController")
public class GenerateReportController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            if ("Generate Users Excel Report".equals(action)) {
                generateExcelReport(response, "users");
            } else if ("Generate Items Excel Report".equals(action)) {
                generateExcelReport(response, "items");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    private void generateExcelReport(HttpServletResponse response, String tableName) throws SQLException, IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment;filename=" + tableName + "_report.csv");

        try (Connection connection = DatabaseConnection.getConnection();
             Statement stmt = connection.createStatement();
             PrintWriter out = response.getWriter()) {

            ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName);
            int columnCount = rs.getMetaData().getColumnCount();

            // Write column headers
            for (int i = 1; i <= columnCount; i++) {
                if (i > 1) out.print(",");
                out.print(rs.getMetaData().getColumnName(i));
            }
            out.println();

            // Write data rows
            while (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    if (i > 1) out.print(",");
                    out.print(rs.getString(i));
                }
                out.println();
            }
        }
    }
}
