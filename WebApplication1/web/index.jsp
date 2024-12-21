<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ABC Enterprises - Home</title>
    <style>
        /* General Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        
        /* Body Styling */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f3f3f3;
        }
        
        /* Container Styling */
        .container {
            text-align: center;
            background: #fff;
            padding: 40px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
            border-radius: 8px;
        }
        
        /* Heading */
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        
        /* Description Text */
        p {
            color: #666;
            font-size: 16px;
            margin-bottom: 30px;
        }
        
        /* Button Container */
        .button-container {
            display: flex;
            gap: 20px;
            justify-content: center;
        }
        
        /* Button Styling */
        .btn {
            text-decoration: none;
            background-color: #4CAF50;
            color: #fff;
            padding: 12px 25px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to ABC Enterprises</h1>
        <p>Your one-stop solution for all enterprise needs.</p>
        
        <div class="button-container">
            <a href="login.jsp" class="btn">Sign In</a>
            <a href="signup.jsp" class="btn">Sign Up</a>
        </div>
    </div>
</body>
</html>
