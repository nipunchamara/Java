<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Category</title>
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
            max-width: 450px;
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

        /* Form Styling */
        form {
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* Label Styling */
        label {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 12px;
            display: block;
            text-align: left;
            width: 100%;
            padding-left: 5px;
        }

        /* Input Field Styling */
        input[type="text"] {
            width: 100%;
            padding: 16px;
            margin: 12px 0 20px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            background-color: #f4f4f4;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        /* Focus State for Input Field */
        input[type="text"]:focus {
            border-color: #2575fc;
            outline: none;
            box-shadow: 0 0 8px rgba(37, 117, 252, 0.4);
        }

        /* Submit Button Styling */
        input[type="submit"] {
            background: linear-gradient(to right, #4caf50, #81c784); /* Green gradient button */
            color: white;
            border: none;
            padding: 18px;
            font-size: 18px;
            border-radius: 10px;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-sizing: border-box;
        }

        /* Submit Button Hover State */
        input[type="submit"]:hover {
            background: linear-gradient(to right, #45a049, #66bb6a);
            transform: translateY(-2px);
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

            input[type="text"], input[type="submit"] {
                font-size: 14px;
            }
        }

    </style>
</head>
<body>
    <div class="container">
        <h1>Add Category</h1>
        <form action="addCategory" method="post">
            <label for="category_name">Category Name:</label>
            <input type="text" id="category_name" name="category_name" placeholder="Enter category name" required><br><br>
            <input type="submit" value="Add Category">
        </form>
        <c:if test="${not empty param.error}">
            <p>${param.error}</p>
        </c:if>
    </div>
</body>
</html>
