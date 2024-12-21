<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <style>
        /* General Dashboard Styling */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }

        h1 {
            text-align: center;
            color: #333333;
            margin-top: 20px;
        }

        form {
            text-align: center;
            margin: 10px;
        }

        /* Submit Button Styling */
        input[type="submit"] {
            background-color: #007bff;
            color: #ffffff;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
            transition: background-color 0.3s, transform 0.3s;
            margin: 5px;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }

        /* Table Styling */
        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #ffffff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px;
            border: 1px solid #dddddd;
            text-align: center;
        }

        th {
            background-color: #007bff;
            color: white;
            font-size: 16px;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #d1ecf1;
        }

        td form {
            display: inline-block;
            margin: 0 5px;
        }

        /* Action Buttons Styling inside Table */
        td input[type="submit"] {
            background-color: #dc3545;
            color: white;
            padding: 6px 8px;
            font-size: 14px;
            border-radius: 5px;
            transition: background-color 0.3s, transform 0.3s;
        }

        td input[type="submit"]:hover {
            background-color: #c82333;
            transform: scale(1.05);
        }

    </style>
</head>
<body>
    <h1>Dashboard</h1>
    <form action="add_category.jsp" method="get">
        <input type="submit" value="Add Category">
    </form>
    <form action="add_sub_category.jsp" method="get">
        <input type="submit" value="Add Subcategory">
    </form>
    <form action="add_item.jsp" method="get">
        <input type="submit" value="Add Item">
    </form>
    <%
        List<String[]> itemList = new ArrayList<>();
        String errorMessage = null;

        try {
            String url = "jdbc:mysql://localhost:3306/java_db";
            String user = "root";
            String password = "";
            Class.forName("com.mysql.jdbc.Driver");
            try (Connection connection = DriverManager.getConnection(url, user, password);
                 Statement stmt = connection.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM items")) {

                while (rs.next()) {
                    String[] item = new String[10];
                    item[0] = String.valueOf(rs.getInt("id"));
                    item[1] = rs.getString("item_category");
                    item[2] = rs.getString("sub_category");
                    item[3] = rs.getString("item_name");
                    item[4] = String.valueOf(rs.getDouble("price_per_one"));
                    item[5] = String.valueOf(rs.getInt("qty"));
                    item[6] = String.valueOf(rs.getDouble("weight_per_one"));
                    item[7] = String.valueOf(rs.getDate("qty_updated_date"));
                    item[8] = String.valueOf(rs.getTime("qty_updated_time"));
                    item[9] = rs.getString("description");
                    itemList.add(item);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            errorMessage = "Error fetching item details: " + e.getMessage();
        }

        // Debugging: Print the itemList size and contents
        System.out.println("Item List Size: " + itemList.size());
        for (String[] item : itemList) {
            System.out.println("Item: " + item[0] + ", " + item[1] + ", " + item[2] + ", " + item[3] + ", " + item[4] + ", " + item[5] + ", " + item[6] + ", " + item[7] + ", " + item[8] + ", " + item[9]);
        }

        request.setAttribute("itemList", itemList);
        request.setAttribute("errorMessage", errorMessage);
    %>
    <c:if test="${not empty errorMessage}">
        <p style="color:red;"><c:out value="${errorMessage}"/></p>
    </c:if>
    <c:choose>
        <c:when test="${not empty itemList}">
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
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${itemList}">
                        <tr>
                            <td>${item[0]}</td>
                            <td>${item[1]}</td>
                            <td>${item[2]}</td>
                            <td>${item[3]}</td>
                            <td>${item[4]}</td>
                            <td>${item[5]}</td>
                            <td>${item[6]}</td>
                            <td>${item[7]}</td>
                            <td>${item[8]}</td>
                            <td>${item[9]}</td>
                            <td>
                                <form action="deleteItem" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="${item[0]}">
                                    <input type="submit" value="Delete">
                                </form>
                                <form action="update_item.jsp" method="get" style="display:inline;">
                                    <input type="hidden" name="id" value="${item[0]}">
                                    <input type="submit" value="Update">
                                </form>
<!--                                <form action="update_quantity.jsp" method="get" style="display:inline;">
                                    <input type="hidden" name="id" value="${item[0]}">
                                    <input type="submit" value="Update Quantity">
                                </form>-->
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <p>No items found.</p>
        </c:otherwise>
    </c:choose>
</body>
</html>
