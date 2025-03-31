<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>${movie.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
    <style>
        .movie-img {
            max-width: 300px;
        }
    </style>
</head>
<body class="bg-dark text-white">
<%@ include file="header.jsp" %>
<div class="container mt-4">
    <div class="card bg-secondary text-white">
        <div class="card-header text-center">
            <h2>${movie.title}</h2>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4 text-center">
                    <c:if test="${not empty base64Image}">
                        <img src="data:image/jpeg;base64,${base64Image}" alt="Movie Image"
                             class="img-fluid mb-3" style="max-width: 300px;"/>
                    </c:if>
                </div>
                <div class="col-md-8">
                    <p class="lead">${movie.description}</p>
                    <p><strong>Ticket Price:</strong> $${movie.ticketPrice}</p>
                    <!-- If the user is authenticated, show the reserve button -->
                    <sec:authorize access="isAuthenticated()">
                        <a href="${pageContext.request.contextPath}/reservation?movieId=${movie.id}"
                           class="btn btn-primary">Reserve Seats</a>
                    </sec:authorize>
                    <!-- If not authenticated, show a warning message and login button -->
                    <sec:authorize access="!isAuthenticated()">
                        <div class="alert alert-warning mt-3" role="alert">
                            You must be logged in to reserve seats.
                        </div>
                        <a href="${pageContext.request.contextPath}/login?redirect=${pageContext.request.contextPath}/reservation?movieId=${movie.id}"
                           class="btn btn-primary">
                            Login to Reserve Seats
                        </a>
                    </sec:authorize>
                </div>
            </div>
        </div>
        <div class="card-footer text-end">
            <a href="${pageContext.request.contextPath}/movies" class="btn btn-secondary"
               style="border: 1px solid #343a40;">Back to Movies List</a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
