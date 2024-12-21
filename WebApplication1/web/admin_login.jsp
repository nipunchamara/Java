<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Login</title>
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

            h2 {
                text-align: center;
                font-size: 28px;
                margin-bottom: 25px;
                font-weight: 600;
            }

            form {
                margin: 0;
            }

            label {
                font-size: 16px;
                margin-bottom: 5px;
                display: block;
            }

            input[type="text"], input[type="password"] {
                width: 100%;
                padding: 12px;
                margin: 10px 0;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                box-sizing: border-box;
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
            }

            button:hover {
                background-color: #45a049;
                transform: translateY(-2px);
            }

            button:active {
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

                h2 {
                    font-size: 24px;
                }

                button {
                    font-size: 16px;
                    padding: 14px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Admin Login</h2>
            <form action="AdminLoginController" method="post">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required><br><br>

                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required><br><br>

                <button type="submit">Login</button>
            </form>
            <p style="color:red;">
                <% 
                    String error = request.getParameter("error");
                    if (error != null) {
                        out.print(error);
                    }
                %>
            </p>
        </div>
    </body>
</html>
