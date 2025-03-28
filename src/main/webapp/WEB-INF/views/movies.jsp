<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Movies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <h1 class="mb-4">Movies</h1>
    <div class="row">
        <c:forEach var="movie" items="${movies}">
            <div class="col-md-3 mb-4">
                <div class="card h-100 bg-secondary text-white">
                    <a href="${pageContext.request.contextPath}/movie/${movie.id}" class="text-decoration-none text-white">
                        <c:if test="${not empty movie.base64Image}">
                            <img src="data:image/jpeg;base64,${movie.base64Image}" class="card-img-top" alt="Movie Image">
                        </c:if>
                    </a>
                    <div class="card-body">
                        <h5 class="card-title">
                            <a href="${pageContext.request.contextPath}/movie/${movie.id}" class="text-decoration-none text-white">
                                    ${movie.title}
                            </a>
                        </h5>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <a href="${pageContext.request.contextPath}/movies/new" class="btn btn-primary">Create a New Movie</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>