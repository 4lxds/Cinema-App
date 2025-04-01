<%@ include file="header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Movies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
    <style>
        .card:not(.no-scale) {
            transition: transform 0.2s;
        }

        .card:not(.no-scale):hover {
            transform: scale(1.02);
        }

        .movie-img {
            height: 500px;
            object-fit: cover;
        }
    </style>
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <div class="card bg-secondary text-white mb-4 no-scale">
        <div class="card-header text-center">
            <h1 class="mb-0">Movies List</h1>
        </div>
    </div>

    <div class="row">
        <c:forEach var="movie" items="${movies}">
            <div class="col-md-3 mb-4">
                <a href="${pageContext.request.contextPath}/movie/${movie.id}" class="text-decoration-none text-white">
                    <div class="card h-100 bg-secondary text-white">
                        <c:if test="${not empty movie.base64Image}">
                            <img src="data:image/jpeg;base64,${movie.base64Image}"
                                 class="card-img-top movie-img"
                                 alt="Movie Image">
                        </c:if>
                        <div class="card-body">
                            <h5 class="card-title text-center">${movie.title}</h5>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
    <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
    <sec:authorize access="hasRole('ADMIN')">
        <div class="d-flex justify-content-center">
            <a href="${pageContext.request.contextPath}/movies/new" class="btn btn-primary">
                Create a New Movie
            </a>
        </div>
        <br>
    </sec:authorize>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
