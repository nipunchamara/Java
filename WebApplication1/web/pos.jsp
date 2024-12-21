<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, modules.SaleItem" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>POS System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        h1, h2 {
            text-align: center;
            color: #333;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        form {
            margin-top: 20px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        label {
            font-weight: bold;
            margin-bottom: 8px;
            display: block;
        }
        select, input[type="text"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .total-container {
            margin-top: 20px;
            font-size: 18px;
            font-weight: bold;
        }
        .grand-total {
            color: #4CAF50;
        }
        #total_price {
            color: #333;
            font-weight: bold;
        }
        .message {
            text-align: center;
            font-size: 16px;
            color: #ff4d4d;
        }
    </style>
    <script>
        function updateSubcategories() {
            var category = document.getElementById("category").value;
            var subcategories = document.getElementById("subcategory");
            subcategories.innerHTML = "<option value=''>Select Subcategory</option>";

            // Make an AJAX call to fetch subcategories based on selected category
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "PosController?action=getSubcategories&category=" + category, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    for (var i = 0; i < response.length; i++) {
                        var option = document.createElement("option");
                        option.value = response[i];
                        option.text = response[i];
                        subcategories.add(option);
                    }
                }
            };
            xhr.send();
        }

        function updateItems() {
            var subcategory = document.getElementById("subcategory").value;
            var items = document.getElementById("item");
            items.innerHTML = "<option value=''>Select Item</option>";

            // Make an AJAX call to fetch items based on selected subcategory
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "PosController?action=getItems&subcategory=" + subcategory, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    for (var i = 0; i < response.length; i++) {
                        var option = document.createElement("option");
                        option.value = response[i].id;
                        option.text = response[i].item_name + " - $" + response[i].price_per_one;
                        items.add(option);
                    }
                }
            };
            xhr.send();
        }

        function calculatePrice() {
            var item = document.getElementById("item");
            var selectedItem = item.options[item.selectedIndex].text;
            var price = parseFloat(selectedItem.split(" - $")[1]);
            var quantity = parseInt(document.getElementById("quantity").value);
            var totalPrice = price * quantity;
            document.getElementById("total_price").innerText = "Total Price: $" + totalPrice.toFixed(2);
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>POS System</h1>
        <h2>Add Sale</h2>
        <form action="SalesController" method="post">
            <label for="category">Category:</label>
            <select id="category" name="category" onchange="updateSubcategories()">
                <option value="">Select Category</option>
                <% 
                    List<String> categories = new ArrayList<>();
                    try {
                        String url = "jdbc:mysql://localhost:3306/java_db";
                        String user = "root";
                        String password = "";
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection connection = DriverManager.getConnection(url, user, password);
                        Statement stmt = connection.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT DISTINCT item_category FROM items");
                        while (rs.next()) {
                            categories.add(rs.getString("item_category"));
                        }
                        connection.close();
                    } catch (SQLException | ClassNotFoundException e) {
                        e.printStackTrace();
                    }

                    for (String category : categories) {
                %>
                    <option value="<%= category %>"><%= category %></option>
                <% 
                    }
                %>
            </select><br><br>

            <label for="subcategory">Subcategory:</label>
            <select id="subcategory" name="subcategory" onchange="updateItems()">
                <option value="">Select Subcategory</option>
            </select><br><br>

            <label for="item">Item:</label>
            <select id="item" name="item" onchange="calculatePrice()">
                <option value="">Select Item</option>
            </select><br><br>

            <label for="quantity">Quantity:</label>
            <input type="text" id="quantity" name="quantity" oninput="calculatePrice()"><br><br>

            <div id="total_price" class="total-container">Total Price: $0.00</div><br>

            <input type="submit" name="action" value="Add Item">
            <input type="submit" name="action" value="Bill Item">
        </form>

        <h2>Current Bill</h2>
        <%
            List<SaleItem> saleItems = (List<SaleItem>) session.getAttribute("saleItems");
            if (saleItems != null && !saleItems.isEmpty()) {
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
                <%
                    double grandTotal = 0;
                    for (SaleItem saleItem : saleItems) {
                        grandTotal += saleItem.getTotalPrice();
                %>
                <tr>
                    <td><%= saleItem.getItemName() %></td>
                    <td><%= saleItem.getQuantity() %></td>
                    <td>$<%= saleItem.getPricePerOne() %></td>
                    <td>$<%= saleItem.getTotalPrice() %></td>
                </tr>
                <% 
                    }
                %>
            </tbody>
        </table>
        <div id="grand_total" class="grand-total">Grand Total: $<%= grandTotal %></div>
        <% 
            } else {
        %>
        <p class="message">No items added yet.</p>
        <% 
            }
        %>
    </div>
</body>
</html>
