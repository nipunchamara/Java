<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, modules.SaleItem" %>
<!DOCTYPE html>
<html>
<head>
    <title>Bill Details</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        form {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h1>Bill Details</h1>
    <%
        int billId = (Integer) session.getAttribute("billId");
        double totalAmount = 0;
        List<SaleItem> billItems = new ArrayList<>();
        try {
            String url = "jdbc:mysql://localhost:3306/java_db";
            String user = "root";
            String password = "";
            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, user, password);
            PreparedStatement stmt = connection.prepareStatement("SELECT * FROM bill_items WHERE bill_id = ?");
            stmt.setInt(1, billId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int itemId = rs.getInt("item_id");
                int quantity = rs.getInt("quantity");
                double totalPrice = rs.getDouble("total_price");

                PreparedStatement itemStmt = connection.prepareStatement("SELECT item_name, price_per_one FROM items WHERE id = ?");
                itemStmt.setInt(1, itemId);
                ResultSet itemRs = itemStmt.executeQuery();
                if (itemRs.next()) {
                    String itemName = itemRs.getString("item_name");
                    double pricePerOne = itemRs.getDouble("price_per_one");
                    billItems.add(new SaleItem(itemId, itemName, quantity, pricePerOne, totalPrice));
                    totalAmount += totalPrice;
                }
            }
            connection.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    %>
    <table>
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Quantity</th>
                <th>Price per One</th>
                <th>Total Price</th>
            </tr>
        </thead>
        <tbody>
            <% for (SaleItem billItem : billItems) { %>
            <tr>
                <td><%= billItem.getItemName() %></td>
                <td><%= billItem.getQuantity() %></td>
                <td>$<%= billItem.getPricePerOne() %></td>
                <td>$<%= billItem.getTotalPrice() %></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <div id="grand_total">Grand Total: $<%= totalAmount %></div>
    <a href="pos.jsp">Back to POS</a>
</body>
</html>
