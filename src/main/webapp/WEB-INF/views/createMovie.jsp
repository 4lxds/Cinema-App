<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add a movie</title>
</head>
<body>
<form action="${pageContext.request.contextPath}/movies/add" method="post">
    <label>
        <input type="text" name="title" required>
    </label>Title:<br/>

    <label>
        <textarea name="description"></textarea>
    </label>Description:<br/>

    <label>
        <input type="number" step="0.01" name="ticketPrice" required>
    </label>Ticket Price:<br/>

    <button type="submit">Create Movie</button>
</form>

</body>
</html>
