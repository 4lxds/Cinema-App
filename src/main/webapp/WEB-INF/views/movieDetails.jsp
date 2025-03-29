<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<div class="container mt-4">
    <div class="card bg-secondary text-white">
        <div class="card-header text-center">
            <h2 class="mb-0">${movie.title}</h2>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4 text-center">
                    <c:if test="${not empty base64Image}">
                        <img src="data:image/jpeg;base64,${base64Image}" alt="Movie Image"
                             class="img-fluid mb-3"
                             style="max-width: 300px;"/>
                    </c:if>
                </div>
                <div class="col-md-8">
                    <p class="lead">${movie.description}</p>
                    <p><strong>Ticket Price:</strong> $${movie.ticketPrice}</p>
                    <button class="btn btn-primary"
                            onclick="location.href='${pageContext.request.contextPath}/reservation?movieId=${movie.id}'">
                        Reserve Tickets
                    </button>
                </div>
            </div>
        </div>
        <div class="card-footer text-end">
            <a href="${pageContext.request.contextPath}/movies" class="btn btn-secondary"
               style="border: 1px solid #343a40;">
                Back to Movies List
            </a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>