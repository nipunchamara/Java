<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <style>
        /* General Body Styling */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7fc;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            color: #333;
        }

        /* Main Container */
        .container {
            width: 90%;
            max-width: 1100px;
            margin-top: 30px;
            padding: 30px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h1 {
            font-size: 36px;
            font-weight: 700;
            color: #2575fc;
            margin-bottom: 30px;
        }

        h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
            font-weight: 600;
        }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
            font-weight: 600;
        }

        td {
            background-color: #fafafa;
        }

        tr:nth-child(even) td {
            background-color: #f9f9f9;
        }

        /* Form Styling */
        form {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        input[type="submit"] {
            padding: 12px 24px;
            font-size: 16px;
            color: white;
            background-color: #2575fc;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #1a60c4;
        }

        /* Error Message Styling */
        p {
            color: red;
            font-weight: bold;
            margin-top: 20px;
        }

        /* Responsive Design for Smaller Screens */
        @media (max-width: 768px) {
            table {
                font-size: 14px;
            }

            input[type="submit"] {
                font-size: 14px;
                padding: 10px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Dashboard</h1>
        <%
            List<Map<String, String>> userList = new ArrayList<>();
            List<Map<String, String>> itemList = new ArrayList<>();
            String errorMessage = null;

            try {
                String url = "jdbc:mysql://localhost:3306/java_db";
                String user = "root";
                String password = "";
                Class.forName("com.mysql.jdbc.Driver");

                try (Connection connection = DriverManager.getConnection(url, user, password);
                     Statement stmt = connection.createStatement()) {
                    
                    // Fetch users
                    ResultSet rs = stmt.executeQuery("SELECT * FROM users");
                    while (rs.next()) {
                        Map<String, String> userMap = new HashMap<>();
                        userMap.put("id", String.valueOf(rs.getInt("id")));
                        userMap.put("username", rs.getString("username"));
                        userMap.put("email", rs.getString("email"));
                        userMap.put("phone_number", rs.getString("phone_number"));
                        userList.add(userMap);
                    }

                    // Fetch items
                    rs = stmt.executeQuery("SELECT * FROM items");
                    while (rs.next()) {
                        Map<String, String> itemMap = new HashMap<>();
                        itemMap.put("id", String.valueOf(rs.getInt("id")));
                        itemMap.put("item_category", rs.getString("item_category"));
                        itemMap.put("sub_category", rs.getString("sub_category"));
                        itemMap.put("item_name", rs.getString("item_name"));
                        itemMap.put("price_per_one", String.valueOf(rs.getDouble("price_per_one")));
                        itemMap.put("qty", String.valueOf(rs.getInt("qty")));
                        itemMap.put("weight_per_one", String.valueOf(rs.getDouble("weight_per_one")));
                        itemMap.put("qty_updated_date", String.valueOf(rs.getDate("qty_updated_date")));
                        itemMap.put("qty_updated_time", String.valueOf(rs.getTime("qty_updated_time")));
                        itemMap.put("description", rs.getString("description"));
                        itemList.add(itemMap);
                    }
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                errorMessage = "Error fetching data: " + e.getMessage();
            }

            request.setAttribute("userList", userList);
            request.setAttribute("itemList", itemList);
            request.setAttribute("errorMessage", errorMessage);
        %>
        <h2>Users</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Phone Number</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${userList}">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.email}</td>
                        <td>${user.phone_number}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <h2>Items</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Item Category</th>
                    <th>Sub Category</th>
                    <th>Item Name</th>
                    <th>Price per One</th>
                    <th>Quantity</th>
                    <th>Weight per One</th>
                    <th>Quantity Updated Date</th>
                    <th>Quantity Updated Time</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${itemList}">
                    <tr>
                        <td>${item.id}</td>
                        <td>${item.item_category}</td>
                        <td>${item.sub_category}</td>
                        <td>${item.item_name}</td>
                        <td>${item.price_per_one}</td>
                        <td>${item.qty}</td>
                        <td>${item.weight_per_one}</td>
                        <td>${item.qty_updated_date}</td>
                        <td>${item.qty_updated_time}</td>
                        <td>${item.description}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <h2>Generate Report</h2>
        <form action="GenerateReportController" method="post">
            <input type="submit" name="action" value="Generate Users Excel Report">
            <input type="submit" name="action" value="Generate Items Excel Report">
        </form>

        <form action="GeneratePdfReportController" method="post">
            <input type="submit" name="action" value="Generate Users PDF Report">
            <input type="submit" name="action" value="Generate Items PDF Report">
        </form>

        <c:if test="${not empty errorMessage}">
            <p><c:out value="${errorMessage}"/></p>
        </c:if>
    </div>
</body>
</html>
