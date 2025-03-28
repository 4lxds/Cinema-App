<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reserve Tickets for ${movie.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
    <style>
        .seat-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 5px;
            max-width: 500px;
            margin-bottom: 20px;
        }

        .seat-button {
            padding: 10px;
            border: none;
            border-radius: 4px;
        }

        .seat-available {
            background-color: #28a745;
        }

        .seat-reserved {
            background-color: #6c757d;
            cursor: not-allowed;
        }

        .seat-selected {
            background-color: #198754;
            color: #fff;
        }
    </style>
    <script>
        window.addEventListener("DOMContentLoaded", function () {
            const ticketInput = document.getElementById("numberOfTickets");
            let maxSeats = parseInt(ticketInput.value) || 0;
            const selectedSeats = new Set();
            const hiddenSeatInput = document.getElementById("selectedSeatIds");

            ticketInput.addEventListener("change", function () {
                maxSeats = parseInt(ticketInput.value) || 0;
                if (selectedSeats.size > maxSeats) {
                    selectedSeats.clear();
                    document.querySelectorAll(".seat-button").forEach(function (btn) {
                        btn.classList.remove("seat-selected");
                    });
                    updateHiddenInput();
                }
            });

            function updateHiddenInput() {
                hiddenSeatInput.value = Array.from(selectedSeats).join(",");
            }

            document.querySelectorAll(".seat-button").forEach(function (button) {
                if (button.disabled) return;
                button.addEventListener("click", function () {
                    const seatId = button.getAttribute("data-seat-id");
                    if (selectedSeats.has(seatId)) {
                        selectedSeats.delete(seatId);
                        button.classList.remove("seat-selected");
                    } else {
                        if (selectedSeats.size < maxSeats) {
                            selectedSeats.add(seatId);
                            button.classList.add("seat-selected");
                        } else {
                            alert("You can only select " + maxSeats + " seats.");
                        }
                    }
                    updateHiddenInput();
                });
            });
        });
    </script>
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <h1>Reserve Seats for ${movie.title}</h1>
    <c:if test="${not empty base64Image}">
        <img src="data:image/jpeg;base64,${base64Image}" alt="Movie Image" class="img-fluid mb-3"
             style="max-width: 300px;"/>
    </c:if>
    <p class="lead">Ticket Price: $${movie.ticketPrice}</p>
    <form action="${pageContext.request.contextPath}/reviewReservation" method="post">
        <input type="hidden" name="movieId" value="${movie.id}"/>
        <div class="mb-3">
            <label for="numberOfTickets" class="form-label">Number of Tickets:</label>
            <input type="number" id="numberOfTickets" name="numberOfTickets" min="1" class="form-control" required/>
        </div>
        <div class="seat-grid mb-3">
            <c:forEach var="seat" items="${seats}">
                <c:choose>
                    <c:when test="${seat.reservation != null}">
                        <button type="button"
                                class="seat-button seat-reserved btn btn-secondary"
                                disabled
                                data-seat-id="${seat.id}">
                                ${seat.seatLabel}
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button"
                                class="seat-button seat-available btn btn-outline-success"
                                data-seat-id="${seat.id}">
                                ${seat.seatLabel}
                        </button>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
        <input type="hidden" id="selectedSeatIds" name="selectedSeatIds" value=""/>
        <button type="submit" class="btn btn-primary">Reserve Selected Seats</button>
    </form>
    <br/>
    <a href="${pageContext.request.contextPath}/movies" class="btn btn-secondary">Back to Movies List</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>