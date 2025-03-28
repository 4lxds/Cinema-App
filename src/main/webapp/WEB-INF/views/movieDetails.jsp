<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>${movie.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <h1>${movie.title}</h1>
    <c:if test="${not empty base64Image}">
        <img src="data:image/jpeg;base64,${base64Image}" alt="Movie Image" class="img-fluid mb-3" style="max-width: 300px;"/>
    </c:if>
    <p class="lead">${movie.description}</p>
    <p><strong>Ticket Price:</strong> $${movie.ticketPrice}</p>
    <button class="btn btn-success" onclick="location.href='${pageContext.request.contextPath}/reservation?movieId=${movie.id}'">
        Reserve Tickets
    </button>
    <br/><br/>
    <a href="${pageContext.request.contextPath}/movies" class="btn btn-secondary">Back to Movies List</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>