<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Quantity</title>
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
        input[type="number"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
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
<!--</head>
<body>
    <div class="container">
        <h1>Update Quantity</h1>
        <%
            String itemId = request.getParameter("id");
            Map<String, String> itemDetails = new HashMap<>();
            String errorMessage = null;

            try {
                String url = "jdbc:mysql://localhost:3306/java_db";
                String user = "root";
                String password = "";
                Class.forName("com.mysql.jdbc.Driver");

                try (Connection connection = DriverManager.getConnection(url, user, password);
                     PreparedStatement stmt = connection.prepareStatement("SELECT id, qty FROM items WHERE id = ?")) {

                    stmt.setInt(1, Integer.parseInt(itemId));
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        itemDetails.put("id", String.valueOf(rs.getInt("id")));
                        itemDetails.put("qty", String.valueOf(rs.getInt("qty")));
                    }
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                errorMessage = "Error fetching item details: " + e.getMessage();
            }

            request.setAttribute("itemDetails", itemDetails);
            request.setAttribute("errorMessage", errorMessage);
        %>
        <form action="updateQuantity" method="post">
            <input type="hidden" name="id" value="<%= itemDetails.get("id") %>">
            <label for="qty">Quantity:</label>
            <input type="number" id="qty" name="qty" value="<%= itemDetails.get("qty") %>"><br><br>
            <input type="submit" value="Update Quantity">
        </form>
        <c:if test="${not empty errorMessage}">
            <p class="error-message"><c:out value="${errorMessage}"/></p>
        </c:if>
    </div>
</body>-->
</html>
