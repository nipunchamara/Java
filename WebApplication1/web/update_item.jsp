<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Item</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-top: 20px;
        }
        form {
            width: 50%;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        label {
            display: block;
            font-size: 16px;
            margin-bottom: 8px;
            color: #333;
        }
        input[type="text"], input[type="date"], input[type="time"], textarea, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        textarea {
            height: 100px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .error-message {
            color: red;
            text-align: center;
            font-size: 14px;
            margin-top: 10px;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-top: 50px;
        }
        @media (max-width: 768px) {
            form {
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Update Item</h1>
        <%
            String itemId = request.getParameter("id");
            List<String> categoryList = new ArrayList<>();
            Map<String, String> itemDetails = new HashMap<>();
            String errorMessage = null;

            try {
                String url = "jdbc:mysql://localhost:3306/java_db";
                String user = "root";
                String password = "";
                Class.forName("com.mysql.jdbc.Driver");

                try (Connection connection = DriverManager.getConnection(url, user, password);
                     Statement stmt = connection.createStatement()) {

                    // Fetch categories
                    ResultSet rs = stmt.executeQuery("SELECT name FROM categories");
                    while (rs.next()) {
                        categoryList.add(rs.getString("name"));
                    }

                    // Fetch item details
                    PreparedStatement itemStmt = connection.prepareStatement("SELECT * FROM items WHERE id = ?");
                    itemStmt.setInt(1, Integer.parseInt(itemId));
                    ResultSet itemRs = itemStmt.executeQuery();
                    if (itemRs.next()) {
                        itemDetails.put("item_category", itemRs.getString("item_category"));
                        itemDetails.put("sub_category", itemRs.getString("sub_category"));
                        itemDetails.put("item_name", itemRs.getString("item_name"));
                        itemDetails.put("price_per_one", itemRs.getString("price_per_one"));
                        itemDetails.put("qty", itemRs.getString("qty"));
                        itemDetails.put("weight_per_one", itemRs.getString("weight_per_one"));
                        itemDetails.put("qty_updated_date", itemRs.getString("qty_updated_date"));
                        itemDetails.put("qty_updated_time", itemRs.getString("qty_updated_time"));
                        itemDetails.put("description", itemRs.getString("description"));
                    }
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                errorMessage = "Error fetching item details: " + e.getMessage();
            }

            request.setAttribute("categoryList", categoryList);
            request.setAttribute("itemDetails", itemDetails);
            request.setAttribute("errorMessage", errorMessage);
        %>
        <form action="updateItem" method="post">
            <input type="hidden" name="id" value="<%= itemId %>">
            <label for="item_category">Item Category:</label>
            <select id="item_category" name="item_category" onchange="loadSubCategories()">
                <c:forEach var="category" items="${categoryList}">
                    <option value="${category}" <c:if test="${category == itemDetails.item_category}">selected</c:if>>${category}</option>
                </c:forEach>
            </select><br><br>
            <label for="sub_category">Sub Category:</label>
            <select id="sub_category" name="sub_category">
                <option value="<%= itemDetails.get("sub_category") %>"><%= itemDetails.get("sub_category") %></option>
            </select><br><br>
            <label for="item_name">Item Name:</label>
            <input type="text" id="item_name" name="item_name" value="<%= itemDetails.get("item_name") %>"><br><br>
            <label for="price_per_one">Price per One:</label>
            <input type="text" id="price_per_one" name="price_per_one" value="<%= itemDetails.get("price_per_one") %>"><br><br>
            <label for="qty">Quantity:</label>
            <input type="text" id="qty" name="qty" value="<%= itemDetails.get("qty") %>"><br><br>
            <label for="weight_per_one">Weight per One:</label>
            <input type="text" id="weight_per_one" name="weight_per_one" value="<%= itemDetails.get("weight_per_one") %>"><br><br>
            <label for="qty_updated_date">Quantity Updated Date:</label>
            <input type="date" id="qty_updated_date" name="qty_updated_date" value="<%= itemDetails.get("qty_updated_date") %>"><br><br>
            <label for="qty_updated_time">Quantity Updated Time:</label>
            <input type="time" id="qty_updated_time" name="qty_updated_time" value="<%= itemDetails.get("qty_updated_time") %>"><br><br>
            <label for="description">Description:</label>
            <textarea id="description" name="description"><%= itemDetails.get("description") %></textarea><br><br>
            <input type="submit" value="Update Item">
        </form>
        <c:if test="${not empty errorMessage}">
            <p class="error-message"><c:out value="${errorMessage}"/></p>
        </c:if>
    </div>
</body>
</html>
