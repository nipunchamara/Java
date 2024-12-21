<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Item</title>
    <style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f9;
        padding: 20px;
    }

    h1 {
        text-align: center;
        color: #333;
    }

    form {
        background-color: #ffffff;
        max-width: 700px;
        margin: 0 auto;
        padding: 20px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
    }

    label {
        font-size: 16px;
        color: #555;
        display: block;
        margin-bottom: 10px;
    }

    input, select, textarea {
        width: 100%;
        padding: 10px;
        margin-bottom: 20px;
        border-radius: 5px;
        border: 1px solid #ccc;
        font-size: 14px;
        color: #333;
    }

    input[type="submit"] {
        background-color: #4CAF50;
        color: white;
        border: none;
        cursor: pointer;
        font-size: 16px;
    }

    input[type="submit"]:hover {
        background-color: #45a049;
    }

    .form-row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 20px;
    }

    .form-row label {
        width: 48%;
    }

    .form-row input, .form-row select {
        width: 48%;
    }

    textarea {
        resize: vertical;
        height: 150px;
    }

    .error-message {
        color: red;
        text-align: center;
        margin-top: 10px;
    }
</style>

    <script>
        function loadSubCategories() {
            var categoryId = document.getElementById("item_category_id").value;
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "getSubCategories.jsp?categoryId=" + categoryId, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    var subCategories = JSON.parse(xhr.responseText);
                    var subCategorySelect = document.getElementById("sub_category");
                    subCategorySelect.innerHTML = "";
                    subCategories.forEach(function (subCategory) {
                        var option = document.createElement("option");
                        option.value = subCategory;
                        option.text = subCategory;
                        subCategorySelect.add(option);
                    });
                }
            };
            xhr.send();
        }
    </script>
</head>
<body>
    <h1>Add Item</h1>
    <%
        List<String[]> categoryList = new ArrayList<>();
        String errorMessage = null;

        try {
            String url = "jdbc:mysql://localhost:3306/java_db";
            String user = "root";
            String password = "";
            Class.forName("com.mysql.jdbc.Driver");

            try (Connection connection = DriverManager.getConnection(url, user, password);
                 Statement stmt = connection.createStatement()) {
                
                // Fetch categories
                ResultSet rs = stmt.executeQuery("SELECT id, name FROM categories");
                while (rs.next()) {
                    String[] category = new String[2];
                    category[0] = String.valueOf(rs.getInt("id"));
                    category[1] = rs.getString("name");
                    categoryList.add(category);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            errorMessage = "Error fetching category details: " + e.getMessage();
        }

        request.setAttribute("categoryList", categoryList);
        request.setAttribute("errorMessage", errorMessage);
    %>
    <form action="addItem" method="post">
        <label for="item_category_id">Item Category:</label>
        <select id="item_category_id" name="item_category_id" onchange="loadSubCategories()">
            <c:forEach var="category" items="${categoryList}">
                <option value="${category[0]}">${category[1]}</option>
            </c:forEach>
        </select><br><br>
        <input type="hidden" id="item_category_name" name="item_category_name">
        <label for="sub_category">Sub Category:</label>
        <select id="sub_category" name="sub_category">
            <option value="">Select Sub Category</option>
        </select><br><br>
        <label for="item_name">Item Name:</label>
        <input type="text" id="item_name" name="item_name"><br><br>
        <label for="price_per_one">Price per One:</label>
        <input type="text" id="price_per_one" name="price_per_one"><br><br>
        <label for="qty">Quantity:</label>
        <input type="text" id="qty" name="qty"><br><br>
        <label for="weight_per_one">Weight per One:</label>
        <input type="text" id="weight_per_one" name="weight_per_one"><br><br>
        <label for="qty_updated_date">Quantity Updated Date:</label>
        <input type="date" id="qty_updated_date" name="qty_updated_date"><br><br>
        <label for="qty_updated_time">Quantity Updated Time:</label>
        <input type="time" id="qty_updated_time" name="qty_updated_time"><br><br>
        <label for="description">Description:</label>
        <textarea id="description" name="description"></textarea><br><br>
        <input type="submit" value="Add Item">
    </form>
    <c:if test="${not empty errorMessage}">
        <p style="color:red;"><c:out value="${errorMessage}"/></p>
    </c:if>
    <script>
        document.getElementById("item_category_id").addEventListener("change", function() {
            var selectedCategory = this.options[this.selectedIndex].text;
            document.getElementById("item_category_name").value = selectedCategory;
        });
    </script>
</body>
</html>
