<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <style>
        /* General Body Styling */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5; /* Neutral background */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #333;
        }

        /* Main Container */
        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            max-width: 800px;
            width: 100%;
            padding: 20px;
            margin: 20px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .container:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        /* Header Styling */
        h1 {
            font-size: 30px;
            font-weight: 700;
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            letter-spacing: 1px;
        }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
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
        }

        /* Button Styles */
        input[type="submit"] {
            background: linear-gradient(to right, #4caf50, #81c784); /* Green gradient button */
            color: white;
            border: none;
            padding: 16px;
            font-size: 16px;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-sizing: border-box;
            margin: 5px 0;
        }

        input[type="submit"]:hover {
            background: linear-gradient(to right, #45a049, #66bb6a);
            transform: translateY(-2px);
        }

        input[type="submit"]:active {
            background: linear-gradient(to right, #45a049, #66bb6a);
            transform: translateY(0);
        }

        /* Action Button Styles (Delete and Update) */
        .delete-btn {
            background-color: #f44336; /* Red for delete */
        }

        .delete-btn:hover {
            background-color: #e53935;
        }

        .update-btn {
            background-color: #008CBA; /* Blue for update */
        }

        .update-btn:hover {
            background-color: #007BB5;
        }

        /* Form Styling for Add User Button */
        form {
            margin-bottom: 20px;
        }

        /* Error Message Styling */
        p {
            color: red;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
            margin-top: 15px;
            width: 100%;
        }

        /* Responsive Design for Smaller Screens */
        @media (max-width: 600px) {
            .container {
                padding: 20px;
                margin: 10px;
            }

            h1 {
                font-size: 24px;
            }

            input[type="submit"] {
                font-size: 14px;
            }

            table {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Manage Users</h1>
        <form action="add_user.jsp" method="get">
            <input type="submit" value="Add User">
        </form>
        <%
            List<String[]> userList = new ArrayList<>();
            String errorMessage = null;

            // Fetch users from the database
            try {
                String url = "jdbc:mysql://localhost:3306/java_db";
                String user = "root";
                String password = "";

                Class.forName("com.mysql.jdbc.Driver");
                try (Connection connection = DriverManager.getConnection(url, user, password)) {
                    Statement stmt = connection.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT id, username, email, phone_number FROM users");

                    while (rs.next()) {
                        String[] userData = new String[4];
                        userData[0] = String.valueOf(rs.getInt("id"));
                        userData[1] = rs.getString("username");
                        userData[2] = rs.getString("email");
                        userData[3] = rs.getString("phone_number");
                        userList.add(userData);
                    }
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                errorMessage = "Error fetching user details: " + e.getMessage();
            }
        %>
        <%
            if (errorMessage != null) {
        %>
            <p style="color:red;"><%= errorMessage %></p>
        <%
            } else if (!userList.isEmpty()) {
        %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Phone Number</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (String[] user : userList) {
                    %>
                        <tr>
                            <td><%= user[0] %></td>
                            <td><%= user[1] %></td>
                            <td><%= user[2] %></td>
                            <td><%= user[3] %></td>
                            <td>
                                <form action="deleteUser" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= user[0] %>">
                                    <input type="submit" value="Delete" class="delete-btn">
                                </form>
                                <form action="update_user.jsp" method="get" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= user[0] %>">
                                    <input type="hidden" name="username" value="<%= user[1] %>">
                                    <input type="hidden" name="email" value="<%= user[2] %>">
                                    <input type="hidden" name="phone_number" value="<%= user[3] %>">
                                    <input type="submit" value="Update" class="update-btn">
                                </form>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        <%
            } else {
        %>
            <p>No users found.</p>
        <%
            }
        %>
    </div>
</body>
</html>
