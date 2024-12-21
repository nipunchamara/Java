<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add User</title>
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
            width: 350px;
            box-sizing: border-box;
        }

        h1 {
            font-size: 28px;
            margin-bottom: 25px;
            font-weight: 600;
        }

        label {
            font-size: 16px;
            display: block;
            margin-bottom: 10px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        input[type="submit"] {
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
        }

        input[type="submit"]:hover {
            background-color: #45a049;
            transform: translateY(-2px);
        }

        input[type="submit"]:active {
            background-color: #3e8e41;
            transform: translateY(0);
        }

        .footer {
            margin-top: 20px;
            font-size: 14px;
            color: #888;
        }

        .footer a {
            color: #4CAF50;
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }

        /* Optional Responsive Design for smaller screens */
        @media (max-width: 400px) {
            .container {
                padding: 25px;
                width: 90%;
            }

            h1 {
                font-size: 24px;
            }

            input[type="submit"] {
                font-size: 16px;
                padding: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Add User</h1>
        <form action="addUser" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username"><br><br>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email"><br><br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password"><br><br>

            <label for="phone_number">Phone Number:</label>
            <input type="text" id="phone_number" name="phone_number"><br><br>

            <input type="submit" value="Add User">
        </form>
        <c:if test="${not empty param.error}">
            <p style="color:red;">${param.error}</p>
        </c:if>
    </div>
</body>
</html>
