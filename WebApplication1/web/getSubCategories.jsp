<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String categoryId = request.getParameter("categoryId");
    List<String> subCategoryList = new ArrayList<>();
    String errorMessage = null;

    try {
        String url = "jdbc:mysql://localhost:3306/java_db";
        String user = "root";
        String password = "";
        Class.forName("com.mysql.jdbc.Driver");

        try (Connection connection = DriverManager.getConnection(url, user, password);
             PreparedStatement stmt = connection.prepareStatement("SELECT sub_category_name FROM sub_categories WHERE category_id = ?")) {
            
            stmt.setInt(1, Integer.parseInt(categoryId));
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                subCategoryList.add(rs.getString("sub_category_name"));
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        errorMessage = "Error fetching subcategory details: " + e.getMessage();
    }

    StringBuilder jsonResponse = new StringBuilder("[");
    for (int i = 0; i < subCategoryList.size(); i++) {
        jsonResponse.append("\"").append(subCategoryList.get(i)).append("\"");
        if (i < subCategoryList.size() - 1) {
            jsonResponse.append(",");
        }
    }
    jsonResponse.append("]");

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jsonResponse.toString());
%>
