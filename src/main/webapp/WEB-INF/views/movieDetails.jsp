<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>${movie.title}</title>
</head>
<body>
<h1>${movie.title}</h1>
<p>${movie.description}</p>
<p>Ticket Price: $${movie.ticketPrice}</p>

<button onclick="location.href='${pageContext.request.contextPath}/reservation?movieId=${movie.id}'">Reserve Tickets</button>
<br><br>

<a href="${pageContext.request.contextPath}/movies">Back to Movies List</a>
</body>
</html>