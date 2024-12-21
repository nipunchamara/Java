<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f0f0f0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }

            .container {
                background-color: #ffffff;
                padding: 40px 50px;
                border-radius: 12px;
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
                text-align: center;
                width: 400px;
                box-sizing: border-box;
            }

            h2 {
                font-size: 28px;
                margin-bottom: 25px;
                font-weight: 600;
            }

            form {
                margin: 0;
            }

            button {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 16px;
                font-size: 18px;
                cursor: pointer;
                width: 100%;
                border-radius: 8px;
                transition: background-color 0.3s ease, transform 0.2s ease;
                font-weight: 500;
                margin-bottom: 15px;
            }

            button:hover {
                background-color: #45a049;
                transform: translateY(-2px);
            }

            button:active {
                background-color: #3e8e41;
                transform: translateY(0);
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Admin Dashboard</h2>
            <form action="AdminController" method="post">
                <button type="submit" name="action" value="manage_users">Manage Users</button>
                <button type="submit" name="action" value="manage_items">Manage Items</button>
                <button type="submit" name="action" value="view_reports">Reports</button>
<!--                <button type="submit" name="action" value="super_admin_login">Super Admin Login</button>-->
<!--                <button type="submit" name="action" value="pos_system">Employee Attendance</button>-->
                <button type="submit" name="action" value="pos_system">POS System</button>
            </form>
        </div>
    </body>
</html>
