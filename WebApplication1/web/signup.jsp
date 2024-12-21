<!DOCTYPE html>
<html>
<head>
    <title>Sign up</title>
    <style>
        /* General Styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc; /* Light background for the entire page */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #333;
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 36px;
            color: #333;
            text-transform: uppercase;
            font-weight: bold;
        }

        /* Form Container Styling */
        form {
            background-color: #ffffff;
            padding: 40px 30px;
            border-radius: 15px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 380px;
            box-sizing: border-box;
            text-align: left;
        }

        /* Label Styling */
        label {
            font-weight: 600;
            margin-bottom: 10px;
            display: block;
            color: #555;
        }

        /* Input Fields Styling */
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 15px;
            margin-bottom: 20px;
            border: 2px solid #ccc;
            border-radius: 10px;
            font-size: 16px;
            box-sizing: border-box;
            transition: all 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 10px rgba(0, 123, 255, 0.4);
        }

        /* Button Styling */
        button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 15px;
            cursor: pointer;
            font-size: 18px;
            border-radius: 10px;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
        }

        /* Error Message Styling */
        p.error {
            text-align: center;
            color: #d9534f;
            font-weight: bold;
            margin-top: 10px;
            font-size: 14px;
        }

        /* Responsive Design */
        @media (max-width: 400px) {
            form {
                padding: 30px 20px;
                width: 90%;
            }

            h1 {
                font-size: 32px;
            }

            button {
                font-size: 16px;
            }
        }

    </style>
</head>
<body>
    <div>
        <h1>Sign up</h1>
        <form action="signup" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required><br>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" placeholder="Enter your email" required><br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required><br>

            <label for="phone_number">Mobile Number:</label>
            <input type="text" id="phone_number" name="phone_number" placeholder="Enter your mobile number" required><br>

            <button type="submit">Sign up</button>
        </form>

        <% 
            String error = request.getParameter("error");
            if (error != null) { 
        %>
            <p class="error"><%= error %></p>
        <% } %>
    </div>
</body>
</html>
