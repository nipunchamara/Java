package controllers;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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
import modules.SaleItem;

@WebServlet("/SalesController")
public class SalesController extends HttpServlet {

    private ArrayList<SaleItem> saleItems = new ArrayList<>();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("Add Item".equals(action)) {
            addItemToSale(request, response);
        } else if ("Bill Item".equals(action)) {
            generateBill(request, response);
        }
    }

    private void addItemToSale(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String itemIdStr = request.getParameter("item");
        String quantityStr = request.getParameter("quantity");

        // Validate input
        if (itemIdStr == null || itemIdStr.isEmpty() || quantityStr == null || quantityStr.isEmpty()) {
            response.sendRedirect("pos.jsp?error=Invalid input: Item ID and Quantity are required");
            return;
        }

        int itemId;
        int quantity;
        try {
            itemId = Integer.parseInt(itemIdStr);
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("pos.jsp?error=Invalid input: Item ID and Quantity must be integers");
            return;
        }

        double pricePerOne = 0.0;
        String itemName = "";

        // Fetch price per one from items table
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement("SELECT item_name, price_per_one, qty FROM items WHERE id = ?")) {
            
            stmt.setInt(1, itemId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                pricePerOne = rs.getDouble("price_per_one");
                itemName = rs.getString("item_name");
                int currentQty = rs.getInt("qty");

                // Check if the requested quantity is available
                if (quantity > currentQty) {
                    response.sendRedirect("pos.jsp?error=Insufficient stock for item: " + itemName);
                    return;
                }

                // Update item quantity in the database
                String updateQtySql = "UPDATE items SET qty = qty - ? WHERE id = ?";
                try (PreparedStatement updateStmt = connection.prepareStatement(updateQtySql)) {
                    updateStmt.setInt(1, quantity);
                    updateStmt.setInt(2, itemId);
                    updateStmt.executeUpdate();
                }
            } else {
                response.sendRedirect("pos.jsp?error=Item not found");
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("pos.jsp?error=Database error: " + e.getMessage());
            return;
        }

        double totalPrice = pricePerOne * quantity;
        saleItems.add(new SaleItem(itemId, itemName, quantity, pricePerOne, totalPrice));
        request.getSession().setAttribute("saleItems", saleItems);
        response.sendRedirect("pos.jsp?success=Item added successfully");
    }

   private void generateBill(HttpServletRequest request, HttpServletResponse response) throws IOException {
    if (saleItems.isEmpty()) {
        response.sendRedirect("pos.jsp?error=No items to bill");
        return;
    }

    int billId = 0; // Initialize billId here

    try (Connection connection = DatabaseConnection.getConnection()) {
        // Insert bill record
        String billSql = "INSERT INTO bill (bill_date, bill_time, total_amount) VALUES (CURRENT_DATE, CURRENT_TIME, ?)";
        double totalAmount = saleItems.stream().mapToDouble(SaleItem::getTotalPrice).sum();
        try (PreparedStatement billStmt = connection.prepareStatement(billSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            billStmt.setDouble(1, totalAmount);
            billStmt.executeUpdate();
            ResultSet generatedKeys = billStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                billId = generatedKeys.getInt(1);
                System.out.println("Bill ID: " + billId);

                // Insert bill items
                String billItemSql = "INSERT INTO bill_items (bill_id, item_id, quantity, total_price) VALUES (?, ?, ?, ?)";
                try (PreparedStatement billItemStmt = connection.prepareStatement(billItemSql)) {
                    for (SaleItem saleItem : saleItems) {
                        if (saleItem.getItemId() == 0) {
                            throw new SQLException("Invalid item ID");
                        }
                        billItemStmt.setInt(1, billId);
                        billItemStmt.setInt(2, saleItem.getItemId());
                        billItemStmt.setInt(3, saleItem.getQuantity());
                        billItemStmt.setDouble(4, saleItem.getTotalPrice());
                        billItemStmt.executeUpdate();
                        System.out.println("Inserted bill item: " + saleItem.getItemName());
                    }
                }
            }
        }

        // Forward to bill.jsp
        request.getSession().setAttribute("billId", billId);
        response.sendRedirect("bill.jsp?success=Bill generated successfully");
    } catch (SQLException e) {
        e.printStackTrace();
        response.sendRedirect("pos.jsp?error=Database error: " + e.getMessage());
    }
}

}
