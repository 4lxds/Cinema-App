<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Movies</title>
</head>
<body>
<h1>Movies</h1>
<ul>
    <c:forEach var="movie" items="${movies}">
        <li>
            <a href="movie/${movie.id}">${movie.title}</a>
        </li>
    </c:forEach>
    <a href="${pageContext.request.contextPath}/movies/new">Create a New Movie</a>
</ul>
</body>
</html>