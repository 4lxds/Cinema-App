<%@ include file="header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>My Reservations</title>
  <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
  <style>
    /* Make the overall container a bit smaller */
    .custom-container {
      max-width: 800px; /* Adjust this value as needed */
      margin: 0 auto;
    }
    .table-dark {
      background-color: #495057;
    }
    .table-dark th,
    .table-dark td {
      border-color: #343a40;
      vertical-align: middle;
    }
    /* Center text for columns 2, 3, and 4 */
    .table td:nth-child(2),
    .table td:nth-child(3),
    .table td:nth-child(4),
    .table th:nth-child(2),
    .table th:nth-child(3),
    .table th:nth-child(4) {
      text-align: center;
    }
    /* Center the Movie header for the first column */
    .table th:first-child {
      text-align: center;
    }
    /* Style for larger movie thumbnail images */
    .movie-thumb {
      max-width: 120px;
      max-height: 120px;
      object-fit: cover;
      border-radius: 4px;
    }
    /* Layout helper for the image+title cell */
    .movie-cell {
      display: flex;
      align-items: center;
    }
    .movie-title {
      margin-left: 15px; /* space between image and title */
      font-weight: 500;
      text-align: center;
    }
  </style>
</head>
<body class="bg-dark text-white">
<div class="custom-container mt-4">
  <div class="card bg-secondary text-white">
    <div class="card-header text-center">
      <h2>My Reservations</h2>
    </div>
    <div class="card-body">
      <c:choose>
        <c:when test="${not empty reservationData}">
          <table class="table table-striped table-dark">
            <thead>
              <tr>
                <!-- Combined Movie header for image and title -->
                <th scope="col">Movie</th>
                <th scope="col">Number of Tickets</th>
                <th scope="col">Seats</th>
                <th scope="col">Total Price</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="data" items="${reservationData}">
                <tr>
                  <td>
                    <div class="movie-cell">
                      <c:if test="${not empty data.movieDTO.base64Image}">
                        <img class="movie-thumb"
                             src="data:image/jpeg;base64,${data.movieDTO.base64Image}"
                             alt="${data.movieDTO.title}" />
                      </c:if>
                      <c:if test="${empty data.movieDTO.base64Image}">
                        <span class="movie-thumb"
                              style="display:inline-flex;align-items:center;justify-content:center;background:#343a40;">
                          No Image
                        </span>
                      </c:if>
                      <div class="movie-title">${data.reservation.movie.title}</div>
                    </div>
                  </td>
                  <td>${data.reservation.numberOfTickets}</td>
                  <td>${data.reservation.seats}</td>
                  <td>$${data.reservation.totalPrice}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:when>
        <c:otherwise>
          <p class="text-center">You have no reservations.</p>
        </c:otherwise>
      </c:choose>
    </div>
    <div class="card-footer text-end">
      <a href="${pageContext.request.contextPath}/movies" class="btn btn-secondary" style="border: 1px solid #343a40;">
        Back to Movies List
      </a>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
