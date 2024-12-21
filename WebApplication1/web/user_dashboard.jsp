<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Available Items</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            width: 50%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f4f4f4;
        }
    </style>
</head>
<body>
    <h1>Available Items</h1>
    <%
        String url = "jdbc:mysql://localhost:3306/java_db";
        String user = "root";
        String password = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            Statement stmt = conn.createStatement();
            String query = "SELECT item_name FROM items"; // Fetch only item_name column
            ResultSet rs = stmt.executeQuery(query);
    %>
    <table>
        <tr>
            <th>Item Name</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("item_name") %></td>
        </tr>
        <%
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        %>
        <p style="color:red;">Error loading items: <%= e.getMessage() %></p>
        <%
        }
        %>
    </table>
</body>
</html>
