package controllers;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import modules.DatabaseConnection;

@WebServlet("/GeneratePdfReportController")
public class GeneratePdfReportController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("Generate Users PDF Report".equals(action)) {
                generatePdfReport(response, "users");
            } else if ("Generate Items PDF Report".equals(action)) {
                generatePdfReport(response, "items");
            }
        } catch (SQLException | DocumentException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }

    private void generatePdfReport(HttpServletResponse response, String tableName) 
            throws SQLException, IOException, DocumentException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=" + tableName + "_report.pdf");

        try (Connection connection = DatabaseConnection.getConnection();
             Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM " + tableName);
             OutputStream out = response.getOutputStream()) {

            // Create a PDF document
            Document document = new Document();
            PdfWriter.getInstance(document, out);

            document.open();

            // Add a title
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
            Paragraph title = new Paragraph(tableName.toUpperCase() + " REPORT", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            document.add(new Paragraph("\n")); // Add space after the title

            // Create a table with the correct number of columns
            int columnCount = rs.getMetaData().getColumnCount();
            PdfPTable table = new PdfPTable(columnCount);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            table.setSpacingAfter(10f);

            // Add table headers
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
            for (int i = 1; i <= columnCount; i++) {
                PdfPCell headerCell = new PdfPCell(new Phrase(rs.getMetaData().getColumnName(i), headerFont));
                headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(headerCell);
            }

            // Add table data
            Font dataFont = FontFactory.getFont(FontFactory.HELVETICA, 12);
            while (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    PdfPCell dataCell = new PdfPCell(new Phrase(rs.getString(i), dataFont));
                    dataCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    table.addCell(dataCell);
                }
            }

            document.add(table);
            document.close();
        }
    }
}
